Class {
	#name : #EmbeddedSupport,
	#superclass : #Object,
	#classVars : [
		'ErrorHandler'
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
