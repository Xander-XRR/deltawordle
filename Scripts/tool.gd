extends Node2D

signal onset_detected(bus_name: String, flux: float, db: float)

@export var bus_name: String = "Music"
@export var effect_index: int = 0

# Frequency band parameters
@export var min_freq: float = 50.0
@export var max_freq: float = 8000.0
@export var band_count: int = 24   # number of frequency bands

# Detection params
@export var smoothing_alpha: float = 0.2   # smoothing for magnitudes
@export var flux_ema_alpha: float = 0.3    # smoothing for flux
@export var detection_multiplier: float = 3.0  # threshold = mean_flux + multiplier * std_flux
@export var cooldown_ms: int = 120         # min milliseconds between onsets

# Optional: limit detection to stronger peaks only
@export var min_flux_for_detection: float = 0.002

# Internal
var bus_index: int = -1
var spectrum_instance = null
var prev_mags: PackedFloat32Array = []
var smooth_mags: PackedFloat32Array = []
var last_onset_time_ms: int = -100000
var flux_history: PackedFloat32Array = []   # sliding window of recent flux values for adaptive threshold
var flux_window_size: int = 50
var flux_ema: float = 0.0

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("Bus '%s' not found" % bus_name)
		return
	spectrum_instance = AudioServer.get_bus_effect_instance(bus_index, effect_index)
	if not spectrum_instance:
		push_warning("No SpectrumAnalyzer instance at index %d on bus %s" % [effect_index, bus_name])
	prev_mags.resize(band_count)
	smooth_mags.resize(band_count)
	flux_history.resize(flux_window_size)
	for i in range(band_count):
		prev_mags[i] = 0.0
		smooth_mags[i] = 0.0
	for i in range(flux_window_size):
		flux_history[i] = 0.0

func _process(delta: float) -> void:
	if not spectrum_instance:
		return

	# 1) sample band magnitudes (we use linear spacing; can use log spacing for musical response)
	var band_width = (max_freq - min_freq) / float(band_count)
	var mags = PackedFloat32Array()
	mags.resize(band_count)
	for i in range(band_count):
		var fmin = min_freq + i * band_width
		var fmax = fmin + band_width
		# returns Vector2 for stereo channels; combine channels to single magnitude
		var mag2 = spectrum_instance.get_magnitude_for_frequency_range(fmin, fmax)
		var mag = (mag2.x + mag2.y) * 0.5
		# simple smoothing of instantaneous magnitudes to reduce tiny jitters
		smooth_mags[i] = lerp(smooth_mags[i], mag, smoothing_alpha)
		mags[i] = smooth_mags[i]

	# 2) compute spectral flux: sum of positive differences between mags and prev_mags
	var flux: float = 0.0
	for i in range(band_count):
		var diff = mags[i] - prev_mags[i]
		if diff > 0.0:
			flux += diff
		prev_mags[i] = mags[i]

	# 3) smooth flux with EMA to make thresholding more stable
	flux_ema = lerp(flux_ema, flux, flux_ema_alpha)

	# 4) update flux history for adaptive thresholding
	_push_flux_history(flux_ema)

	# compute adaptive threshold: mean + detection_multiplier * std
	var mean_flux = _mean(flux_history)
	var std_flux = _std(flux_history, mean_flux)
	var threshold = mean_flux + detection_multiplier * std_flux

	# 5) detection decision: flux_ema must exceed both absolute min and adaptive threshold,
	#    and respect cooldown
	var now_ms = Time.get_ticks_msec()
	var time_ok = (now_ms - last_onset_time_ms) >= cooldown_ms
	if time_ok and flux_ema >= threshold and flux_ema >= min_flux_for_detection:
		last_onset_time_ms = now_ms
		var db = linear_to_db(flux_ema) if flux_ema > 0.0 else -80.0
		emit_signal("onset_detected", bus_name, flux_ema, db)
		# debug print (comment out in production)
		# print("Onset: flux=%.6f threshold=%.6f mean=%.6f std=%.6f" % [flux_ema, threshold, mean_flux, std_flux])

# ---------------- Helpers ----------------
func _push_flux_history(v: float) -> void:
	# shift left, append at end (simple ring buffer would be more efficient)
	for i in range(flux_window_size - 1):
		flux_history[i] = flux_history[i + 1]
	flux_history[flux_window_size - 1] = v

func _mean(arr: PackedFloat32Array) -> float:
	var s: float = 0.0
	for x in arr:
		s += x
	return s / max(1, arr.size())

func _std(arr: PackedFloat32Array, mean_val: float) -> float:
	var s: float = 0.0
	for x in arr:
		var d = x - mean_val
		s += d * d
	return sqrt(s / max(1, arr.size()))
