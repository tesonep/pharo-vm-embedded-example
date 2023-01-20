Class {
	#name : #EmbeddedSupportCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Embedded-Support'
}

{ #category : #accessing }
EmbeddedSupportCommandLineHandler class >> commandName [

	^ 'embeddedExample'
]

{ #category : #activation }
EmbeddedSupportCommandLineHandler >> activate [

	OSWindowDriver current startUp: true.

	SDL2AthensDrawingExample new open.
	
]
