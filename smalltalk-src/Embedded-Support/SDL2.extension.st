Extension { #name : #SDL2 }

{ #category : #'*Embedded-Support' }
SDL2 class >> showSimpleMessageBox: message title: title flags: flags window: window [

	^ self ffiCall: #(int SDL_ShowSimpleMessageBox(Uint32 flags, const char *title, const char *message, SDL_Window window))
]
