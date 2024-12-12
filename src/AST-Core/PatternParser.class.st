"
RBPatternParser is a subclass of RBParser that allows the extended syntax that creates matching trees. These trees can be used by the ParseTreeMatcher to search and transform source code.

"
Class {
	#name : 'PatternParser',
	#superclass : 'Parser',
	#category : 'AST-Core-Parser',
	#package : 'AST-Core',
	#tag : 'Parser'
}

{ #category : 'private - classes' }
PatternParser >> messageNodeClass [
	^ASTPatternMessageNode
]

{ #category : 'private - classes' }
PatternParser >> methodNodeClass [
	^ASTPatternMethodNode
]

{ #category : 'private - parsing' }
PatternParser >> parseError: aString [

	self error: aString
]

{ #category : 'private - parsing' }
PatternParser >> parseLiteralByteArrayObject [
	| node |
	(currentToken isIdentifier and: [currentToken isPatternVariable])
		ifTrue:
			[node := self variableNodeClass identifierNamed: currentToken value at: currentToken start.
			node isLiteralNode
				ifTrue:
					[self step.
					^node]].
	^super parseLiteralByteArrayObject
]

{ #category : 'private - parsing' }
PatternParser >> parsePatternBlock: aClass [
	| position node |
	position := currentToken start.
	self step.
	node := aClass new.
	self parseBlockArgsInto: node.
	node left: position.

	node body: self sequenceNodeClass new.
	self
		parseStatements: false
		into: node body
		untilAnyCloserOf: '}'.

	(currentToken isSpecial: $})
		ifFalse: [ self addParserError: '''}'' expected' to: node body.
			^ node ].
	node right: currentToken start.
	self step.
	^node
]

{ #category : 'private - parsing' }
PatternParser >> parsePragmaLiteral [
	| node |
	currentToken isPatternBlock
		ifTrue: [ ^ self parsePatternBlock: ASTPatternBlockNode ].
	(currentToken isIdentifier and: [ currentToken isPatternVariable ]) ifTrue: [
		node := self variableNodeClass identifierNamed: currentToken value at: currentToken start.
		node isLiteralNode
			ifFalse: [ self parseError: 'Literal pattern expected' ].
		self step.
		currentToken isPatternBlock ifTrue: [
			node := (self parsePatternBlock: ASTPatternWrapperBlockNode)
				wrappedNode: node;
				yourself ].
		^ node ].
	^ super parsePragmaLiteral
]

{ #category : 'private - parsing' }
PatternParser >> parsePrimitiveLiteral [
	| node |
	(currentToken isIdentifier and: [currentToken isPatternVariable])
		ifTrue:
			[node := self variableNodeClass identifierNamed: currentToken value at: currentToken start.
			node isLiteralNode
				ifTrue:
					[self step.
					^node].
			currentToken := ASTLiteralToken
						value: currentToken value asSymbol
						start: currentToken start
						stop: currentToken stop].
	^super parsePrimitiveLiteral
]

{ #category : 'private - parsing' }
PatternParser >> parsePrimitiveObject [
	currentToken isPatternBlock
		ifTrue: [^self parsePatternBlock: ASTPatternBlockNode].
	^super parsePrimitiveObject
]

{ #category : 'private - parsing' }
PatternParser >> parseUnaryMessage [
	| node |
	node := self parsePrimitiveObject.
	self addCommentsTo: node.

	[currentToken isLiteralToken ifTrue: [self patchLiteralMessage].
	currentToken isPatternBlock
		ifTrue:
			[node := self parseWrapperPatternBlockWith: node ].
	currentToken isIdentifier]
			whileTrue: [
				currentToken isKeywordPattern
					ifTrue: [ self parseErrorNode: ' incomplete keyword pattern ' ].
				node := self parseUnaryMessageWith: node].
	self addCommentsTo: node.
	^node
]

{ #category : 'private - parsing' }
PatternParser >> parseWrapperPatternBlockWith: wrappedNode [
	| node |

	node := self parsePatternBlock: ASTPatternWrapperBlockNode.
	node class == ASTPatternWrapperBlockNode ifTrue: [
		self flag: 'I think this is ugly, but I don''t know how to avoid checking the result of #parsePatternBlock:'.
		node wrappedNode: wrappedNode ].

	^ node
]

{ #category : 'private - classes' }
PatternParser >> pragmaNodeClass [
	^ASTPatternPragmaNode
]

{ #category : 'accessing' }
PatternParser >> scannerClass [
	^RBPatternScanner
]

{ #category : 'private - classes' }
PatternParser >> variableNodeClass [
	^ASTPatternVariableNode
]
