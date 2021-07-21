#include <iostream>
#include <SDL.h>
#include "./include/test.hpp"

int main(int, char *[]) {
  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS) == 0) {
    std::cout << "Successfully initialised SDL!" << std::endl;
    SDL_Quit();
  } else {
    std::cout << "Failed to initialise SDL!" << std::endl;
  }


  return 0;
}
