"
I model the pushRemoteTemporary bytecode. In particular for temporary that outlives their existing context
and are stored into so called tempVector.
"
Class {
	#name : 'IRRemoteTempAccess',
	#superclass : 'IRTempAccess',
	#instVars : [
		'tempVectorName'
	],
	#category : 'OpalCompiler-Core-IR-Nodes',
	#package : 'OpalCompiler-Core',
	#tag : 'IR-Nodes'
}

{ #category : 'testing' }
IRRemoteTempAccess >> isRemoteTemp [
	^ true
]

{ #category : 'accessing' }
IRRemoteTempAccess >> tempVectorName [
	^ tempVectorName
]

{ #category : 'accessing' }
IRRemoteTempAccess >> tempVectorName: anObject [
	tempVectorName := anObject
]
