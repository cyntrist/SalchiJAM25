shader_type spatial;
render_mode unshaded;
//render_mode blend_mul;

//INSTRUCTIONS: Simply uncomment or comment lines 92 and/or 101 to
//        activate/deactivate color behaviors

// If you feel so inclined, make yourself some uniforms to toggle/interpolate between the behaviors

//uniform float fiddler: hint_range(0.0, 1.0);
uniform float rows = 4.0;
uniform float cols = 4.0;
uniform float dither_size = 3.0;

uniform sampler2D pal: source_color, filter_nearest;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;


vec3 get_srgb(vec3 xyz) {

	vec3 output = vec3(pow(xyz.x, 2.2), pow(xyz.y, 2.2), pow(xyz.z, 2.2));

	return output;
}

vec3 get_linear(vec3 xyz) {

	vec3 output = vec3(pow(xyz.x, .45), pow(xyz.y, .45), pow(xyz.z, .45));

	return output;
}

float PickColor(float x, float y) {
	float output = 0.0;

	float offset = 1.0/(rows*cols*8.0);

	x = clamp(x, 0.0, 1.0);
	y =  clamp(y,0.0, 1.0);

	x = round(x*(cols-1.0))/(cols*rows);
	y = round(y*(rows-1.0))/(rows) ;

	output = y+x + offset;

	return output;
}

vec3 dither(vec3 color_in, vec2 uv, vec2 screen_size) {
	float dith = max(1.0, dither_size);
	vec3 unaltered = color_in;
	float m = cols; float d = rows*cols;

	color_in = vec3(pow(color_in.r, 0.45), pow(color_in.g, 0.45),pow(color_in.b, 0.45));

	float output = 0.0;
	float a = floor(mod(uv.x * screen_size.x/dith, 2.0));
	float b = floor(mod(uv.y * screen_size.y/dith, 2.0));
	float c = mod(a + b, 2.0)/(cols);

	color_in.r += c/(m);
	color_in.g += c/(m);
	color_in.b += c/(m);

	c = 1.0/(m) - c;

	color_in.r -= c/(m);
	color_in.g -= c/(m);
	color_in.b -= c/(m);

	color_in = vec3(round(color_in.r*(d))/(d),round(color_in.g*(d))/(d),round(color_in.b*(d))/(d));

	color_in = vec3(pow(color_in.r, 2.2),pow(color_in.g, 2.2),pow(color_in.b, 2.2));
	return color_in;
	//return unaltered;
}

vec3 dither2(vec3 color_in, vec2 uv, vec2 screen_size) {


	return color_in;
}

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);;
	// Called for every vertex the material is visible on.
}

void fragment() {
	float index = 0.0;

	//vec3 tex_uv = vec3(UV, 0.0);
	vec4 _tex = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);

	float newval = 0.0;

	vec3 color = _tex.rgb;

	//color.r = dither(color, SCREEN_UV, VIEWPORT_SIZE).r; //############### comment this line if you do not want to dither the palette

	vec3 corr = get_linear(color.rgb);

	index = PickColor(corr.r, corr.g);

	vec3 pal_read = textureLod(pal, vec2(index, 0.0), 0.0).rgb;

	ALBEDO.rgb = pal_read;
	//ALBEDO.rgb = dither(color, SCREEN_UV, VIEWPORT_SIZE);
	//############## Uncomment the line above to disable the palette, and dither the regular screen colors
}
