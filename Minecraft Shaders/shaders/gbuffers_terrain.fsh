#version 120
#include "/lib/framebuffer.glsl"

uniform sampler2D texture;

varying vec4 texcoord;
varying vec3 tintColor;
varying vec3 normal;
varying vec4 lightmapcoord;

//drawing normals red = x, green = y, blue = z.
//by setting color output to the normal ie: fragdata[0]
//normals are relative to the camera

void main() {
  vec4 blockColor = texture2D(texture, texcoord.st);
  blockColor.rgb *= tintColor;

  GCOLOR_OUT = blockColor;
  GDEPTH_OUT = vec4(lightmapcoord.st / 16.0, 0.0, 0.0); // light map stored in 0 to 16 range, texture map can only do 0 to 1 range, so compress it.
  GNORMAL_OUT = vec4(normal * 0.5 + 0.5, 1.0);
}
