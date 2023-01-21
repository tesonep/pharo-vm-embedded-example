Class {
	#name : #ESNullErrorHandler,
	#superclass : #Object,
	#category : #'Embedded-Support'
}

{ #category : #'as yet unclassified' }
ESNullErrorHandler >> unhandledError: anError [

	"I cannot handle, let's kill the image"
	^ false
]
