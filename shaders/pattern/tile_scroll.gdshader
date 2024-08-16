shader_type canvas_item;

uniform float max_col_b = 0.22;

uniform vec2 direction = vec2(1.0, 1.0);
uniform float speed_scale = 0.5;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D SPRITE_TEXTURE; // Texture of the sprite

float line(float col_b){
	return (1.0/max_col_b)*col_b;
}

void fragment(){
	vec4 col = texture(TEXTURE,UV).rgba;
	
	//COLOR=col;
	
	vec2 move = direction * TIME * speed_scale;
	
	COLOR = texture(TEXTURE, UV + move);
	
	vec4 screen_pixel = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
    vec4 sprite_pixel = texture(SPRITE_TEXTURE, SCREEN_UV);
    
	if (col.r<=24.0 && col.g<=24.0 &&  col.b <= max_col_b) {
		col.a = line(col.b);
	}
	if (screen_pixel.a <= 0.5) { // Checking if the pixel on the screen is transparent
        COLOR.a = 0.0;
    }
}
