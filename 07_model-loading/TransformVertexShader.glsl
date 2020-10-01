#version 330 core

layout(location = 0) in vec3 vertexPosition_modelspace;
layout(location = 1) in vec2 vertexUV;

// Output data : �� �ȼ����� �˾Ƽ� ����
out vec2 UV;

// �޽� �� ���.
uniform mat4 MVP;

void main()
{
	// ������ ��� ��ġ = MVP(Model View Projection) * position
	gl_Position = MVP * vec4(vertexPosition_modelspace,1);

	// v��ǥ ����
	UV = vec2(vertexUV.x, 1.0-vertexUV.y);
}