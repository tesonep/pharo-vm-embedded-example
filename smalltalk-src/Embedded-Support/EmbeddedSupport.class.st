Class {
	#name : #EmbeddedSupport,
	#superclass : #Object,
	#classVars : [
		'ErrorHandler',
		'WindowTitle'
	],
	#category : #'Embedded-Support'
}

{ #category : #'default actions' }
EmbeddedSupport class >> errorHandler [

	^ ErrorHandler ifNil: [ ESNullErrorHandler new ]
]

{ #category : #'default actions' }
EmbeddedSupport class >> errorHandler: anErrorHandler [

	ErrorHandler := anErrorHandler
]

{ #category : #testing }
EmbeddedSupport class >> isEmbedded [ 

	^ Smalltalk argumentsInclude: '--embedded'
		
]

{ #category : #'default actions' }
EmbeddedSupport class >> unhandledErrorDefaultAction: anException [

	self isEmbedded ifFalse: [ ^ false ].
	
	^ self errorHandler unhandledError: anException.
]

{ #category : #initialization }
EmbeddedSupport class >> windowTitle [

	^ self isEmbedded
		ifTrue: [ WindowTitle ifNil: [ 'Embedded image in working directory: ' , FileLocator workingDirectory fullName ] ]
		ifFalse: [ Smalltalk image imageFile fullName ]
]
