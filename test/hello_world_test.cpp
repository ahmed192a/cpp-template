#include "doctest.h"

#include <My_Template/hello_world.hpp>

#include <iostream> // Needed in OSX builds for some weird reason.
                    // See https://github.com/onqtam/doctest/issues/126#issuecomment-381742003
#include <string> // This isn't needed but it clarifies intent.

TEST_CASE("class HelloWorld")
{
    HelloWorld helloWorld;
    
    SUBCASE("function hello()")
    {
        CHECK(helloWorld.hello() == "Hello");
    }
    SUBCASE("function world()")
    {
        CHECK(helloWorld.world() == "World");
    }
    SUBCASE("function generateRandomNumber()")
    {
        CHECK(helloWorld.generateRandomNumber() == 4000);
    }
    SUBCASE("function headerFunction()")
    {
        CHECK(helloWorld.headerFunction(6) == 3);
        // Intentionally incomplete code coverage
        CHECK(helloWorld.headerFunction(5) == 3);
    }
}
