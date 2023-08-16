Class {
	#name : #BaselineOfEmbeddedSupport,
	#superclass : #BaselineOf,
	#category : #BaselineOfEmbeddedSupport
}

{ #category : #baselines }
BaselineOfEmbeddedSupport >> baseline: spec [
	<baseline>

	spec for: #common do: [ 
		spec 
			package: 'Embedded-Support';
			package: 'Embedded-Support-Example';
			package: 'Embedded-Support-OSX';
			package: 'Embedded-Support-Windows' ]
]
