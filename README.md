# Pharo VM Example: Showing how to embed an image.

This repository have an example of how to create a PharoVM with an embedded image.

In this example we create an application based on the SDL2AthensDrawingExample.
This example application, opens a SDL windows where it is possible to draw with the mouse.

The Pharo image is contained in the executable and it is modified so it does not write in the disk.
Also, it shows how to restrict the command line arguments and how to set a new icon and resources. 

The example is only for Windows applications, but it can easily extended to other platforms.


This example presents four elements: 
-----------------------------------

1- A CMake process to generate an application that uses the VM and embed the image in the executable.

2- An example of main program that instantiate and launch the embedded VM. This main program allows the programmers to add special 
behaviour before executing the image.

3- A set of modifications in the image to disable all writing and handling the embedded image.

4- The functions to handle the embedded image, using the abilitiy to have different strategies to access the image, 
this example proposes a solution to transparently handle embedded images. 

How to test it
--------------

The whole process is implemented using CMake and Cygwin. As it compiles a new executable some dependencies are needed:

- A working Pharo
- CMake (at least version 2.8.4)
- CLang
- Binutils (make and friends)
- wget
- unzip

If you are able to build the [Pharo Headless VM](https://github.com/pharo-project/opensmalltalk-vm/tree/headless) 
you have already all the dependencies.

As this example uses the Pharo Headless VM, it uses 64bits Pharo images.

To buld it, clone this repository and from Cygwin execute:

```bash
  cmake .
  make 
```

The created application will be in *build/output*, just executing it will open it.

