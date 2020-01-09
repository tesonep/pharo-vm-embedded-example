#include <stdio.h>
#include "pharovm/pharo.h"
#include "pharovm/pharoClient.h"
#include "pharovm/imageAccess.h"

/**
 * In this example we are going to create a VM and run it with an embedded image.
 * We are going to send a set of parameters that we have "hardcoded", so we can control
 * exactly what we are executing
 *
 * The image is the one that will be generated in build/resources/Pharo.image
 *
 * This image loads the code in smalltalk-src
 * This code:
 * - improves some operations to better handling read-only images embedded (without .changes or .sources files)
 * - add a new commandLine handler that opens the SDL2AthensDrawingExample and does not quit.
 *
 */

/*
 * The set of arguments to pass to the image.
 */
char* args[] = {"","Pharo.image", "embeddedExample", "--embedded"};

extern FileAccessHandler embeddedFileAccess;

int main(int argc, char *argv[], const char *env[]){

	/*
	 * I am creating a VMParameters with the information
	 * that I want to send to the image.
	 */
	VMParameters parameters = {};
	parameters.processArgc = 6;
	parameters.processArgv = (const char**)args;
	parameters.environmentVector = env;

	/**
	 * I have to set the first argument correctly as this one is used to extract the path to the VM
	 */
	args[0] = argv[0];

	parameters.imageFileName = "Pharo.image";
	parameters.isDefaultImage = true;
	parameters.defaultImageFound = true;

	/**
	 * I will replace the access to the file with the ones in the embeddedImage.c file
	 * This functions handles the reading of the image from the resources
	 */
	setFileAccessHandler(&embeddedFileAccess);

	/* I pass "made up" parameters to the VM to handle them.
	* In this case to handle the logic of the '--logLevel' parameter we have to call this function
	* To give the VM the opportunity of parsing the log parameter
	*/
	vm_parameters_parse(6, (const char**)args, &parameters);

	/*
	 * I force the vm to start in a non interactive Session.
	 * As the VM tries to detect if launched from the console or from the desktop.
	 * In an interactive session the image opens a window with the Pharo World.
	 */
	parameters.isInteractiveSession = false;

	int exitCode = vm_main_with_parameters(&parameters);
	vm_parameters_destroy(&parameters);
	return exitCode;
}
