#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


uniform sampler2D displacementMap;
uniform sampler2D texture;
uniform sampler2D visage;
uniform float alpha;

varying vec4 vertTexCoord;



void main() 
{
  vec2 v = vertTexCoord.st;
  v.t = 1.0 - v.t;

  vec4 t = texture2D( texture, vertTexCoord.st );
  vec4 f = texture2D( visage, v);

  gl_FragColor = vec4(f.r * t.r ,f.r * t.g, f.r * t.b, alpha);
//  gl_FragColor = f;
}