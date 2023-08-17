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

	| srcDir templateSrc |

	templateSrc := self templateDirectory / 'src'.
	srcDir := outputDirectory / 'src'.
	srcDir ensureCreateDirectory.

	self
		copy: templateSrc / 'embeddedImage.c'
		to: srcDir / 'embeddedImage.c'.

	self
		copyTemplate: templateSrc / 'resources.rc.in'
		to: srcDir / 'resources.rc.in'.

	self
		copyTemplate: templateSrc / 'main.c.template'
		to: srcDir / 'main.c'
]

{ #category : #utilities }
EmbeddedSupportWindowsGenerator >> fillWithDefaults [
	
	super fillWithDefaults.

	properties at: #IconFile ifAbsentPut: (self templateDirectory / 'icon.ico' ).
	properties at: #ImageDirEscaped ifAbsentPut: ((properties at: #ImageDir) copyReplaceAll: '\' with: '\\').
	
	properties at: #VersionWindowsFormat ifAbsentPut: ((properties at:#ShortVersion) copyReplaceAll: '.' with: ',').
	properties at: #CompanyName ifAbsentPut: 'MyCompany'.
	properties at: #LegalCopyright ifAbsentPut: 'My Company Copyright'.
	
	
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

	self
		copyTemplate: self templateDirectory / 'CMakeLists.txt.template'
		to: outputDirectory / 'CMakeLists.txt'
]

{ #category : #accessing }
EmbeddedSupportWindowsGenerator >> iconFile [
	
	^ properties at: #IconFile 
]

{ #category : #accessing }
EmbeddedSupportWindowsGenerator >> platformName [
	
	^ 'Windows'
]
