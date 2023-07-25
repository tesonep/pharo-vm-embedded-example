Extension { #name : #SDLOSXPlatform }

{ #category : #'*Embedded-Support' }
SDLOSXPlatform >> initPlatformSpecific [
	| sel cls sharedApplication |

	sel := self lookupSelector: 'sharedApplication'.
	cls := self lookupClass: 'NSApplication'.
	sharedApplication := self sendMessage: sel to: cls.
	
	self sendMessage: (self lookupSelector: 'finishLaunching') to: sharedApplication

]
