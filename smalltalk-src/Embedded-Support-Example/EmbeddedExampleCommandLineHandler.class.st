Class {
	#name : #EmbeddedExampleCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Embedded-Support-Example'
}

{ #category : #accessing }
EmbeddedExampleCommandLineHandler class >> commandName [

	^ 'embeddedExample'
]

{ #category : #activation }
EmbeddedExampleCommandLineHandler >> activate [

	OSWindowDriver current startUp: true.

	SDL2AthensDrawingExample new open.
	
]
