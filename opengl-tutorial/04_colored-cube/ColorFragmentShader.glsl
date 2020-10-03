#version 330 core

// vertex shader에서 보간된 값
in vec3 fragmentColor;

out vec3 color;

void main()
{
	color = fragmentColor;
}