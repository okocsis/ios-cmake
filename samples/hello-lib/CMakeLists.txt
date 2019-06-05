# Standard setup
cmake_minimum_required (VERSION 3.14.5)
project(hello-lib CXX C)

### Preamble ###
# Must use GNUInstallDirs to install libraries into correct
# locations on all platforms.
include(GNUInstallDirs)

# Segregate AppleClang from Clang
cmake_policy(SET CMP0025 NEW)

# Includes
include_directories(${hello-lib_SOURCE_DIR})

# Source files
set(SRC
	./HelloWorld.cpp
	./HelloIOS.mm
)

# Headers
set(HDR
	./HelloWorld.h
	./HelloIOS.h
)

# Library
add_library(hello-lib STATIC)

target_sources(hello-lib
	PRIVATE
		./HelloWorld.h
		./HelloIOS.h
		./HelloWorld.cpp
		./HelloIOS.mm
)

# target_include_directories(hello-lib
#     PUBLIC 
#         $<INSTALL_INTERFACE:include>    
#         $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
#     PRIVATE
#         ${CMAKE_CURRENT_SOURCE_DIR}/src
# )

target_compile_options(hello-lib PRIVATE -Werror)
target_compile_features(hello-lib PRIVATE cxx_std_11)

# Installation
set(CMAKE_INSTALL_PREFIX "${hello-lib_SOURCE_DIR}/../hello-app/hello-app")
install(TARGETS hello-lib DESTINATION .)
install(FILES HelloIOS.h DESTINATION .)
