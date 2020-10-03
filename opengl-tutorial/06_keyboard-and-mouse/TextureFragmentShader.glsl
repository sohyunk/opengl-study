#version 330 core

// vertex shader에서 넘겨준 보간 값
in vec2 UV;

out vec3 color;

// 한 메쉬를 그리는 동안 일정하게 유지되는 값.
uniform sampler2D myTextureSampler;

void main()
{
	color = texture(myTextureSampler, UV).rgb;
}