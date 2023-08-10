Class {
	#name : #EmbeddedSupportOSXGenerator,
	#superclass : #Object,
	#instVars : [
		'properties',
		'outputDirectory'
	],
	#category : #'Embedded-Support-OSX'
}

{ #category : #accessing }
EmbeddedSupportOSXGenerator >> appName [
	
	^ properties at: #AppName
]

{ #category : #copying }
EmbeddedSupportOSXGenerator >> copyIconSetIn: appDirectory [ 
	
	(appDirectory / 'Contents' / 'Resources') ensureCreateDirectory.
	
	(appDirectory / 'Contents' / 'Resources' / 'icon.icns') ensureDelete.
	self iconSetFile copyTo: (appDirectory / 'Contents' / 'Resources' / 'icon.icns').
	
	"Copying in the Build directory for the installer icon"
	(outputDirectory / 'installer.icns') ensureDelete.
	self iconSetFile copyTo: (outputDirectory / 'installer.icns')
	
]

{ #category : #copying }
EmbeddedSupportOSXGenerator >> copyInstallerBackground [
	
	| dst |
	dst := outputDirectory / 'installer-background.png'.	
	dst ensureDelete.
	(properties at: #InstallerBackgroundFile) copyTo: dst 
]

{ #category : #utils }
EmbeddedSupportOSXGenerator >> fillWithDefaults [
	
	properties at: #AppName ifAbsentPut: 'MyApp'.
	properties at: #InfoString ifAbsentPut: 'My Test Application'.
	properties at: #BundleIdentifier ifAbsentPut: 'org.pharo.example'.

	properties at: #ShortVersion ifAbsentPut: '0.0.1'.
	properties at: #Version ifAbsentPut: (properties at: #ShortVersion).
	properties at: #DisplayName ifAbsentPut: 'My App'.

	properties at: #ImageFile ifAbsentPut: Smalltalk imageFile.
	properties at: #ImageName ifAbsentPut: (properties at: #ImageFile) basename.
	properties at: #ImageDir ifAbsentPut: (properties at: #ImageFile) resolve parent fullName.
	properties at: #ChangesName ifAbsentPut: ((properties at: #ImageFile) resolve withExtension: 'changes') basename.

	properties at: #CommandLineHandler ifAbsentPut: 'embeddedExample'.
	
	properties at: #IconSetFile ifAbsentPut: (self templateDirectory / 'icon.icns' ).
	properties at: #InstallerBackgroundFile ifAbsentPut: (self templateDirectory / 'installer-background.png').
	
]

{ #category : #translating }
EmbeddedSupportOSXGenerator >> generate [
	
	| appDirectory |
	
	self fillWithDefaults.

	outputDirectory ensureCreateDirectory. 

	"Build App directory"
	appDirectory := outputDirectory / (self appName , '.app').
	appDirectory ensureCreateDirectory.
		
	self copyIconSetIn: appDirectory. 
	self generatePListIn: appDirectory.
	self copyInstallerBackground.
	
	self generateBuildScript.
]

{ #category : #generating }
EmbeddedSupportOSXGenerator >> generateBuildScript [

	| template generatedContent |

	template := (self templateDirectory / 'build.sh.template') contents.
	generatedContent := template format: properties.

	outputDirectory / 'build.sh' writeStreamDo: [ :s |
		s truncate.
		s nextPutAll: generatedContent ]
]

{ #category : #'as yet unclassified' }
EmbeddedSupportOSXGenerator >> generatePListIn: appDirectory [

	| template generatedContent |
	(appDirectory / 'Contents') ensureCreateDirectory.

	template := (self templateDirectory / 'Info.plist.template') contents.
	generatedContent := template format: properties.

	appDirectory / 'Contents' / 'Info.plist' writeStreamDo: [ :s |
		s truncate.
		s nextPutAll: generatedContent ]
]

{ #category : #accessing }
EmbeddedSupportOSXGenerator >> iconSetFile [
	
	^ properties at: #IconSetFile 
]

{ #category : #accessing }
EmbeddedSupportOSXGenerator >> outputDirectory: aFileReference [ 
	
	outputDirectory := aFileReference
]

{ #category : #accessing }
EmbeddedSupportOSXGenerator >> properties: aCollection [ 
	
	properties := aCollection
]

{ #category : #accessing }
EmbeddedSupportOSXGenerator >> templateDirectory [
	
	^ (IceRepository repositoryNamed: 'pharo-vm-embedded-example') location / 'templates' / 'Darwin'
]
