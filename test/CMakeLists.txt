add_library(doctest INTERFACE)              # add library target doctest with INTERFACE type (no source files) 
target_include_directories(doctest INTERFACE 
    "${CMAKE_SOURCE_DIR}/third_party/doctest"
)                                        # add include directory to doctest target


## Test for hello_world
set(TEST_SRC_HELLO
    hello_world_test.cpp
)                                     # add source files to variable TEST_SOURCES
add_executable(test_hello test_runner.cpp ${TEST_SRC_HELLO})
target_link_libraries(test_hello ${PROJECT_NAME}-lib doctest)
add_test(hello_test test_hello)

## Test for factorial
set(TEST_SRC_FACT
    factorial_test.cpp
)
add_executable(test_factorial test_runner.cpp ${TEST_SRC_FACT})
target_link_libraries(test_factorial ${PROJECT_NAME}-lib doctest)
add_test(factorial_test test_factorial)

