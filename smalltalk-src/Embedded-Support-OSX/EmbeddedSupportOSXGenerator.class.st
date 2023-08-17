Class {
	#name : #EmbeddedSupportOSXGenerator,
	#superclass : #EmbeddedSupportGenerator,
	#category : #'Embedded-Support-OSX'
}

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

{ #category : #utilities }
EmbeddedSupportOSXGenerator >> fillWithDefaults [
	
	super fillWithDefaults.
	
	properties at: #BundleIdentifier ifAbsentPut: 'org.pharo.example'.	
	properties at: #IconSetFile ifAbsentPut: (self templateDirectory / 'icon.icns' ).
	properties at: #InstallerBackgroundFile ifAbsentPut: (self templateDirectory / 'installer-background.png').
	
]

{ #category : #translating }
EmbeddedSupportOSXGenerator >> generate [
	
	| appDirectory |
	
	super generate.

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

	self
		copyTemplate: self templateDirectory / 'build.sh.template'
		to: outputDirectory / 'build.sh'
]

{ #category : #'as yet unclassified' }
EmbeddedSupportOSXGenerator >> generatePListIn: appDirectory [

	(appDirectory / 'Contents') ensureCreateDirectory.
	self
		copyTemplate: self templateDirectory / 'Info.plist.template'
		to: appDirectory / 'Contents' / 'Info.plist'
]

{ #category : #accessing }
EmbeddedSupportOSXGenerator >> iconSetFile [
	
	^ properties at: #IconSetFile 
]

{ #category : #accessing }
EmbeddedSupportOSXGenerator >> platformName [

	^ 'Darwin'
]
