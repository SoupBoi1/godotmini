shader_type canvas_item;
uniform float k_factor;

uniform vec2 obj1;
uniform float radus;
uniform float outline;
uniform vec2 obj2;
uniform vec2 radus2;

uniform vec2 obj3;
uniform float radus3;


float dot2(in vec2 x){
	return dot(x,x);
}
vec3 sdgCircle(in vec2 UV_, in vec2 p, in float r )
{
    float l = distance(p,UV_);
    return vec3( l-r, p/l );
}
float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float smooth_min (float a, float b){
	float k = k_factor;
   float h = max( k-abs(a-b), 0.0 )/k;
    return min(a,b) - h*h*h*(4.0-h)*k*(1.0/16.0);
}
float sdPentagram(in vec2 p, in float r )
{
    const float k1x = 0.809016994; // cos(π/ 5) = ¼(√5+1)
    const float k2x = 0.309016994; // sin(π/10) = ¼(√5-1)
    const float k1y = 0.587785252; // sin(π/ 5) = ¼√(10-2√5)
    const float k2y = 0.951056516; // cos(π/10) = ¼√(10+2√5)
    const float k1z = 0.726542528; // tan(π/ 5) = √(5-2√5)
    const vec2  v1  = vec2( k1x,-k1y);
    const vec2  v2  = vec2(-k1x,-k1y);
    const vec2  v3  = vec2( k2x,-k2y);

    p.x = abs(p.x);
    p -= 2.0*max(dot(v1,p),0.0)*v1;
    p -= 2.0*max(dot(v2,p),0.0)*v2;
    p.x = abs(p.x);
    p.y -= r;
    return length(p-v3*clamp(dot(p,v3),0.0,k1z*r))
           * sign(p.y*v3.x-p.x*v3.y);
}

void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {

	vec3 dg = sdgCircle(UV,obj2,.1);

	float distantobjs = smooth_min(smooth_min(sdgCircle(UV,obj1,radus).x,sdBox(UV-obj2,radus2)),sdPentagram(UV-obj3,radus3));
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
	//COLOR = vec4(sdPentagram(UV-obj1,.05),0.0,0.0,1.0);


	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
