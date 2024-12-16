"
I represent access to the following variables:

- Global variables
- Shared pools
- Shared variables
"
Class {
	#name : 'IRLiteralVariableAccess',
	#superclass : 'IRAccess',
	#instVars : [
		'association'
	],
	#category : 'OpalCompiler-Core-IR-Nodes',
	#package : 'OpalCompiler-Core',
	#tag : 'IR-Nodes'
}

{ #category : 'accessing' }
IRLiteralVariableAccess >> association [
	^association
]

{ #category : 'accessing' }
IRLiteralVariableAccess >> association: anAssociation [
	association := anAssociation
]

{ #category : 'testing' }
IRLiteralVariableAccess >> isLiteralVariable [
	^true
]

{ #category : 'accessing' }
IRLiteralVariableAccess >> name [
	^association key
]
