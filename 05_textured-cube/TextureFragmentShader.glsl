#version 330 core

// vertex shader���� �Ѱ��� ���� ��
in vec2 UV;

out vec3 color;

// �� �޽��� �׸��� ���� �����ϰ� �����Ǵ� ��.
uniform sampler2D myTextureSampler;

void main()
{
	color = texture(myTextureSampler, UV).rgb;
}