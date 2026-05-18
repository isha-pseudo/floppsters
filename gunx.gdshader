shader_type sky;

uniform vec3 sky_yellow : source_color = vec3(1.0, 0.961, 0.420);
uniform vec3 sky_blue : source_color = vec3(0.055, 0.808, 0.682);


void sky() { 
    COLOR = sky_yellow;
}
