Extension { #name : #CommandLineUIManager }

{ #category : #'*Embedded-Support' }
CommandLineUIManager >> unhandledErrorDefaultAction: anException [


	"If handled"
	(EmbeddedSupport unhandledErrorDefaultAction: anException)
		ifTrue: [ ^ self ].
		
	self quitFrom: anException signalerContext  withMessage: anException description.
	
	UIManager default == self ifFalse: [
		^ UIManager default unhandledErrorDefaultAction: anException
		]
]
