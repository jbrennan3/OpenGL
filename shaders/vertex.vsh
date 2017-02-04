#version 330 core
layout (location = 0) in vec3 position;
layout (location = 1) in vec3 color;
layout (location = 2) in vec2 texcoord;

out vec3 ourColor;
out vec2 texCoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main() {
    // remember do matrix mult in reverse order ie: right to left
    gl_Position = projection * view * model * vec4(position, 1.0f);
    ourColor = color;
    texCoord = texcoord;
}
