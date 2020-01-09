Extension { #name : #SmalltalkImage }

{ #category : #'*Embedded-Support' }
SmalltalkImage >> snapshot: save andQuit: quit [
	
	(SessionManager default currentSession isReadOnlyAccessMode and: [ save ])
		ifTrue: [ self error: 'Cannot save, in a read only image.' ].

	DefaultExecutionEnvironment beActiveDuring: 
		 [^SessionManager default snapshot: save andQuit: quit]
]
