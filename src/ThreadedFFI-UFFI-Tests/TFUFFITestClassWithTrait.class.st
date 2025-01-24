Class {
	#name : 'TFUFFITestClassWithTrait',
	#superclass : 'Object',
	#traits : 'TFFITraitForTest',
	#classTraits : 'TFFITraitForTest classTrait',
	#category : 'ThreadedFFI-UFFI-Tests',
	#package : 'ThreadedFFI-UFFI-Tests'
}

{ #category : 'accessing' }
TFUFFITestClassWithTrait >> pidfortest [

	self ffiCall: #(size_t getpid()) library: 'libc.dylib'
]
