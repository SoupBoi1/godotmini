shader_type canvas_item;

uniform float wave_f : hint_range(0.0, 10, 0.0001);
uniform float wave_a : hint_range(0.0, 1, 0.01);
uniform float wave_s : hint_range(0.0, 5, 0.1);

varying vec2 world_uv; 
uniform sampler2D sct : hint_screen_texture;


void vertex() {
	world_uv = (MODEL_MATRIX*vec4(VERTEX.xy,0.0,1.0)).xy / 128.0;
}

void fragment() {
	float wave_x = sin(UV.x*wave_f + TIME*wave_s)*wave_a - wave_a;
	float wave_y = cos(UV.y*wave_f + TIME*wave_s)*wave_a - wave_a;
	
	vec2 finalUV = SCREEN_UV + vec2(wave_x,wave_y);
	
	//vec4 tex = texture(TEXTURE,finalUV);
	vec4 tex = vec4(.5,.7,1,1);
	vec4 back = texture(sct,finalUV);

	//COLOR = vec4(UV.x,UV.y,cos(intensity*TIME),1);//UV*cos(intensity*TIME)
	COLOR = mix(tex,back,.9);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
