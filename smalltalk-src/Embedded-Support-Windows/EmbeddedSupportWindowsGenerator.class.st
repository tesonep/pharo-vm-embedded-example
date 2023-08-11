Class {
	#name : #EmbeddedSupportWindowsGenerator,
	#superclass : #EmbeddedSupportGenerator,
	#category : #'Embedded-Support-Windows'
}

{ #category : #copying }
EmbeddedSupportWindowsGenerator >> copy: source to: dest [

	dest ensureDelete.
	source copyTo: dest
]

{ #category : #copying }
EmbeddedSupportWindowsGenerator >> copyIcon [

	self copy: self iconFile to: outputDirectory / 'icon.ico'
]

{ #category : #copying }
EmbeddedSupportWindowsGenerator >> copyIncludes [

	| includeDir |
	includeDir := outputDirectory / 'include'.
	includeDir ensureCreateDirectory.
	
	self copy: self templateDirectory / 'include' / 'resources.h' to: includeDir / 'resources.h'.
]

{ #category : #copying }
EmbeddedSupportWindowsGenerator >> copySources [

	| srcDir template generatedContent |
	srcDir := outputDirectory / 'src'.
	srcDir ensureCreateDirectory.

	self copy: self templateDirectory / 'src' / 'embeddedImage.c' to: srcDir / 'embeddedImage.c'.
	self copy: self templateDirectory / 'src' / 'resources.rc.in' to: srcDir / 'resources.rc.in'.
	
	template := (self templateDirectory / 'src' / 'main.c.template') contents.
	generatedContent := template format: properties.

	outputDirectory / 'src' / 'main.c' writeStreamDo: [ :s |
		s truncate.
		s nextPutAll: generatedContent ]		
]

{ #category : #utilities }
EmbeddedSupportWindowsGenerator >> fillWithDefaults [
	
	super fillWithDefaults.

	properties at: #IconFile ifAbsentPut: (self templateDirectory / 'icon.ico' ).
	properties at: #ImageDirEscaped ifAbsentPut: ((properties at: #ImageDir) copyReplaceAll: '\' with: '\\')
	
]

{ #category : #translating }
EmbeddedSupportWindowsGenerator >> generate [
	
	| appDirectory |
	
	super generate.

	self copyIcon.
	self copyIncludes.
	self copySources.
	self generateCMakeScript
]

{ #category : #generation }
EmbeddedSupportWindowsGenerator >> generateCMakeScript [

	| template generatedContent |
	
	template := (self templateDirectory / 'CMakeLists.txt.template') contents.
	generatedContent := template format: properties.

	outputDirectory / 'CMakeList.txt' writeStreamDo: [ :s |
		s truncate.
		s nextPutAll: generatedContent ]		
]

{ #category : #accessing }
EmbeddedSupportWindowsGenerator >> iconFile [
	
	^ properties at: #IconFile 
]

{ #category : #accessing }
EmbeddedSupportWindowsGenerator >> platformName [
	
	^ 'Windows'
]
