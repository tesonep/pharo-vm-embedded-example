Class {
	#name : #EmbeddedExampleCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Embedded-Support'
}

{ #category : #activation }
EmbeddedExampleCommandLineHandler >> activate [

	SDL2AthensDrawingExample new open.

]
