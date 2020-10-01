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

glm::vec3 position = glm::vec3(0, 0, 5);	// ó�� ��ǥ
float horizontalAngle = 3.14f;				// ���� : -Z ����
float verticalAngle = 0.0f;					// ������ : 0. ������ �ٶ�
float initialFoV = 45.0f;					// �ʱ� FOV��

float speed = 3.0f;							// �ʴ� 3 units
float mouseSpeed = 0.005f;


void computeMatricesFromInputs()
{
	static double lastTime = glfwGetTime();

	double currentTime = glfwGetTime();
	float deltaTime = float(currentTime - lastTime);

	// ���콺 ��ǥ �ޱ�
	double xpos, ypos;
	glfwGetCursorPos(window, &xpos, &ypos);

	glfwSetCursorPos(window, 1024 / 2, 768 / 2);

	// ���ο� ���� ���
	horizontalAngle += mouseSpeed * deltaTime * float(1024 / 2 - xpos);
	verticalAngle += mouseSpeed * deltaTime * float(768 / 2 - ypos);

	// ���� : ���� ��ǥ�� ��ī��Ʈ ��ǥ�� ��ȯ 
	glm::vec3 direction(
		cos(verticalAngle) * sin(horizontalAngle),
		sin(verticalAngle),
		cos(verticalAngle) * cos(horizontalAngle)
	);

	// ������ ���� 
	glm::vec3 right = glm::vec3(
		sin(horizontalAngle - 3.14f / 2.0f),
		0,
		cos(horizontalAngle - 3.14f / 2.0f)
	);

	// Up vector : Direction �� Right�� ���� ����
	glm::vec3 up = glm::cross(right, direction);

	// ������
	if (glfwGetKey(window, GLFW_KEY_UP) == GLFW_PRESS)
	{
		position += direction * deltaTime * speed;
	}
	// �ڷ�
	if (glfwGetKey(window, GLFW_KEY_DOWN) == GLFW_PRESS)
	{
		position -= direction * deltaTime * speed;
	}
	// ������
	if (glfwGetKey(window, GLFW_KEY_RIGHT) == GLFW_PRESS)
	{
		position += right * deltaTime * speed;
	}
	// ����
	if (glfwGetKey(window, GLFW_KEY_LEFT) == GLFW_PRESS)
	{
		position -= right * deltaTime * speed;
	}

	float FoV = initialFoV;

	// Projection ���
	ProjectionMatrix = glm::perspective(glm::radians(FoV), 4.0f / 3.0f, 0.1f, 100.0f);
	// ī�޶� ���
	ViewMatrix = glm::lookAt(
		position,
		position + direction,
		up
	);

	lastTime = currentTime;
}