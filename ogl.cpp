#include <GL/glew.h>
#include <GLFW/glfw3.h>

#if defined __APPLE__
    #include <OpenGL/gl.h>
#else
    #include <GL/gl.h>
#endif

#include <string>
#include "shader.h"
#include "camera.h"
#include "model.h"

// GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>


// Window dimensions
const GLuint WIDTH = 800, HEIGHT = 600;

// Function prototypes
void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode);
void scroll_callback(GLFWwindow* window, double xoffset, double yoffset);
void mouse_callback(GLFWwindow* window, double xpos, double ypos);
void Do_Movement();

// Camera
Camera camera(glm::vec3(0.0f, 0.0f, 3.0f));
bool keys[1024];
GLfloat lastX = WIDTH/2.0f, lastY = HEIGHT/2.0f;
bool firstMouse = true;

// Time
GLfloat deltaTime = 0.0f;
GLfloat lastFrame = 0.0f;

// Lighting
//glm::vec3 lightPos(1.2f, 1.0f, 2.0f);

int main(int argc, const char * argv[]) {
    // Initialize GLFW
    if(!glfwInit()){
        std::cout << "glfw init failed." << std::endl;
        return -1;
    }
    // Mac defaults to GLSL 1.2 need these lines to use 330+ core profile
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);

    // Setup GLFW Window
    GLFWwindow *window = glfwCreateWindow(WIDTH, HEIGHT, "OpenGL Hello World", NULL, NULL);
    if (!window) {
        glfwTerminate();
        std::cout << "glfw window failed." << std::endl;
        return -1;
    }
    glfwMakeContextCurrent(window);
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);

    // Bind Callbacks
    glfwSetKeyCallback(window, key_callback);
    glfwSetCursorPosCallback(window, mouse_callback);
    glfwSetScrollCallback(window, scroll_callback);

    // Initialize GLEW
    glewExperimental = GL_TRUE;
    if (glewInit() != GLEW_OK) {
        std::cout << "glew init failed." << std::endl;
        return -1;
    }

    // Set GL Viewport
    glViewport(0, 0, WIDTH, HEIGHT);

    // Setup OpenGL options
    glEnable(GL_DEPTH_TEST);

    // Build and compile our shader program
    Shader modelShader("shaders/model.vs", "shaders/model.frag");
    Model ourModel("/models/Nanosuit2/nanosuit2.obj");

    // Optional Wireframe
    //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

    // Engine Loop
    while (!glfwWindowShouldClose(window)) {
        // Set frame time
        GLfloat currentFrame = glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;
        // Poll for input/events
        glfwPollEvents();
        Do_Movement();

        // Clear the canvas / color buffer
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        modelShader.Use();
        // Transforms
        glm::mat4 projection = glm::perspective(glm::radians(camera.Zoom), (float)WIDTH/(float)HEIGHT, 0.1f, 100.0f);
        glm::mat4 view = camera.GetViewMatrix();
        glUniformMatrix4fv(glGetUniformLocation(modelShader.Program, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
        glUniformMatrix4fv(glGetUniformLocation(modelShader.Program, "view"), 1, GL_FALSE, glm::value_ptr(view));

        // Draw model
        glm::mat4 model;
        model = glm::translate(model, glm::vec3(0.0f, -1.75f, 0.0f));
        model = glm::scale(model, glm::vec3(0.2f, 0.2f, 0.2f));
        glUniformMatrix4fv(glGetUniformLocation(modelShader.Program, "model"), 1, GL_FALSE, glm::value_ptr(model));
        ourModel.Draw(modelShader);

        // Swap the screen buffers
        glfwSwapBuffers(window);
    }

    // Terminate GLFW, clearing any resources allocated by GLFW.
    glfwTerminate();
    return 0;
}

  void Do_Movement() {
    if (keys[GLFW_KEY_W])
      camera.ProcessKeyboard(FORWARD, deltaTime);
    if (keys[GLFW_KEY_S])
      camera.ProcessKeyboard(BACKWARD, deltaTime);
    if (keys[GLFW_KEY_A])
      camera.ProcessKeyboard(LEFT, deltaTime);
    if (keys[GLFW_KEY_D])
      camera.ProcessKeyboard(RIGHT, deltaTime);
  }

  void key_callback(GLFWwindow *window, int key, int scancode, int action, int mode) {
    // When a user presses the escape key, we set the WindowShouldClose property to true,
    // closing the application.
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GL_TRUE);
    }
    if (key >= 0 && key < 1024) {
      if(action == GLFW_PRESS)
        keys[key] = true;
      else if (action == GLFW_RELEASE)
        keys[key] = false;
    }
  }
  void mouse_callback(GLFWwindow* window, double xpos, double ypos) {
    if (firstMouse) {
      lastX = xpos;
      lastY = ypos;
      firstMouse = false;
    }
    GLfloat xoffset = xpos - lastX;
    GLfloat yoffset = lastY - ypos;
    lastX = xpos;
    lastY = ypos;
    camera.ProcessMouseMovement(xoffset, yoffset);
  }
  void scroll_callback(GLFWwindow* window, double xoffset, double yoffset) {
    camera.ProcessMouseScroll(yoffset);
  }
