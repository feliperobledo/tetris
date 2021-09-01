#define GL_SILENCE_DEPRECATION
#include "./include/graphics-wrapper.hpp"
#include <iostream>
#include <SDL.h>

#include "./include/test.hpp"

const u_int32_t WINDOW_WIDTH = 640;
const u_int32_t WINDOW_HEIGHT = 420;

void render(SDL_Window* window, const SDL_GLContext& context)
{
    SDL_GL_MakeCurrent(window, context);

    glClearColor(0.3f, 0.7f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    SDL_GL_SwapWindow(window);
}

bool runMainLoop(SDL_Window* window, const SDL_GLContext& context)
{
    SDL_Event event;

    // Each loop we will process any events that are waiting for us.
    while (SDL_PollEvent(&event))
    {
        switch (event.type)
        {
            // If we get a quit signal, we will return that we don't want to keep looping.
            case SDL_QUIT:
                return false;

            case SDL_KEYDOWN:
                // If we get a key down event for the ESC key, we also don't want to keep looping.
                if (event.key.keysym.sym == SDLK_ESCAPE)
                {
                    return false;
                }
                break;
            default:
                break;
        }
    }

    // Perform our rendering for this frame, normally you would also perform
    // any updates to your world as well here.
    render(window, context);

    // Returning true means we want to keep looping.
    return true;
}

void ClearDepth(float d) {
#if TARGET_OS_IPHONE
  glClearDepthf(1.0f);
#else
  glClearDepth(1.0f);
#endif
}

void runApplication() {
  u_int32_t width{640};
  u_int32_t height{320};

  // Create new SDL window based on OpenGL
  SDL_Window* window{SDL_CreateWindow(
      "Tetris",
      SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
      WINDOW_WIDTH, WINDOW_HEIGHT,
      SDL_WINDOW_RESIZABLE | SDL_WINDOW_OPENGL | SDL_WINDOW_ALLOW_HIGHDPI)};

  // Obtain the OpenGL Context based on our window
  SDL_GLContext context{SDL_GL_CreateContext(window)};

  //Setup some basic global OpenGL state
  ClearDepth(1.0f);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glEnable(GL_CULL_FACE);
  glViewport(0,0,width, height);

  // main loop
  while(runMainLoop(window, context)) {

  }

  // Clean up after ourselves
  SDL_GL_DeleteContext(context);
  SDL_DestroyWindow(window);
}

int main(int, char *[]) {
  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS) == 0) {
    std::cout << "Successfully initialised SDL!" << std::endl;

    runApplication();

    SDL_Quit();
  } else {
    std::cout << "Failed to initialise SDL!" << std::endl;
  }

  return 0;
}
