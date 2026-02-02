shader_type canvas_item;

uniform float noise_strength : hint_range(0.0, 1.0) = 0.35;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.2;
uniform float speed = 8.0;

uniform float fade_size : hint_range(0.0, 0.5) = 0.15;
uniform float fade_softness : hint_range(0.01, 0.5) = 0.1;

// Color basal #107e7d
const vec3 BASE_COLOR = vec3(0.0627, 0.494, 0.490);

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * speed;

    // Distorsión CRT
    uv.x += sin(uv.y * 20.0 + TIME * 3.0) * 0.003;

    // Textura
    vec4 tex = texture(TEXTURE, uv);

    // Ruido animado
    float noise = rand(vec2(uv.y * 100.0, time));
    tex.rgb += noise * noise_strength;

    // Scanlines
    float scanline = sin(uv.y * 800.0) * scanline_strength;
    tex.rgb -= scanline;

    // ===== Fade en bordes =====
    float edge_x = min(uv.x, 1.0 - uv.x);
    float edge_y = min(uv.y, 1.0 - uv.y);
    float edge = min(edge_x, edge_y);

    float fade = smoothstep(fade_size, fade_size + fade_softness, edge);

    // Mezclar con color basal
    vec3 final_rgb = mix(BASE_COLOR, tex.rgb, fade);

    // Alpha final: fade * alpha de la textura * alpha de modulate
    float final_alpha = tex.a * fade * COLOR.a;

    // Aplicar color y alpha respetando modulate
    COLOR = vec4(final_rgb, final_alpha);
}
