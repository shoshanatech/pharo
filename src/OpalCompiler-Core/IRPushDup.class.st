"
I'm quite badly named. 

Instruction ""pushDup"" I'm basically emitting a bytecode that duplicate the top stack.
"
Class {
	#name : 'IRPushDup',
	#superclass : 'IRInstruction',
	#category : 'OpalCompiler-Core-IR-Nodes',
	#package : 'OpalCompiler-Core',
	#tag : 'IR-Nodes'
}

{ #category : 'visiting' }
IRPushDup >> accept: aVisitor [
	^ aVisitor visitPushDup: self
]

{ #category : 'testing' }
IRPushDup >> isRemovableByPop [

	^ true
]
