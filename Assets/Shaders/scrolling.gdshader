shader_type canvas_item;

uniform float speed = 10.0;
uniform vec2 scroll_direction = vec2(1.0, 1.0);
uniform bool pulse = true;
uniform float transparency = 0.5;

void vertex() {
	UV = vec2(UV.x + (TIME / speed * scroll_direction.x), UV.y + (TIME / speed * scroll_direction.y) );
}

void fragment() {
	if (pulse) {
		vec4 pixel_color = texture(TEXTURE, UV);
		COLOR = vec4(pixel_color.xyz, pixel_color.a - (transparency + sin(TIME) / 6.0));
	}
}
