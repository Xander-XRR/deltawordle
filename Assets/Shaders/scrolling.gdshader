shader_type canvas_item;

uniform float speed = 10.0;
uniform vec2 scroll_direction = vec2(1.0, 1.0);
uniform bool pulse = true;
uniform float time_offset = 0.0;
uniform float h_transparency = 1.0;
uniform float l_transparency = 0.5;

void vertex() {
	UV = vec2(UV.x + (TIME / speed * scroll_direction.x), UV.y + (TIME / speed * scroll_direction.y) );
}

void fragment() {
	if (pulse) {
		vec4 pixel_color = texture(TEXTURE, UV);
		COLOR = vec4(pixel_color.xyz, h_transparency - (l_transparency + sin(TIME + time_offset) / 6.0));
	}
}
