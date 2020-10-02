#version 330 core

// vertex shader���� �Ѱ��� ���� ��
in vec2 UV;
in vec3 Position_worldspace;
in vec3 Normal_cameraspace;
in vec3 EyeDirection_cameraspace;
in vec3 LightDirection_cameraspace;

out vec3 color;

// �� �޽��� �׸��� ���� �����ϰ� �����Ǵ� ��.
uniform sampler2D myTextureSampler;
uniform mat4 MV;
uniform vec3 LightPosition_worldspace;

void main()
{
	vec3 LightColor = vec3(1,1,1);
	float LightPower = 50.0f;

	vec3 MaterialDiffuseColor = texture( myTextureSampler, UV ).rgb;
	vec3 MaterialAmbientColor = vec3(0.1,0.1,0.1) * MaterialDiffuseColor;
	vec3 MaterialSpecularColor = vec3(0.3,0.3,0.3);

	float distance = length( LightPosition_worldspace - Position_worldspace );

	// fragment shader���� ���� ����, ī�޶� ���� ����
	vec3 n = normalize( Normal_cameraspace );
	// ���� ����
	vec3 l = normalize( LightDirection_cameraspace );
	// ���� �ﰢ���� ���ؼ� ���� -> 1
	// ���� �ﰢ���� ���ؼ� ���� -> 0
	// ���� �ﰢ�� �ڿ� ������ -> 0 
	float cosTheta = clamp( dot( n,l ), 0, 1 );

	// �� ���� - ī�޶� ��.
	vec3 E = normalize(EyeDirection_cameraspace);
	// �ﰢ���� ���� �ݻ��ϴ� ����. 
	vec3 R = reflect(-l,n);
	// �ݻ籤�� ���ٺ��� ������ -> 1
	// �ٸ� ���� ���� ������ -> < 1
	float cosAlpha = clamp( dot( E,R ), 0,1 );

	color = MaterialAmbientColor + // �ֺ��� : ���� ����
			MaterialDiffuseColor * LightColor * LightPower * cosTheta / (distance * distance) +	// Ȯ�걤 : ������Ʈ�� ����
			MaterialSpecularColor * LightColor * LightPower * pow(cosAlpha,5) / (distance * distance); // �ݻ籤 : �ݻ� ���̶���Ʈ
}