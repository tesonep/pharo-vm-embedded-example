Class {
	#name : #EmbeddedSupport,
	#superclass : #Object,
	#category : #'Embedded-Support'
}

{ #category : #testing }
EmbeddedSupport class >> isEmbedded [ 

	^ Smalltalk argumentsInclude: '--embedded'
		
]
