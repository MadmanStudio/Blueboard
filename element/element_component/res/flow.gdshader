shader_type canvas_item;

uniform float frequency = 1.3;
uniform float amplitude = 1000.0;
uniform float speed = 10.0;
uniform float direction: hint_range(-1.0, 1.0) = 1.0;

uniform vec4 color1: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color2: source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = FRAGCOORD.xy;
    float sine_wave = sin(UV.x * frequency + TIME * speed * direction) * amplitude;
    uv.y += sine_wave;
    float t = sin(UV.x * frequency + TIME * speed * direction);
    vec4 final_color = t > 0.0 ? color1 : color2;
    final_color *= vec4(1.0);
    COLOR = final_color;
}