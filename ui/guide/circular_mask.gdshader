shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius = 0.1;
uniform float mask_alpha = 0.7;

void fragment() {
	float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 adjusted_uv = SCREEN_UV;
	adjusted_uv.y *= aspect_ratio;
	vec2 adjusted_center = center;
	adjusted_center.y *= aspect_ratio;
	float dist = distance(adjusted_uv, adjusted_center);
	float alpha = dist > radius ? mask_alpha : 0.0;
	COLOR = vec4(0.0, 0.0, 0.0, alpha);
}