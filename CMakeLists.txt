cmake_minimum_required(VERSION 3.1)
project(My_Template)


set(${PROJECT_NAME}_VERSION_MAJOR 1)
set(${PROJECT_NAME}_VERSION_MINOR 2)
set(${PROJECT_NAME}_VERSION_PATCH 2)
set( ${PROJECT_NAME}_VERSION
    ${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}.${${PROJECT_NAME}_VERSION_PATCH}
)
set(PROJECT_VERSION ${${PROJECT_NAME}_VERSION})

set(PROJ_NAME "\"${PROJECT_NAME}\"") # PROJECT_NAME is a predefined variable
set(PROJECT_DESCRIPTION "This is my template project for c++")

configure_file(include/${PROJECT_NAME}/config.hpp.in
    ${CMAKE_BINARY_DIR}/include/${PROJECT_NAME}/config.hpp
)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Options
option(BUILD_TESTS "Build test executable" ON)
option(GEN_DOCS "Generate documentation" ON)
option(ENABLE_COVERAGE "Enable code coverage" ON)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

message(STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to 'Release' as no build type was specified")
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the build type (Debug/Release)" FORCE)
endif (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)

if (ENABLE_COVERAGE AND NOT CMAKE_CONFIGURATION_TYPES)
    if (NOT BUILD_TESTS)
        message(FATAL_ERROR "Tests must be enabled for code coverage!")
    endif (NOT BUILD_TESTS)
    
    include(CodeCoverage)
    
    append_coverage_compiler_flags()
    set(COVERAGE_EXCLUDES "/usr/include/\\*;${CMAKE_SOURCE_DIR}/src/main.cpp;${CMAKE_SOURCE_DIR}/test/*;${CMAKE_SOURCE_DIR}/third_party/doctest/*")
    
    setup_target_for_coverage(NAME coverage EXECUTABLE ctest DEPENDENCIES coverage)
else (ENABLE_COVERAGE AND NOT CMAKE_CONFIGURATION_TYPES)
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /WX")
        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /O2")
    endif(CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
endif (ENABLE_COVERAGE AND NOT CMAKE_CONFIGURATION_TYPES)

set(LIBRARY_SOURCES
    src/factorial.cpp
    src/hello_world.cpp
)

add_library(${PROJECT_NAME}-lib ${LIBRARY_SOURCES}) # A library
set_target_properties(${PROJECT_NAME}-lib PROPERTIES PREFIX "") # Remove the lib prefix
target_include_directories(${PROJECT_NAME}-lib PUBLIC ${CMAKE_SOURCE_DIR}/include ${CMAKE_BINARY_DIR}/include)

add_executable(${PROJECT_NAME} src/main.cpp) # The main executable
target_link_libraries(${PROJECT_NAME} ${PROJECT_NAME}-lib) # Link our sources to the executable

if (BUILD_TESTS)
    include(CTest)
    enable_testing()
    add_subdirectory(test)
endif (BUILD_TESTS)

if (GEN_DOCS)
    add_subdirectory(doc)
endif (GEN_DOCS)

# Install the built library and executable into the appropriate directory
install(TARGETS ${PROJECT_NAME} DESTINATION bin)
install(TARGETS ${PROJECT_NAME}-lib
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

# Install the project header files into the appropriate directory
install(DIRECTORY include/ DESTINATION include PATTERN "config.hpp.in" EXCLUDE) # Install our main header files 
install(FILES ${CMAKE_BINARY_DIR}/include/${PROJECT_NAME}/config.hpp DESTINATION include/${PROJECT_NAME}) # Install our configuration file

# Install the project's extra files
install(FILES README.md LICENSE DESTINATION share/${PROJECT_NAME})
