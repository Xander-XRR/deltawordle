shader_type canvas_item;

uniform vec2 target_uv = vec2(0.5, 0.5);

void vertex() {
	
}

void fragment() {
	vec2 clamped_target_uv = clamp(target_uv, 0.0, 1.0);
	COLOR = vec4(UV + clamped_target_uv, 0.5, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
