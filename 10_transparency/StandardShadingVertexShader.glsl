#version 330 core

layout(location = 0) in vec3 vertexPosition_modelspace;
layout(location = 1) in vec2 vertexUV;
layout(location = 2) in vec3 vertexNormal_modelspace;

// Output data : 각 픽셀마다 알아서 보간
out vec2 UV;
out vec3 Position_worldspace;
out vec3 Normal_cameraspace;
out vec3 EyeDirection_cameraspace;
out vec3 LightDirection_cameraspace;

// 메쉬 당 상수.
uniform mat4 MVP;
uniform mat4 V;
uniform mat4 M;
uniform vec3 LightPosition_worldspace;

void main()
{
	// 정점의 출력 위치 = MVP(Model View Projection) * position
	gl_Position = MVP * vec4(vertexPosition_modelspace,1);

	// 정점의 월드 좌표, 월드 공간에선 : M * position
	Position_worldspace = (M * vec4(vertexPosition_modelspace,1)).xyz;

	// 정점에서 카메라 공간을 향하는 벡터
	// 카메라 공간에선, 카메라는 원점
	vec3 vertexPosition_cameraspace = ( V * M * vec4(vertexPosition_modelspace,1)).xyz;
	EyeDirection_cameraspace = vec3(0,0,0) - vertexPosition_cameraspace;

	// 카메라 공간에서 빛으로, 정점으로 가는 벡터
	vec3 LightPosition_cameraspace = ( V * vec4(LightPosition_worldspace,1)).xyz;
	LightDirection_cameraspace = LightPosition_cameraspace + EyeDirection_cameraspace;

	// 카메라 공간에서 정점의 법선 벡터
	Normal_cameraspace = ( V * M * vec4(vertexNormal_modelspace,0)).xyz;

	UV = vertexUV;
}