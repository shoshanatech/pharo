"
I represent the instruction ""pushLiteral: object"".

From the bytecode perspective: The bytecode will be either specialized for literals that are not placed in the method literal frame or the bytecode will refer to the literal in the method literal frame using an offset.
"
Class {
	#name : 'IRPushLiteral',
	#superclass : 'IRInstruction',
	#instVars : [
		'literal'
	],
	#category : 'OpalCompiler-Core-IR-Nodes',
	#package : 'OpalCompiler-Core',
	#tag : 'IR-Nodes'
}

{ #category : 'visiting' }
IRPushLiteral >> accept: aVisitor [
	^ aVisitor visitPushLiteral: self
]

{ #category : 'testing' }
IRPushLiteral >> canBeQuickReturn [
	^ true
]

{ #category : 'testing' }
IRPushLiteral >> isPushLiteral [

	^ true
]

{ #category : 'testing' }
IRPushLiteral >> isPushLiteral: valueTest [
	^ valueTest value: literal
]

{ #category : 'testing' }
IRPushLiteral >> isRemovableByPop [
	"Be conservative to keep symbols and other things"

	^ (#( nil true false ) includes: literal) or: [ literal isNumber ]
]

{ #category : 'accessing' }
IRPushLiteral >> literal [

	^ literal
]

{ #category : 'accessing' }
IRPushLiteral >> literal: object [

	literal := object
]

{ #category : 'accessing' }
IRPushLiteral >> quickRetNode [
	^ IRReturnLiteral new
		literal: literal;
		yourself
]
