
uniform sampler2D ColorTexture;
uniform float m_curve_x;
uniform float m_curve_y;
uniform float m_scale_x;
uniform float m_scale_y;
uniform float m_translate_x;
uniform float m_translate_y;
uniform float m_resolution_x;
uniform float m_resolution_y;
uniform float m_scanline_intensity;
uniform float m_rgb_split_intensity;
uniform float m_brightness;
uniform float m_contrast;
uniform float m_gamma;

void shader(){
	vec2 texcoords=(b3d_ClipPosition.st/b3d_ClipPosition.w)*0.5+0.5;
	
	// get color for position on screen:
	vec2 resfac = vec2(m_resolution_x, m_resolution_y)/vec2(800.0, 600.0);
	float bl = 0.03;
	float x = texcoords.x*(1.0+bl)-bl/2.0;
	float y = texcoords.y*(1.0+bl)-bl/2.0;
	float x2 = (x-0.5)*(1.0+  0.5*(0.3*m_curve_x)  *((y-0.5)*(y-0.5)))/m_scale_x+0.5-m_translate_x;
	float y2 = (y-0.5)*(1.0+  0.25*(0.3*m_curve_y)  *((x-0.5)*(x-0.5)))/m_scale_y+0.5-m_translate_y;
	vec2 v2 = vec2(x2, y2);
	vec4 temp = texture2D(ColorTexture, v2*resfac);
	
	// brightness and contrast:
	temp = clamp(vec4((temp.rgb - 0.5) * (m_contrast*2.0) + 0.5 + (m_brightness*2.0-1.0), 1.0), 0.0, 1.0);
	
	// gamma:
	float gamma2 = 2.0-m_gamma*2.0;
	temp = vec4(pow(abs(temp.r), gamma2),pow(abs(temp.g), gamma2),pow(abs(temp.b), gamma2), 1.0);
	
	// grb splitting and scanlines:
	if (v2.x<0.0 || v2.x>1.0 || v2.y<0.0 || v2.y>1.0) {
		temp = vec4(0.0,0.0,0.0,1.0);
	}else{

		float cr = sin((x2*m_resolution_x)               *2.0*3.1415) * 0.5+0.5+0.1;
		float cg = sin((x2*m_resolution_x-1.0*2.0*3.1415)*2.0*3.1415) * 0.5+0.5+0.1;
		float cb = sin((x2*m_resolution_x-2.0*2.0*3.1415)*2.0*3.1415) * 0.5+0.5+0.1;
		temp = mix(temp*vec4(cr,cg,cb,1.0),temp,1.0-m_rgb_split_intensity);
		float ck = (sin((y2*m_resolution_y)*2.0*3.1415) +0.5+0.1)*m_scanline_intensity;
		temp = temp*0.9 + temp*ck*0.1;
	}
	
	// final color:
	b3d_FragColor = vec4((temp.rgb)*0.9+0.1, 1.0);
}

