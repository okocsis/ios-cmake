include(CMakePushCheckState)
include(CheckCXXSourceCompiles)
include(CheckCXXSourceRuns)

cmake_push_check_state()

set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} -std=c++11")

if(CMAKE_CROSSCOMPILING)
    check_cxx_source_compiles("
    #include <regex>

    int main() {
        std::regex_replace(\"a\", std::regex(\"b+\"), \"c\");
    }
" HAVE_CXX11_REGEX)
else()
    check_cxx_source_runs("
    #include <regex>
    #include <string>

    int main() {
        std::string input = \"Apples and stairs.\";
        std::string output = std::regex_replace(input, std::regex(\"sta.+s\"), \"pears\");
        return output == \"Apples and pears.\" ? 0 : 1;
    }
" HAVE_CXX11_REGEX)
endif()

cmake_pop_check_state()

if("${HAVE_CXX11_REGEX}" STREQUAL "")
    set(HAVE_CXX11_REGEX OFF)
else()
    set(HAVE_CXX11_REGEX ON)
endif()
