project(Tetris)

# Every file starts with which cmake versions we should use
cmake_minimum_required(VERSION 3.4.1)

# Set the project name
# set(PROJECT_NAME "tetris")

# Auto-generate the compile_commands.json file used by ccls for autocompletion
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Let's declare our compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -fexceptions")

# We create a couple of properties/variables that refer to our 3rd party libs & shared code
set(THIRD_PARTY_DIR "../providers")
set(MAIN_SOURCE_DIR "../core")

# We tell cmake where do we want to output our binary
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/out)

# For now, let's hardcode where to find the SDL header files
include_directories(${THIRD_PARTY_DIR}/include/SDL2/Headers)

# Collate (ie. collect) a list of all source files from our main project we need to compile
# GLOB_RECURSE: this is a wild card mechanism.
# CPP_HEADERS: a variable that holds the list of all declaration files
# CPP_SOURCES: a variable that holds the list of all source files
file(GLOB_RECURSE CPP_HEADERS ${MAIN_SOURCE_DIR}/*.hpp)
file(GLOB_RECURSE CPP_SOURCES ${MAIN_SOURCE_DIR}/*.cpp)

# Specify the name of the executable and what files to use to make that executable
add_executable(
    tetris
    ${CPP_HEADERS}
    ${CPP_SOURCES}
)

# This specifies what linker properties to use
# -F tells the linkder to look at the provided path for any custom frameworks
# Note: the guide is from 2019, when perhaps OpenGL wasn't yet removed from macOS. Therefore, we might need to download OpenGL
set_target_properties(
    tetris
    PROPERTIES
    LINK_FLAGS
    "-F../${THIRD_PARTY_DIR}/Frameworks -framework SDL2 -framework OpenGL"
)
