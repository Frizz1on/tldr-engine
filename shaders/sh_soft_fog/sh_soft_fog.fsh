
varying vec2 v_vTexcoord;

uniform vec2 u_resolution;
uniform float u_time;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
    vec2 texel = 1.0 / u_resolution;

    vec4 center = texture2D(gm_BaseTexture, v_vTexcoord);
    float lum_center = dot(center.rgb, vec3(0.299, 0.587, 0.114));

    float lum_left  = dot(texture2D(gm_BaseTexture, v_vTexcoord - vec2(texel.x, 0.0)).rgb, vec3(0.299,0.587,0.114));
    float lum_right = dot(texture2D(gm_BaseTexture, v_vTexcoord + vec2(texel.x, 0.0)).rgb, vec3(0.299,0.587,0.114));
    float lum_up    = dot(texture2D(gm_BaseTexture, v_vTexcoord - vec2(0.0, texel.y)).rgb, vec3(0.299,0.587,0.114));
    float lum_down  = dot(texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, texel.y)).rgb, vec3(0.299,0.587,0.114));

    float edge_strength =
        abs(lum_center - lum_left) +
        abs(lum_center - lum_right) +
        abs(lum_center - lum_up) +
        abs(lum_center - lum_down);

    float edge = smoothstep(0.05, 0.15, edge_strength);

    // ---- FOG NOISE ----
    float noise = rand(v_vTexcoord * 200.0 + u_time * 0.2);
    float fog = smoothstep(0.3, 0.7, noise) * 0.15;

    vec3 base_black = vec3(fog);          // subtle animated fog
    vec3 outline_color = vec3(0.35);      // grey outlines

    vec3 final_color = mix(base_black, outline_color, edge);

    gl_FragColor = vec4(final_color, center.a);
}