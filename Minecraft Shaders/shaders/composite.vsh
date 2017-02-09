#version 120
varying vec4 texcoord;
varying vec3 lightVector;
varying vec3 lightColor;
varying vec3 skyColor;
// pass between vertex to fragment using varying

uniform int worldTime;
uniform vec3 sunPosition;
uniform vec3 moonPosition;

void main() {
  gl_Position = ftransform();
  // shapes position
  texcoord = gl_MultiTexCoord0;
  // pixel position of geometry

  if (worldTime < 12700 || worldTime > 23250) {
    lightVector = normalize(sunPosition);
    lightColor = vec3(1.0);
    skyColor = vec3(0.003);
  } else {
    lightVector = normalize(moonPosition);
    lightColor = vec3(0.03);
    skyColor = vec3(0.0003);
  }

}
