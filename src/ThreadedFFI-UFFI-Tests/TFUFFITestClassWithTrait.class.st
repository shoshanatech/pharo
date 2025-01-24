Class {
	#name : 'TFUFFITestClassWithTrait',
	#superclass : 'FFILibrary',
	#traits : 'TFFITraitForTest',
	#classTraits : 'TFFITraitForTest classTrait',
	#category : 'ThreadedFFI-UFFI-Tests',
	#package : 'ThreadedFFI-UFFI-Tests'
}

{ #category : 'accessing - platform' }
TFUFFITestClassWithTrait >> macLibraryName [
	^ 'libc.dylib'
]

{ #category : 'accessing' }
TFUFFITestClassWithTrait >> pidfortest [

	self ffiCall: #(size_t getpid())
]

{ #category : 'accessing - platform' }
TFUFFITestClassWithTrait >> unixLibraryName [
	^ 'libc.so.6'
]

{ #category : 'accessing - platform' }
TFUFFITestClassWithTrait >> win32LibraryName [
	"While this is not a 'libc' properly, msvcrt has the functions we are defining here"
	^ 'msvcrt.dll'
]
