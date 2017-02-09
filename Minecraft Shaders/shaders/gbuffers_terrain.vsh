#version 120

//pass varying
varying vec4 texcoord;
varying vec3 tintColor;
varying vec3 normal;
varying vec4 lightmapcoord;

void main() {
  gl_Position = ftransform();
  texcoord = gl_MultiTexCoord0;
  lightmapcoord = gl_MultiTexCoord1;
  tintColor = gl_Color.rgb;
  normal = normalize(gl_NormalMatrix * gl_Normal); // always do Matrix * Vector
  /* The normal matrix is the inverse transpose of the upper 3x3 of the objects
  * model matrix */

}
