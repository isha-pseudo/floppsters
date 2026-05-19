shader_type sky;

uniform vec3 sky_yellow : source_color = vec3(1.0, 0.957, 0.424);
uniform vec3 sky_blue : source_color = vec3(0.055, 0.808, 0.682);
uniform vec3 sky_purple : source_color = vec3(1.0, 0.255, 0.953);

uniform float wave_speed = 0.25;
uniform float wave_strength = 0.12;
uniform float rotation_speed_y = 0.04;
uniform float rotation_speed_x = 0.02;

void sky() { 
	
	vec3 dir = normalize(EYEDIR);
	
	float rot_y = TIME * rotation_speed_y;
	float rot_x = TIME * rotation_speed_x;
	
	mat3 rot_y_mat = mat3(
		vec3(cos(rot_y), 0.0, sin(rot_y)),
		vec3(0.0, 1.0, 0.0),
		vec3(-sin(rot_y), 0.0, cos(rot_y))
	);
	
	mat3 rot_x_mat = mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, cos(rot_x), -sin(rot_x)),
		vec3(0.0, sin(rot_x), cos(rot_x))
	);
	
	dir = rot_x_mat * rot_y_mat * dir;
	
	float latitude = asin(dir.y);
	float longitude = atan(dir.z, dir.x);
	
	float rotated_lon = longitude + TIME * 0.04;
	
	float drift = sin(TIME * 0.1) * 0.08;
	float band_centre = 0.0 + drift;
	float band_width = 0.25;
	
	
	float wave = sin(rotated_lon * 2.0 + TIME * wave_speed) * wave_strength;
		
	
	float distance_to_band = abs(latitude - (band_centre + wave));
	float blue_mask = 1.0 - step(band_width, distance_to_band);
	
	vec3 color = mix(sky_yellow, sky_blue, blue_mask);
	COLOR = color;
	
}
