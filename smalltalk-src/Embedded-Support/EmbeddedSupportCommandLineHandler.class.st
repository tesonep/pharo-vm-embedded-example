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

	Stdio stdout << 'lala'; cr; flush. 
	SDL2AthensDrawingExample new open.
]
