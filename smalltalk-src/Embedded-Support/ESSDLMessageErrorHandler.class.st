Class {
	#name : #ESSDLMessageErrorHandler,
	#superclass : #Object,
	#category : #'Embedded-Support'
}

{ #category : #'as yet unclassified' }
ESSDLMessageErrorHandler >> unhandledError: anError [

	SDL2
		showSimpleMessageBox: anError messageText utf8Encoded
		title: 'An Error has occured...' utf8Encoded 
		flags: 16r00000010
		window: ExternalAddress null.
	
	Smalltalk snapshot: false andQuit: true.
		
	^ true
]
