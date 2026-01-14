shader_type canvas_item;
uniform vec2 obj1;
uniform float thrshold;
uniform float outline;

vec3 sdgCircle(in vec2 UV_, in vec2 p, in float r )
{
    float l = distance(p,UV_);
    return vec3( l-r, p/l );
}



void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
	vec3 dg = sdgCircle(UV,obj1,.1);

	float distantobjs = distance(obj1,UV);
	float distantsin = sin(distantobjs*500.0+TIME) ;
	float distant_fill = distantobjs;
	if(distant_fill < thrshold){
		distant_fill = 1.0;
	}
	else{
		distant_fill = 0.0;
	}
	float distant_outline = distantobjs;
	if(distant_outline < thrshold+outline){
		distant_outline = 1.0;
	}
	else{
		distant_outline = 0.0;
	}
	distant_outline =distant_outline-distant_fill;

	COLOR = vec4(distant_outline,distant_fill,distantsin,1);



	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
