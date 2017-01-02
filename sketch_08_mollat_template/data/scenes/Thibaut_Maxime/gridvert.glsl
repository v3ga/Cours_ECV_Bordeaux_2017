#define PROCESSING_TEXTURE_SHADER


uniform mat4 transform;
uniform mat4 texMatrix;

uniform sampler2D displacementMap;
uniform float displacement;
uniform sampler2D visage;
uniform float alpha;


attribute vec4 vertex;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertTexCoord;



void main() 
{
	vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
	vec2 v = vertTexCoord.st;
//	vertTexCoord.t = 1.0 - vertTexCoord.t;
	v.t = 1.0-v.t;

  vec4 dv = texture2D( displacementMap, v); // rgba color of displacement map
  float df = 0.30*dv.r + 0.59*dv.g + 0.11*dv.b; // brightness calculation to create displacement float from rgb values
  vec4 newVertexPos = vertex + vec4(0.0,0.0, displacement*(1.0-df),0.0); // regular vertex position + direction * displacementMap * displaceStrength

  gl_Position = transform * newVertexPos;
}