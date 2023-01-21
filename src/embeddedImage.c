#include "pharovm/pharo.h"
#include "windows.h"
#include "resources.h"

typedef struct {

	HGLOBAL handler;

	void* data;

	size_t pos;
	size_t size;

} EmbeddedImage;


EXPORT(sqInt) embeddedImageFileClose(void* f){

	EmbeddedImage * file = (EmbeddedImage*)f;

	if(file == NULL)
		return EOF;

	free(file);

	return 0;
}

EXPORT(sqImageFile) embeddedImageFileOpen(const char* fileName, char *mode){
	HGLOBAL res_handle = NULL;
	HRSRC res;
	void * res_data;
	DWORD res_size;
	EmbeddedImage* fileHandler;

	// NOTE: providing g_hInstance is important, NULL might not work
	res = FindResource(NULL, MAKEINTRESOURCE(EMBEDDED_IMAGE), RT_RCDATA);

	if (!res)
		return NULL;

	res_handle = LoadResource(NULL, res);
	if (!res_handle)
		return NULL;

	res_data = LockResource(res_handle);
	res_size = SizeofResource(NULL, res);

	fileHandler = (EmbeddedImage*) malloc(sizeof(EmbeddedImage));
	if(fileHandler == NULL)
		return NULL;

	fileHandler->handler = res_handle;
	fileHandler->data = res_data;
	fileHandler->pos = 0;
	fileHandler->size=res_size;

	return fileHandler;
}

EXPORT(long int) embeddedImageFilePosition(sqImageFile f){
	return ((EmbeddedImage *)f)->pos;
}

EXPORT(size_t) embeddedImageFileRead(void * ptr, size_t sz, size_t count, sqImageFile f){

	size_t toRead;
	size_t remaining;

	EmbeddedImage* fileHandler = (EmbeddedImage*)f;

	if(fileHandler == NULL || sz == 0 || count == 0)
		return 0;

	if(fileHandler->pos == fileHandler->size){
		return 0;
	}

	remaining = fileHandler->size - fileHandler->pos;
	toRead = count * sz;
	toRead = toRead > remaining ? remaining : toRead;

	if(toRead == 0)
		return 0;

	memcpy(ptr, (void*)(fileHandler->data + fileHandler->pos), toRead);

	fileHandler->pos += toRead;

	return toRead;
}

EXPORT(int) embeddedImageFileSeek(sqImageFile fileHandler, long int pos){
	((EmbeddedImage*)fileHandler)->pos = pos;
	return 0;
}

EXPORT(int) embeddedImageFileSeekEnd(sqImageFile fileHandler, long int offset){
	((EmbeddedImage*)fileHandler)->pos = offset + ((EmbeddedImage*)fileHandler)->size;
	return 0;
}

EXPORT(size_t) embeddedImageFileWrite(void* ptr, size_t sz, size_t count, sqImageFile fileHandler){
	//Sorry I can't write I am reading a resource
	return 0;
}

EXPORT(int) embeddedImageFileExists(const char* aPath){
	//It always exists!
	return 1;
}

EXPORT(FileAccessHandler) embeddedFileAccess = {
	embeddedImageFileClose,
	embeddedImageFileOpen,
	embeddedImageFilePosition,
	embeddedImageFileRead,
	embeddedImageFileSeek,
	embeddedImageFileSeekEnd,
	embeddedImageFileWrite,
	embeddedImageFileExists
};


