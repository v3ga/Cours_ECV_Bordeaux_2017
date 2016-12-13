#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


uniform sampler2D displacementMap;
uniform sampler2D texture;
varying vec4 vertTexCoord;

void main() 
{
  vec2 v = vertTexCoord.st;
  v.t = 1.0 - v.t;

  vec4 t = texture2D( texture, vertTexCoord.st ); // rgba color of displacement map
  vec4 f = texture2D( displacementMap, v); // rgba color of displacement map
  float df = 0.30*f.r + 0.59*f.g + 0.11*f.b; // brightness calculation to create displacement float from rgb values

  gl_FragColor = vec4(f.r * t.r ,f.r * t.g, f.r * t.b,1.0);
}