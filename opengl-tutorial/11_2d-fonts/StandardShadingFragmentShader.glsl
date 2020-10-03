#version 330 core

// vertex shader에서 넘겨준 보간 값
in vec2 UV;
in vec3 Position_worldspace;
in vec3 Normal_cameraspace;
in vec3 EyeDirection_cameraspace;
in vec3 LightDirection_cameraspace;

out vec3 color;

// 한 메쉬를 그리는 동안 일정하게 유지되는 값.
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

	// fragment shader에서 계산된 법선, 카메라 공간 기준
	vec3 n = normalize( Normal_cameraspace );
	// 빛의 방향
	vec3 l = normalize( LightDirection_cameraspace );
	// 빛이 삼각형에 대해서 수직 -> 1
	// 빛이 삼각형에 대해서 수평 -> 0
	// 빛이 삼각형 뒤에 있으면 -> 0 
	float cosTheta = clamp( dot( n,l ), 0, 1 );

	// 눈 벡터 - 카메라 쪽.
	vec3 E = normalize(EyeDirection_cameraspace);
	// 삼각형이 빛을 반사하는 방향. 
	vec3 R = reflect(-l,n);
	// 반사광을 들어다보고 있으면 -> 1
	// 다른 곳을 보고 있으면 -> < 1
	float cosAlpha = clamp( dot( E,R ), 0,1 );

	color = MaterialAmbientColor + // 주변광 : 간접 조명
			MaterialDiffuseColor * LightColor * LightPower * cosTheta / (distance * distance) +	// 확산광 : 오브젝트의 색깔
			MaterialSpecularColor * LightColor * LightPower * pow(cosAlpha,5) / (distance * distance); // 반사광 : 반사 하이라이트
}