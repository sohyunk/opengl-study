#version 330 core

layout(location = 0) in vec3 vertexPosition_modelspace;
layout(location = 1) in vec2 vertexUV;

// Output data : 각 픽셀마다 알아서 보간
out vec2 UV;

// 메쉬 당 상수.
uniform mat4 MVP;

void main()
{
	// 정점의 출력 위치 = MVP(Model View Projection) * position
	gl_Position = MVP * vec4(vertexPosition_modelspace,1);

	// v좌표 반전
	UV = vec2(vertexUV.x, 1.0-vertexUV.y);
}