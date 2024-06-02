shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float threshold : hint_range(0.0, 1.0) = 0.5; // Adjustable threshold value

void fragment() {
    vec4 tex_color = texture(screen_texture, SCREEN_UV);
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114)); // Convert to grayscale
    float bw = gray > threshold ? 1.0 : 0.0; // Apply threshold

    vec3 lightColor = vec3(178.0/255.0, 174.0/255.0, 167.0/255.0); // Hex #b2aea7
    vec3 darkColor = vec3(49.0/255.0, 48.0/255.0, 39.0/255.0); // Hex #313027

    vec3 finalColor = mix(darkColor, lightColor, bw); // Mix based on the threshold result
    COLOR = vec4(finalColor, tex_color.a); // Set color to the mixed color and preserve alpha
}
