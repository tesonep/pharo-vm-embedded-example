Extension { #name : #OSWorldRenderer }

{ #category : #'*Embedded-Support' }
OSWorldRenderer >> doActivate [

	| attributes initialExtent |
	
	initialExtent := world worldState realWindowExtent ifNil: [976@665].

	attributes := OSWindowAttributes new.
	attributes
		extent: initialExtent;
		title: (self windowTitle);
		windowCentered:true;
		icon: (self iconNamed: #pharoBig).

	display := Form extent: initialExtent depth: 32.
	world extent: initialExtent.

	driver := self pickMostSuitableWindowDriver.
	attributes preferableDriver: driver.
	osWindow := OSWindow createWithAttributes: attributes eventHandler: (OSWindowMorphicEventHandler for: world).

	driver afterMainPharoWindowCreated: osWindow.
	driver afterSetWindowTitle: Smalltalk image imageFile fullName onWindow: osWindow.	
	driver startUp: true.
	
	osWindow focus. 
	
	world worldState doFullRepaint.
	world displayWorld.
	
	OSWindowClipboard new beDefault.
]

{ #category : #'*Embedded-Support' }
OSWorldRenderer >> windowTitle [

	^ EmbeddedSupport isEmbedded
		ifTrue: [ 'Embedded image in working directory: ' , FileLocator workingDirectory fullName ]
		ifFalse: [ Smalltalk image imageFile fullName ]
]
