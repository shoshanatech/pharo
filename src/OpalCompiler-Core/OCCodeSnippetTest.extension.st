Extension { #name : 'OCCodeSnippetTest' }

{ #category : '*OpalCompiler-Core' }
OCCodeSnippetTest >> compileSnippet: anOCCodeSnippet [ 

	^ [ OpalCompiler new
		  permitFaulty: true;
		  isScripting: anOCCodeSnippet isScripting;
		  compile: anOCCodeSnippet source ]
	on: OCCodeError do: [ :e |
		"Compilation should success, because its the *faulty* mode".
		"If this is expected, then just return nil"
		anOCCodeSnippet ifSkip: #compile then: [^ nil ].
		"Otherwise, pass the error"
		e pass ]
]
