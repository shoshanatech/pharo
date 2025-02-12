"
Adds a method in a class. The source code of the method, as well as the protocol in which the method will be categorized, can be specified.

Usage:
| transformation |
transformation := (RBAddMethodTransformation
		sourceCode: 'printString1 ^super printString'
		in: RBTransformationTest
		withProtocol: #accessing)
		transform.
(ChangesBrowser changes: transformation model changes changes) open

Preconditions:
The source code of the method must be syntactically valid.
"
Class {
	#name : 'RBAddMethodTransformation',
	#superclass : 'RBMethodTransformation',
	#instVars : [
		'sourceCode',
		'rbMethod',
		'protocol'
	],
	#category : 'Refactoring-Transformations-Model-Unused',
	#package : 'Refactoring-Transformations',
	#tag : 'Model-Unused'
}

{ #category : 'api' }
RBAddMethodTransformation class >> model: aRBModel sourceCode: aString in: aClass withProtocol: aProtocol [

	^ self new
		model: aRBModel;
		sourceCode: aString
		in: aClass
		withProtocol: aProtocol;
		yourself
]

{ #category : 'api' }
RBAddMethodTransformation class >> sourceCode: aString in: aClass withProtocol: aProtocol [

	^ self new
		sourceCode: aString
		in: aClass
		withProtocol: aProtocol;
		yourself
]

{ #category : 'preconditions' }
RBAddMethodTransformation >> applicabilityPreconditions [

	rbMethod := self parserClass
		parseMethod: sourceCode
		onError: [ :string :position |
			^ RBCondition
				withBlock: [ self
						refactoringError: 'The content of this method cannot be parsed.' ] ].
	rbMethod selector
		ifNil: [ self refactoringError: 'The method has no selector.' ].
	^ self trueCondition
]

{ #category : 'accessing' }
RBAddMethodTransformation >> method [

	^ rbMethod 
]

{ #category : 'transforming' }
RBAddMethodTransformation >> privateTransform [

	self definingClass
		compile: sourceCode
		classified: protocol
]

{ #category : 'accessing' }
RBAddMethodTransformation >> selector [

	^ rbMethod selector
]

{ #category : 'api' }
RBAddMethodTransformation >> sourceCode: aString in: aClassName withProtocol: aSymbol [

	self className: aClassName.
	sourceCode := aString.
	protocol := aSymbol
]

{ #category : 'printing' }
RBAddMethodTransformation >> storeOn: aStream [

	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' sourceCode: '''.
	sourceCode storeOn: aStream.
	aStream nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' withProtocol: '.
	protocol storeOn: aStream.
	aStream nextPut: $)
]
