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
	
	// blue rotation //
	
	float rot_y_blue = TIME * rotation_speed_y;
	float rot_x_blue = TIME * rotation_speed_x;
	
	mat3 rot_y_blue_mat = mat3(
		vec3(cos(rot_y_blue), 0.0, sin(rot_y_blue)),
		vec3(0.0, 1.0, 0.0),
		vec3(-sin(rot_y_blue), 0.0, cos(rot_y_blue))
	);
	
	mat3 rot_x_blue_mat = mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, cos(rot_x_blue), -sin(rot_x_blue)),
		vec3(0.0, sin(rot_x_blue), cos(rot_x_blue))
	);
	
	vec3 dir_blue = rot_x_blue_mat * rot_y_blue_mat * dir;
	
	// purple rotation //
	
	float rot_y_purple = (TIME * (rotation_speed_y * 0.45)) + -1.0;
	float rot_x_purple = TIME * (rotation_speed_x * 2.7)+ -1.2 ;
	
	mat3 rot_y_purple_mat = mat3(
		vec3(cos(rot_y_purple), 0.0, sin(rot_y_purple)),
		vec3(0.0, 1.0, 0.0),
		vec3(-sin(rot_y_purple), 0.0, cos(rot_y_purple))
	);
	
	mat3 rot_x_purple_mat = mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, cos(rot_x_purple), -sin(rot_x_purple)),
		vec3(0.0, sin(rot_x_purple), cos(rot_x_purple))
	);
	
	vec3 dir_purple = rot_x_purple_mat * rot_y_purple_mat * dir;
	
	// blue
	
	float latitude_blue = asin(dir_blue.y);
	float longitude_blue = atan(dir_blue.z, dir_blue.x);
	
	float rotated_lon_blue = longitude_blue + TIME * 0.04;
	
	float drift_blue = sin(TIME * 0.1) * 0.08;
	float band_centre_blue = 0.0 + drift_blue;
	float band_width_blue = 0.25;
	
	float wave_blue = sin(rotated_lon_blue * 2.0 + TIME * wave_speed) * wave_strength;
		
	
	float distance_to_band_blue = abs(latitude_blue - (band_centre_blue + wave_blue));
	float blue_mask = 1.0 - step(band_width_blue, distance_to_band_blue);
	
	// purple
	
	float latitude_purple = asin(dir_purple.y);
	float longitude_purple = atan(dir_purple.z, dir_purple.x);
	
	float rotated_lon_purple = longitude_purple + TIME * 0.042;
	
	float drift_purple = sin(TIME * 0.11) * 0.06;
	float band_centre_purple = 0.0 + drift_purple;
	float band_width_purple = 0.24;
	
	float wave_purple = sin(rotated_lon_purple * 2.0 + TIME * wave_speed) * wave_strength;
		
	
	float distance_to_band_purple = abs(latitude_purple - (band_centre_purple + wave_purple));
	float purple_mask = 1.0 - step(band_width_purple, distance_to_band_purple);
	
	vec3 color = mix(sky_yellow, sky_blue, blue_mask);
	color = mix(color, sky_purple, purple_mask);
	
	COLOR = color;
	
}
