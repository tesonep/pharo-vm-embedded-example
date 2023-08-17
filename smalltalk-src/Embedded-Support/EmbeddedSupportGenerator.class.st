Class {
	#name : #EmbeddedSupportGenerator,
	#superclass : #Object,
	#instVars : [
		'properties',
		'outputDirectory'
	],
	#category : #'Embedded-Support'
}

{ #category : #accessing }
EmbeddedSupportGenerator >> appName [
	
	^ properties at: #AppName
]

{ #category : #copying }
EmbeddedSupportGenerator >> copyTemplate: inputTemplate to: outputFile [

	| generatedContent template |
	template := inputTemplate contents.
	generatedContent := template format: properties.
	outputFile writeStreamDo: [ :s |
		s truncate.
		s nextPutAll: generatedContent ]
]

{ #category : #utilities }
EmbeddedSupportGenerator >> fillWithDefaults [
	
	properties at: #AppName ifAbsentPut: 'MyApp'.
	properties at: #InfoString ifAbsentPut: 'My Test Application'.

	properties at: #ShortVersion ifAbsentPut: '0.0.1'.
	properties at: #Version ifAbsentPut: (properties at: #ShortVersion).
	properties at: #DisplayName ifAbsentPut: 'My App'.

	properties at: #ImageFile ifAbsentPut: Smalltalk imageFile.
	properties at: #ImageName ifAbsentPut: (properties at: #ImageFile) basename.
	properties at: #ImageDir ifAbsentPut: (properties at: #ImageFile) resolve parent fullName.
	properties at: #ChangesName ifAbsentPut: ((properties at: #ImageFile) resolve withExtension: 'changes') basename.

	properties at: #CommandLineHandler ifAbsentPut: 'embeddedExample'.

]

{ #category : #translating }
EmbeddedSupportGenerator >> generate [

	self fillWithDefaults.

	outputDirectory ensureCreateDirectory. 

]

{ #category : #accessing }
EmbeddedSupportGenerator >> outputDirectory: aFileReference [ 
	
	outputDirectory := aFileReference
]

{ #category : #accessing }
EmbeddedSupportGenerator >> properties: aCollection [ 
	
	properties := aCollection
]

{ #category : #accessing }
EmbeddedSupportGenerator >> templateDirectory [
	
	^ (IceRepository repositoryNamed: 'pharo-vm-embedded-example') location / 'templates' / self platformName
]
