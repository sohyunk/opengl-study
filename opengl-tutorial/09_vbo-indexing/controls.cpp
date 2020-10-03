#include <glfw3.h>
extern GLFWwindow* window;

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
using namespace glm;

#include "common/controls.hpp"

glm::mat4 ViewMatrix;
glm::mat4 ProjectionMatrix;

glm::mat4 getViewMatrix()
{
	return ViewMatrix;
}
glm::mat4 getProjectionMatrix()
{
	return ProjectionMatrix;
}

glm::vec3 position = glm::vec3(0, 0, 5);	// 처음 좌표
float horizontalAngle = 3.14f;				// 수평각 : -Z 방향
float verticalAngle = 0.0f;					// 수직각 : 0. 수직을 바라봄
float initialFoV = 45.0f;					// 초기 FOV값

float speed = 3.0f;							// 초당 3 units
float mouseSpeed = 0.005f;


void computeMatricesFromInputs()
{
	static double lastTime = glfwGetTime();

	double currentTime = glfwGetTime();
	float deltaTime = float(currentTime - lastTime);

	// 마우스 좌표 받기
	double xpos, ypos;
	glfwGetCursorPos(window, &xpos, &ypos);

	glfwSetCursorPos(window, 1024 / 2, 768 / 2);

	// 새로운 방향 계산
	horizontalAngle += mouseSpeed * deltaTime * float(1024 / 2 - xpos);
	verticalAngle += mouseSpeed * deltaTime * float(768 / 2 - ypos);

	// 방향 : 구면 좌표를 데카르트 좌표로 변환 
	glm::vec3 direction(
		cos(verticalAngle) * sin(horizontalAngle),
		sin(verticalAngle),
		cos(verticalAngle) * cos(horizontalAngle)
	);

	// 오른쪽 벡터 
	glm::vec3 right = glm::vec3(
		sin(horizontalAngle - 3.14f / 2.0f),
		0,
		cos(horizontalAngle - 3.14f / 2.0f)
	);

	// Up vector : Direction 과 Right에 대해 직각
	glm::vec3 up = glm::cross(right, direction);

	// 앞으로
	if (glfwGetKey(window, GLFW_KEY_UP) == GLFW_PRESS)
	{
		position += direction * deltaTime * speed;
	}
	// 뒤로
	if (glfwGetKey(window, GLFW_KEY_DOWN) == GLFW_PRESS)
	{
		position -= direction * deltaTime * speed;
	}
	// 오른쪽
	if (glfwGetKey(window, GLFW_KEY_RIGHT) == GLFW_PRESS)
	{
		position += right * deltaTime * speed;
	}
	// 왼쪽
	if (glfwGetKey(window, GLFW_KEY_LEFT) == GLFW_PRESS)
	{
		position -= right * deltaTime * speed;
	}

	float FoV = initialFoV;

	// Projection 행렬
	ProjectionMatrix = glm::perspective(glm::radians(FoV), 4.0f / 3.0f, 0.1f, 100.0f);
	// 카메라 행렬
	ViewMatrix = glm::lookAt(
		position,
		position + direction,
		up
	);

	lastTime = currentTime;
}