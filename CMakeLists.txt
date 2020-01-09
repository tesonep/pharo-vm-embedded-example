cmake_minimum_required(VERSION 2.8.4)

# Use new and simpler escape sequences
cmake_policy(SET CMP0053 NEW)

set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
set(VERSION_PATCH 0)

# This is to correctly detect the compiler under cygwin!
if ((CMAKE_HOST_UNIX) AND (${CMAKE_HOST_SYSTEM_NAME} MATCHES "CYGWIN*"))
  set(CYGWIN 1)
  set(WIN 1)

  # specify the cross compiler
  set(CMAKE_TOOLCHAIN_PREFIX x86_64-w64-mingw32)

  SET(CMAKE_C_COMPILER   ${CMAKE_TOOLCHAIN_PREFIX}-clang)
  SET(CMAKE_CXX_COMPILER ${CMAKE_TOOLCHAIN_PREFIX}-clang++)
  SET(CMAKE_RC_COMPILER ${CMAKE_TOOLCHAIN_PREFIX}-windres)
  SET(CMAKE_SYSTEM_PROCESSOR x86_64)
endif()

#Creating a new project
project(EmbeddedExample)

# Setting the output of the product
set(EXECUTABLE_OUTPUT_PATH "build/output")

#We set some compiller flags: just to include debugging symbols. 
set(CMAKE_C_FLAGS "-g")
set(CMAKE_CXX_FLAGS "-g")

#Adding the generation of the resource file with the correct paths. 
configure_file(src/resources.rc.in	
	${CMAKE_CURRENT_BINARY_DIR}/build/src/resources.rc)


#
# This section is to generate the image. 
# We will have a serie of targets to download the image, download a vm and to load the code.
#

# Creation of the directories
make_directory(${CMAKE_CURRENT_BINARY_DIR}/build/vm)
make_directory(${CMAKE_CURRENT_BINARY_DIR}/build/resources)
make_directory(${CMAKE_CURRENT_BINARY_DIR}/build/include)
make_directory(${CMAKE_CURRENT_BINARY_DIR}/build/lib)

# Adding a task to download the vm
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/build/vm/pharo
	COMMAND wget -O - https://get.pharo.org/64/vmHeadlessLatest80 | bash
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/build/vm
	COMMENT "Downloading Pharo 80 VM (headless)")

# Adding a task to download the image
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/build/resources/Pharo.image
	COMMAND wget -O - https://get.pharo.org/64/80 | bash
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/build/resources
	COMMENT "Downloading Pharo 80 Image")

# Loading the code
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/build/resources/codeLoaded.txt
	COMMAND ${CMAKE_CURRENT_BINARY_DIR}/build/vm/pharo Pharo.image eval 1+1 && touch codeLoaded.txt 
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/build/resources
	DEPENDS 
		${CMAKE_CURRENT_BINARY_DIR}/build/resources/Pharo.image
		${CMAKE_CURRENT_BINARY_DIR}/build/vm/pharo
	COMMENT "Load Code")

#Setting the include directories
# - The includes in this project
# - The includes from the VM code
include_directories(
	${CMAKE_CURRENT_SOURCE_DIR}/include
	${CMAKE_CURRENT_BINARY_DIR}/build/include/)

# This are the files to compile in our small project.
set(CLIENT_SOURCES
	src/embeddedImage.c
	${CMAKE_CURRENT_BINARY_DIR}/build/src/resources.rc
	src/main.c
	${CMAKE_CURRENT_BINARY_DIR}/build/resources/codeLoaded.txt)

# We declare the executable.
add_executable(EmbeddedPharo WIN32 ${CLIENT_SOURCES})

# We link the executable with the VM library.
target_link_directories(EmbeddedPharo PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/build/lib/)
target_link_libraries(EmbeddedPharo PharoVMCore)
