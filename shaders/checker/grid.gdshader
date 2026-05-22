shader_type spatial;

uniform vec4 line_color : source_color = vec4(0.08, 0.08, 0.08, 1.0);
uniform vec4 bg_color : source_color = vec4(0.92, 0.92, 0.92, 1.0);
uniform float grid_scale = 0.05;
uniform float line_thickness = 0.04;

void fragment() {
    // Get world position of the current pixel
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    
    // Grid on the XZ plane (works great for floors, boxes, most objects)
    vec2 uv = world_pos.xz * grid_scale;
    
    vec2 f = fract(uv);
    
    // Thin lines
    float line_x = step(f.x, line_thickness) + step(1.0 - line_thickness, f.x);
    float line_y = step(f.y, line_thickness) + step(1.0 - line_thickness, f.y);
    
    float lines = clamp(line_x + line_y, 0.0, 1.0);
    
    ALBEDO = mix(bg_color.rgb, line_color.rgb, lines);
    METALLIC = 0.0;
    ROUGHNESS = 0.85;
}