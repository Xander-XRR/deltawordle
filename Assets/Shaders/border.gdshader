shader_type canvas_item;

uniform float border_thickness : hint_range(1.0, 50.0) = 5.0;

void fragment() {
	vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;

	vec2 pixel_coord = UV * tex_size;

	float left = pixel_coord.x;
	float right = tex_size.x - pixel_coord.x;
	float top = pixel_coord.y;
	float bottom = tex_size.y - pixel_coord.y;

	float edge_distance = min(min(left, right), min(top, bottom));

	if (edge_distance > border_thickness) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
}
