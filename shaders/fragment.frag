#version 330 core
in vec3 ourColor;
in vec2 texCoord;

out vec4 color;

uniform float mixValue;
uniform sampler2D ourTexture1;
uniform sampler2D ourTexture2;

void main() {
    color = mix(texture(ourTexture1, texCoord), texture(ourTexture2, vec2(texCoord.x, 1 - texCoord.y)), mixValue) * vec4(ourColor, 1.0f);
}
