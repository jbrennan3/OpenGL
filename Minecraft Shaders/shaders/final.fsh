#version 120
//final is the last file, last thing rendered to screen in game
// post processing stuff is done here.
#include "/lib/framebuffer.glsl"

varying vec4 texcoord;

void vignette(inout vec3 color) {
  float dist = distance(texcoord.st, vec2(0.5));
  dist /= 1.51420f;
  dist = pow(dist, 1.1f);
  color.rgb *= 1.0f - dist;
}

vec3 converttoHDR(in vec3 color) {
  //HDR make darker colors pop
  vec3 HDRImage;
  vec3 overexposed = color * 1.2;
  vec3 underexposed = color / 1.5f;
  HDRImage = mix(underexposed, overexposed, color);
  return HDRImage;
}

vec3 getExposure(in vec3 color) {
  vec3 retColor;
  color *= 1.115;
  retColor = color;
  return retColor;
}

vec3 Reinhard(in vec3 color) {
  // Simple Reinhard tonemapping
  color = color / (1 + color);
  return pow(color, vec3(1.0/2.2));
}

vec3 Burgess(in vec3 color) {
  // Burgess Tonemapping
  // Vibrant nice coloring
  vec3 maxColor = max(vec3(0.0), color - 0.004);
  vec3 retColor = (maxColor * (6.2 * maxColor + 0.05)) / (maxColor * (6.2 * maxColor + 2.3) + 0.06);
  return pow(retColor, vec3(1.0/2.2));
}

//Magic numbers for Uncharted Tonemapping
float A = 0.15;
float B = 0.50;
float C = 0.10;
float D = 0.20;
float E = 0.02;
float F = 0.30;
float W = 11.2;

vec3 Uncharted2Math(in vec3 x) {
  return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

vec3 Uncharted2Tonemap(in vec3 color) {
  // washed out flat/cold feel
  vec3 retColor;
  float exposureBias = 2.0;
  vec3 curve = Uncharted2Math(exposureBias * color);
  vec3 whiteScale = vec3(1.0f) / Uncharted2Math(vec3(W));
  retColor = curve * whiteScale;
  return pow(retColor, vec3(1.0/2.2));
}

void main()
{
  vec3 color = texture2D(gcolor, texcoord.st).rgb;
  color = converttoHDR(color);
  //vignette(color);
  color = getExposure(color);
  color = Burgess(color);
  gl_FragColor = vec4(color, 1.0);
}
