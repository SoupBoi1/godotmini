shader_type canvas_item;
uniform float k_factor;

uniform vec2 obj1;
uniform float radus;
uniform float outline;
uniform vec2 obj2;



vec3 sdgCircle(in vec2 UV_, in vec2 p, in float r )
{
    float l = distance(p,UV_);
    return vec3( l-r, p/l );
}
float sdBox(in vec2 UV_, in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return distance(max(d,0.0),UV_) + min(max(d.x,d.y),0.0);
}

float smooth_min (float a, float b){
	float k = k_factor;
   float h = max( k-abs(a-b), 0.0 )/k;
    return min(a,b) - h*h*h*(4.0-h)*k*(1.0/16.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
	vec3 dg = sdgCircle(UV,obj2,.1);

	float distantobjs = smooth_min(sdgCircle(UV,obj1,radus).x,dg.x);
	//float distantobjs =sdBox(UV,obj1,obj2);
	float distantsin = sin(distantobjs*250.0+TIME*5.0) ;
	float distant_fill = distantobjs;
	if(distant_fill < 0.0){
		distant_fill = 1.0;
	}
	else{
		distant_fill = 0.0;
	}
	float distant_outline = distantobjs;
	if(distant_outline < outline){
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
