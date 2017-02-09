#version 120
//This is where you do most of your worldspace stuff
#include "/lib/framebuffer.glsl"

//varying passes between shaders
varying vec4 texcoord;
//varying vec3 tintColor;
//varying vec3 normal;
varying vec3 lightVector;
varying vec3 lightColor;
varying vec3 skyColor;

struct Fragment {
  vec3 albedo;
  vec3 normal;
  float emission;
};

struct Lightmap {
  float torchLightStrength;
  float skyLightStrength;
};

Fragment getFragment(in vec2 coord) {
  Fragment newFragment;
  newFragment.albedo = getAlbedo(coord);
  newFragment.normal = getNormal(coord);
  newFragment.emission = getEmission(coord);
  return newFragment;
}

Lightmap getLightmapSample(in vec2 coord) {
  Lightmap lightmap;
  lightmap.torchLightStrength = getTorchLightStrength(coord);
  lightmap.skyLightStrength = getSkyLightStrength(coord);
  return lightmap;
}

vec3 calculateLighting(in Fragment frag, in Lightmap lightmap) {
  float directLightStrength = dot(frag.normal, lightVector);
  directLightStrength = max(0.0, directLightStrength);
  vec3 directLight = directLightStrength * lightColor;

  vec3 torchcolor = vec3(1.0, 0.9, 0.8) * 0.1;
  vec3 torchlight = torchcolor * lightmap.torchLightStrength;
  vec3 skylight = skyColor * lightmap.skyLightStrength;

  vec3 color = frag.albedo * (directLight + skylight + torchlight);
  return mix(color, frag.albedo, frag.emission);
}

/* DRAWBUFFERS : 012 */
void main() {
  Fragment frag = getFragment(texcoord.st);
  Lightmap lightmap = getLightmapSample(texcoord.st);
  vec3 color = calculateLighting(frag, lightmap);

  GCOLOR_OUT = vec4(color, 1.0);
  //GNORMAL_OUT = vec4(normal, 1.0);
  //GDEPTH_OUT = vec4(depth, 1.0);

}
