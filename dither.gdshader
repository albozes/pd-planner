shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 screen_resolution = vec2(400.0, 240.0); // Desired monochrome screen resolution

const mat4 bayerIndex = mat4(
	vec4(00.0/16.0, 12.0/16.0, 03.0/16.0, 15.0/16.0),
	vec4(08.0/16.0, 04.0/16.0, 11.0/16.0, 07.0/16.0),
	vec4(02.0/16.0, 14.0/16.0, 01.0/16.0, 13.0/16.0),
	vec4(10.0/16.0, 06.0/16.0, 09.0/16.0, 05.0/16.0));

void fragment() {
	// Get the current screen resolution
	vec2 iResolution = vec2(textureSize(SCREEN_TEXTURE, 0));

	// Calculate UV coordinates for the lower resolution texture
	vec2 uv = floor(FRAGCOORD.xy / iResolution.xy * screen_resolution) / screen_resolution;

	// Sample the texture at the lower resolution
	vec4 col = texture(SCREEN_TEXTURE, uv);
	
	// Convert to grayscale
	float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
	col = vec4(vec3(gray), col.a);
	
	// Gamma correction
	col = vec4(pow(col.rgb, vec3(2.2)) - 0.004, col.a);
	
	// Find Bayer matrix entry based on fragment position
	float bayerValue = bayerIndex[int(FRAGCOORD.x) % 4][int(FRAGCOORD.y) % 4];

	// Map to custom colors
	vec3 black_color = vec3(49.0 / 255.0, 48.0 / 255.0, 39.0 / 255.0);
	vec3 white_color = vec3(177.0 / 255.0, 175.0 / 255.0, 167.0 / 255.0);
	vec3 mapped_color = mix(black_color, white_color, step(bayerValue, col.r));

	// Output monochrome dithered image
	COLOR = vec4(mapped_color, col.a);
}
