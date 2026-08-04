shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float wave_speed = 2.0; //wave loop speed
uniform float wave_freq = 2.0; //wave vertical freq
uniform float wave_width = 1; //wave width 
void fragment(){
	vec2 scale_UV = SCREEN_UV;
	vec2 wave_uv_offset;
	wave_uv_offset.x = cos((TIME*wave_speed)+UV.x+UV.y*wave_freq*2.0)*wave_width*0.01;
	//COLOR = vec4(wave_uv_offset,0.0,1.0);
	COLOR = texture(SCREEN_TEXTURE,scale_UV+wave_uv_offset);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
