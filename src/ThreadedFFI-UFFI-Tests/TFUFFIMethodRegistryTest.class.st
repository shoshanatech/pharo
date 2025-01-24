Class {
	#name : 'TFUFFIMethodRegistryTest',
	#superclass : 'TFUFFITestCase',
	#category : 'ThreadedFFI-UFFI-Tests',
	#package : 'ThreadedFFI-UFFI-Tests'
}

{ #category : 'tests' }
TFUFFIMethodRegistryTest >> testRegistryDoesNotRestoreUninstalledMethods [

	"Call the method to force installation"
	| ffiMethod |
	TFUFFITestClassWithTrait new pidfortest.
	
	ffiMethod := TFUFFITestClassWithTrait >> #pidfortest.
	ffiMethod recompile.
	FFIMethodRegistry uniqueInstance resetMethod: ffiMethod.

	self assert: TFUFFITestClassWithTrait localMethods first isInstalled.
]
