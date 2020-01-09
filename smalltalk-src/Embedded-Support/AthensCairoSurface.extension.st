Extension { #name : #AthensCairoSurface }

{ #category : #'*Embedded-Support' }
AthensCairoSurface class >> primImageFromData: data width: width height: height pitch: stride [
	^ self ffiCall: #(AthensCairoSurface cairo_image_surface_create_for_data (
		void *data,
		0,
		int width,
		int height,
		int stride) )


]
