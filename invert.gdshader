shader_type canvas_item;

uniform sampler2D viewport_texture;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 screen_color = texture(viewport_texture, uv);
	COLOR = vec4(1.0 - screen_color.rgb, screen_color.a);
}