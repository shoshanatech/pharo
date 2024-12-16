"
I interpret IRMethod instructions and write them out to a print stream.
I'm basically used to produce a precise printOn: of IRMethods.
"
Class {
	#name : 'IRPrinterVisitor',
	#superclass : 'IRVisitor',
	#instVars : [
		'stream'
	],
	#category : 'OpalCompiler-Core-IR-Manipulation',
	#package : 'OpalCompiler-Core',
	#tag : 'IR-Manipulation'
}

{ #category : 'private' }
IRPrinterVisitor >> label: seqNum [

	"add tab and cr since this does not get called within interpretInstruction:"
	stream cr.  "extra cr just to space out sequences"
	stream nextPutAll: 'label: '.
	seqNum printOn: stream.
	stream cr
]

{ #category : 'private' }
IRPrinterVisitor >> stream: stringWriteStream [

	stream := stringWriteStream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitBlockReturnTop: blockReturnTop [

	stream nextPutAll: 'blockReturnTop'
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitInstruction: aNode [
	self visitNode: aNode.
	stream cr
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitJump: jump [

	stream nextPutAll: 'goto: '.
	jump destination orderNumber printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitJumpIf: jumpIf [

	stream nextPutAll: 'if: '.
	jumpIf boolean printOn: stream.
	stream nextPutAll: ' goto: '.
	jumpIf destination orderNumber printOn: stream.
	stream nextPutAll: ' else: '.
	jumpIf otherwise orderNumber printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPop: pop [

	stream nextPutAll: 'popTop'
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPopIntoInstVar: instVar [

	stream nextPutAll: 'popIntoInstVar: '.
	instVar index printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPopIntoLiteralVariable: litVar [

	| object |
	object := litVar association.
	stream nextPutAll: 'popIntoLiteralVariable: '.
	object isVariableBinding ifTrue: [^ stream nextPutAll: object key].
	object printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPopIntoRemoteTemp: remoteTemp [

	stream nextPutAll: 'popIntoRemoteTemp: '.
	remoteTemp name printOn: stream.
	stream nextPutAll: ' inVector: '.
	remoteTemp tempVectorName printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPopIntoTemp: tmp [

	stream nextPutAll: 'popIntoTemp: '.
	tmp name printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushArray: array [

	array cons
		ifTrue: [
			stream nextPutAll: 'pushConsArray: ' ]
		ifFalse: [
			stream nextPutAll: 'pushNewArray: ' ].
	array size printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushDup: dup [

	stream nextPutAll: 'pushDup'
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushFullClosure: fullBlock [

	stream nextPutAll: 'pushFullBlock: '.
	stream nextPutAll: fullBlock compiledBlock printString.
	stream nextPutAll: ' numCopied: '.
	stream nextPutAll: fullBlock copiedValues size printString
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushInstVar: instVar [

	stream nextPutAll: 'pushInstVar: '.
	instVar index printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushLiteral: lit [

	| object |
	object := lit literal.
	stream nextPutAll: 'pushLiteral: '.
	object isVariableBinding ifTrue: [^ stream nextPutAll: object key].
	object printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushLiteralVariable: var [

	| object |
	object := var association.
	stream nextPutAll: 'pushLiteralVariable: '.
	object isVariableBinding ifTrue: [^ stream nextPutAll: object key].
	object printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushReceiver: receiver [

	stream nextPutAll: 'pushReceiver'
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushRemoteTemp: remoteTemp [

	stream nextPutAll: 'pushRemoteTemp: '.
	remoteTemp name printOn: stream.
	stream nextPutAll: ' inVector: '.
	remoteTemp tempVectorName printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushTemp: tmp [

	stream nextPutAll: 'pushTemp: '.
	tmp name printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushThisContext: ctxt [

	stream nextPutAll: 'pushThisContext'
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitPushThisProcess: pushThisProcess [

	stream nextPutAll: 'pushThisProcess'
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitReturn: ret [

	stream nextPutAll: 'returnTop'
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitReturnInstVar: instVar [
	stream nextPutAll: 'returnInstVar: '.
   instVar index printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitReturnLiteral: lit [

	| object |
	object := lit literal.
	stream nextPutAll: 'returnLiteral: '.
	object isVariableBinding ifTrue: [^ stream nextPutAll: object key].
	object printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitReturnReceiver: receiver [

	stream nextPutAll: 'returnReceiver'
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitSend: send [

	send superOf
		ifNil: [ stream nextPutAll: 'send: '.
			send selector printOn: stream. ]
		ifNotNil: [ :behavior | stream nextPutAll: 'send: '.
			send selector printOn: stream.
			stream nextPutAll: ' toSuperOf: '.
			behavior printOn: stream ]
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitSequence: instructionSequence [
	self label: instructionSequence orderNumber.
	super visitSequence: instructionSequence
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitStoreInstVar: instVar [
	stream nextPutAll: 'storeInstVar: '.
   instVar index printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitStoreLiteralVariable: var [

	| object |
	object := var association.
	stream nextPutAll: 'storeLiteralVariable: '.
	object isVariableBinding ifTrue: [^ stream nextPutAll: object key].
	object printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitStoreRemoteTemp: remoteTemp [
	stream nextPutAll: 'storeRemoteTemp: '.
	remoteTemp name printOn: stream.
	stream nextPutAll: ' inVector: '.
	remoteTemp tempVectorName printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitStoreTemp: tmp [

   	stream nextPutAll: 'storeTemp: '.
	tmp name printOn: stream
]

{ #category : 'visiting' }
IRPrinterVisitor >> visitTempVector: tempVector [

	stream nextPutAll: 'createTempVectorNamed: '.
	tempVector name printOn: stream.
	stream nextPutAll: ' withVars: '.
	stream nextPutAll: tempVector vars printString
]
