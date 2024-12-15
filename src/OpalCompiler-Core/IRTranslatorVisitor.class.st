"
I responsible to translate the IR instructions into bytecode. 
I delegate, however such a task to a BytecodeGenerator.
So I visit IRMethod instructions, sending the appropriate messages to my BytecodeGenerator (gen). 

Check `IRMethod>>#generate`.
"
Class {
	#name : 'IRTranslatorVisitor',
	#superclass : 'IRVisitor',
	#instVars : [
		'gen',
		'currentScope',
		'tempVectorStack',
		'compilationContext'
	],
	#category : 'OpalCompiler-Core-IR-Manipulation',
	#package : 'OpalCompiler-Core',
	#tag : 'IR-Manipulation'
}

{ #category : 'instance creation' }
IRTranslatorVisitor class >> context: aCompilationContext [
	^self basicNew
		initialize;
		compilationContext: aCompilationContext
]

{ #category : 'instance creation' }
IRTranslatorVisitor class >> new [
	^self context: CompilationContext default
]

{ #category : 'accessing' }
IRTranslatorVisitor >> compilationContext [
	^ compilationContext
]

{ #category : 'accessing' }
IRTranslatorVisitor >> compilationContext: aContext [
	compilationContext := aContext.
	gen := compilationContext bytecodeGeneratorClass newWithEncoderClass: compilationContext encoderClass.
	gen compilationContext: aContext
]

{ #category : 'results' }
IRTranslatorVisitor >> compiledBlock [
	^ gen compiledBlock
]

{ #category : 'results' }
IRTranslatorVisitor >> compiledMethod [
	^ gen compiledMethod
]

{ #category : 'private' }
IRTranslatorVisitor >> currentScope [
	^currentScope top
]

{ #category : 'initialization' }
IRTranslatorVisitor >> initialize [
	currentScope := Stack new.
	tempVectorStack := Stack new
]

{ #category : 'private' }
IRTranslatorVisitor >> label: seqNum [

	gen label: seqNum
]

{ #category : 'private' }
IRTranslatorVisitor >> popScope [

	currentScope size = 1 ifFalse: [currentScope pop]
]

{ #category : 'private' }
IRTranslatorVisitor >> pragmas: aCollection [
	gen pragmas: aCollection
]

{ #category : 'results' }
IRTranslatorVisitor >> pushOuterVectors: scope [
	| scopesWithVector sc |
	scopesWithVector := OrderedCollection new.
	sc := scope.
	[ sc outerScope isNil or: [ sc outerScope isBehavior ] ] whileFalse: [
		sc := sc outerScope.
		sc hasTempVector ifTrue: [ scopesWithVector add: sc ] ].
	scopesWithVector reverseDo: [ :scopeWithVector |
		tempVectorStack push: (IRInstruction
			createTempVectorNamed: scopeWithVector tempVectorName
			withVars: scopeWithVector tempVectorVarNames)].
	gen inBlock: true
]

{ #category : 'private' }
IRTranslatorVisitor >> pushScope: anIRBlockOrMethod [

	currentScope push: anIRBlockOrMethod
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitBlockReturnTop: blockReturnTop [

	gen blockReturnTop
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitInstruction: instr [
	gen mapBytesTo: instr.
	self visitNode: instr
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitJump: jump [

	gen goto: jump destination orderNumber
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitJumpIf: jumpIf [

	gen
		if: jumpIf boolean
		goto: jumpIf destination orderNumber
		otherwise: jumpIf otherwise orderNumber
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitMethod: anIr [
	IRFix new visitNode: anIr.
	self pushScope: anIr.
	gen irPrimitive: anIr irPrimitive.
	gen numArgs: anIr numArgs.
	gen properties: anIr properties.
	gen numTemps: (anIr tempMap size).
	gen forceLongForm: self compilationContext optionLongIvarAccessBytecodes.
	self visitSequences: anIr allSequences.
	"Literals for sends and pushLiteral: are added later, here we
	add all the additionalLiterals from e.g. optimized constructs like #ifTrue:.
	that have been added with #addLiteral:.
	With the new bytecode set we have no constraints and can just add all of them."
	anIr additionalLiterals do: [ :each | gen addLiteral: each ]
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPop: pop [

	gen popTop
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPopIntoInstVar: instVar [
	gen storePopInstVar: instVar index
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPopIntoLiteralVariable: var [

	gen storePopIntoLiteralVariable: var association
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPopIntoRemoteTemp: remoteTemp [
	| tempIndex tempVectorIndex tempVector |

	tempVector := tempVectorStack detect: [ :each | each name = remoteTemp tempVectorName ].
	tempVectorIndex := tempVector indexForVarNamed: remoteTemp name.
	tempIndex := self currentScope indexForVarNamed: remoteTemp tempVectorName.

	gen storePopRemoteTemp: tempVectorIndex inVectorAt: tempIndex
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPopIntoTemp: tmp [

   	gen storePopTemp: (self currentScope indexForVarNamed: tmp name)
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushArray: array [

	array cons
		ifTrue: [
			gen pushConsArray: array size ]
		ifFalse: [
			gen pushNewArray: array size ]
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushDup: dup [

	gen pushDup
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushFullClosure: fullBlock [

	fullBlock copiedValues do: [:name |
		gen pushTemp: (self currentScope indexForVarNamed: name)].
	gen mapBytesTo: fullBlock.
	gen pushFullBlockClosure: fullBlock
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushInstVar: instVar [

	gen pushInstVar: instVar index
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushLiteral: lit [
	^ gen pushLiteral: lit literal beReadOnlyLiteral
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushLiteralVariable: var [

	gen pushLiteralVariable: var association
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushReceiver: receiver [

	gen pushReceiver
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushRemoteTemp: remoteTemp [
	| tempIndex tempVectorIndex tempVector |

	tempVector := tempVectorStack detect: [:each | each name = remoteTemp tempVectorName].
	tempVectorIndex := tempVector indexForVarNamed: remoteTemp name.
	tempIndex := self currentScope indexForVarNamed: remoteTemp tempVectorName.

	gen pushRemoteTemp: tempVectorIndex inVectorAt: tempIndex
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushTemp: tmp [

	gen pushTemp: (self currentScope indexForVarNamed: tmp name)
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushThisContext: ctxt [

	gen pushThisContext
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitPushThisProcess: pushThisProcess [
	gen pushThisProcess
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitReturn: ret [

	gen returnTop
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitReturnInstVar: instVar [

	gen returnInstVar: instVar index
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitReturnLiteral: lit [

	gen returnConstant: lit literal
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitReturnReceiver: rec [

	gen returnReceiver
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitSend: send [

	send superOf
		ifNil: [ gen send: send selector ]
		ifNotNil: [ :behavior |  gen send: send selector toSuperOf: behavior ]
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitSequence: instructionSequence [
	self label: instructionSequence orderNumber.
	super visitSequence: instructionSequence
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitSequences:  irSequences [
	irSequences withIndexDo: [ :seq :i | seq orderNumber: i].
	self visitNodes: irSequences
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitStoreInstVar: instVar [
	gen storeInstVar: instVar index
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitStoreLiteralVariable: var [

	gen storeIntoLiteralVariable: var association
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitStoreRemoteTemp: remoteTemp [
	| tempIndex tempVectorIndex tempVector |

	tempVector := tempVectorStack detect: [:each | each name = remoteTemp tempVectorName].
	tempVectorIndex := tempVector indexForVarNamed: remoteTemp name.
	tempIndex := self currentScope indexForVarNamed: remoteTemp tempVectorName.

	gen storeRemoteTemp: tempVectorIndex inVectorAt: tempIndex
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitStoreTemp: tmp [

   	gen storeTemp: (self currentScope indexForVarNamed: tmp name)
]

{ #category : 'visiting' }
IRTranslatorVisitor >> visitTempVector: tempVector [

	tempVectorStack push: tempVector.
	gen pushNewArray: tempVector vars size.
	gen storePopTemp: (self currentScope indexForVarNamed: tempVector name)
]
