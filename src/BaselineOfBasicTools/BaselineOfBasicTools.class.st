"
This baseline is used to generate Pharo images from the local clone of pharo-project/pharo repository. 

Depends on:
- BaselineOfUI

Load type: 
- atomic

Installs:
- SUnit UI
- Nautilus
- NECompletion
- ProcessBrowsers
- profillers
- different Metacello repositories
- Monticello GUI
- ProfStef
- Athens
..and some other packages
"
Class {
	#name : 'BaselineOfBasicTools',
	#superclass : 'BaselineOf',
	#classVars : [
		'Initialized'
	],
	#category : 'BaselineOfBasicTools',
	#package : 'BaselineOfBasicTools'
}

{ #category : 'baselines' }
BaselineOfBasicTools >> baseline: spec [

	<baseline>
	| repository |
	repository := self packageRepositoryURLForSpec: spec.
	spec for: #common do: [
		spec postLoadDoIt: #postload:package:.

		"Load first SUnit core"
		spec baseline: 'SUnitCore' with: [
			spec
				loads: 'Core';
				className: 'BaselineOfSUnit';
				repository: repository ].
		spec
			baseline: 'UI' with: [ spec repository: repository ];
			baseline: 'Reflectivity' with: [ spec repository: repository ];
			baseline: 'DebugPoints' with: [ spec repository: repository ];
			baseline: 'Athens' with: [
				spec
					loads: 'Cairo-core';
					repository: repository ];
			baseline: 'SUnit' with: [
			spec
				loads: #( 'UI' 'JenkinsSupport' );
				repository: repository ].
		spec package: 'Tool-ExternalBrowser'.
		spec baseline: 'EnlumineurFormatter' with: [
			spec
				loads: 'Core';
				repository: repository ].

		spec package: 'Tool-ProcessBrowser'.
		spec package: 'Tool-Profilers'.
		spec package: 'NECompletion'.
		spec package: 'NECompletion-Morphic'.
		spec package: 'NECompletion-Preferences'.
		spec package: 'Metacello-FileTree'.
		spec package: 'Metacello-Cypress'.
		spec package: 'CodeExport'.
		spec package: 'MonticelloGUI' with: [ spec requires: #( 'Tool-Diff' ) ].
		spec package: 'System-Sources-Tests'. "<= Not sure this one should be here but it is where the classes were loaded before been extracted from Tests package."

		spec package: 'Kernel-CodeModel-Tests'.
		spec package: 'Monticello-Tests'.
		spec package: 'MonticelloGUI-Tests'.
		spec package: 'Network-Mail'.
		spec package: 'Network-Mail-Tests'.
		spec package: 'ProfStef-Core'.
		spec package: 'StartupPreferences'.

		spec baseline: 'Refactoring' with: [
			spec
				repository: repository;
				loads: #( 'Core' ) ].

		spec package: 'Monticello-BackwardCompatibility'.
		spec package: 'MonticelloFileServices'.

		self specRefactoring: spec.

		spec package: 'Tools-CodeNavigation'.
		spec package: 'Tool-Diff'.
		spec package: 'Tool-ImageCleaner'.
		spec package: 'Tools' ]
]

{ #category : 'actions' }
BaselineOfBasicTools >> postload: loader package: packageSpec [

	"Ignore pre and post loads if already executed"
	Initialized = true ifTrue: [ ^ self ].

	"This should be removed in Pharo 14."
	OCNode deprecatedAliases:"" { #RBNode }.
	OCProgramNode deprecatedAliases: { #RBProgramNode }.
	OCValueNode deprecatedAliases: { #RBValueNode }.
	OCLiteralNode deprecatedAliases: { #RBLiteralNode }.
	OCLiteralArrayNode deprecatedAliases: { #RBLiteralArrayNode }.
	OCLiteralValueNode deprecatedAliases: { #RBLiteralValueNode }.
	OCArrayNode deprecatedAliases: { #RBArrayNode }.
	"OCAssignmentNode deprecatedAliases: { #RBAssignmentNode }."
	OCCascadeNode deprecatedAliases: { #RBCascadeNode }.
	"OCReturnNode deprecatedAliases: { #RBReturnNode }."
	OCVariableNode deprecatedAliases: { #RBVariableNode }.
	OCCommentNode deprecatedAliases: { #RBComment }.
	"OCBlockNode deprecatedAliases: { #RBBlockNode }.
	OCMessageNode deprecatedAliases: { #RBMessageNode }."
	OCSelectorNode deprecatedAliases: { #RBSelectorNode }.
	OCPragmaNode deprecatedAliases: { #RBPragmaNode }.
	OCSequenceNode deprecatedAliases: { #RBSequenceNode }.
	OCAnnotationMarkNode deprecatedAliases: { #RBAnnotationMarkNode }.
	"OCMethodNode deprecatedAliases: { #RBMethodNode }."
	OCDoItMethodNode deprecatedAliases: { #RBDoItMethodNode }.
	OCEnglobingErrorNode deprecatedAliases: { #RBEnglobingErrorNode }.
	OCArrayErrorNode deprecatedAliases: { #RBArrayErrorNode }.
	OCUnfinishedStatementErrorNode deprecatedAliases: { #RBUnfinishedStatementErrorNode }.
	OCLiteralByteArrayErrorNode deprecatedAliases: { #RBLiteralByteArrayErrorNode }.
	OCPragmaErrorNode deprecatedAliases: { #RBPragmaErrorNode }.
	OCLiteralArrayErrorNode deprecatedAliases: { #RBLiteralArrayErrorNode }.
	OCParenthesesErrorNode deprecatedAliases: { #RBParenthesesErrorNode }.
	OCAssignmentErrorNode deprecatedAliases: { #RBAssignmentErrorNode }.
	OCBlockErrorNode deprecatedAliases: { #RBBlockErrorNode }.
	OCTemporariesErrorNode deprecatedAliases: { #RBTemporariesErrorNode }.
	OCInvalidCascadeErrorNode deprecatedAliases: { #RBInvalidCascadeErrorNode }.
	OCParseErrorNode deprecatedAliases: { #RBParseErrorNode }.
	
	OCAbstractFormatter deprecatedAliases: { #RBAbstractFormatter }.
	OCSimpleFormatter deprecatedAliases: { #RBSimpleFormatter }.
	
	OCParseTreeSearcher deprecatedAliases: { #RBParseTreeSearcher }.
	OCParseTreeRule deprecatedAliases: { #RBParseTreeRule }.
	OCReplaceRule deprecatedAliases: { #RBReplaceRule }.
	OCSearchRule deprecatedAliases: { #RBSearchRule }.
	OCBlockReplaceRule deprecatedAliases: { #RBBlockReplaceRule }.
	OCParseTreeRewriter deprecatedAliases: { #RBParseTreeRewriter }.
	OCStringReplacement deprecatedAliases: { #RBStringReplacement }.
	OCStringReplaceRule deprecatedAliases: { #RBStringReplaceRule }.
	
	OCReadBeforeWrittenTester deprecatedAliases: { #RBReadBeforeWrittenTester }.
	OCProgramNodeVisitor deprecatedAliases: { #RBProgramNodeVisitor }.
	OCReturnNodeAdderVisitor deprecatedAliases: { #RBReturnNodeAdderVisitor }.
	OCParseErrorNodeVisitor deprecatedAliases: { #RBParseErrorNodeVisitor }.
	OCCommentNodeVisitor deprecatedAliases: { #RBCommentNodeVisitor }.
	OCGenericNodeVisitor deprecatedAliases: { #RBGenericNodeVisitor }.
	OCDumpVisitor deprecatedAliases: { #RBDumpVisitor }.
	OCAbstractBlockVisitor deprecatedAliases: { #RBAbstractBlockVisitor }.
	
	OCErrorNotice deprecatedAliases: { #RBErrorNotice }.
	OCWarningNotice deprecatedAliases: { #RBWarningNotice }.
	OCSyntaxErrorNotice deprecatedAliases: { #RBSyntaxErrorNotice }.
	OCNotice deprecatedAliases: { #RBNotice }.
	
	OCCommentToken deprecatedAliases: { #RBCommentToken}.
	OCLiteralToken deprecatedAliases: { #RBLiteralToken}.
	OCSpecialCharacterToken deprecatedAliases: { #RBSpecialCharacterToken}.
	OCIdentifierToken deprecatedAliases: { #RBIdentifierToken}.
	OCNumberLiteralToken deprecatedAliases: { #RBNumberLiteralToken}.
	OCToken deprecatedAliases: { #RBToken}.
	OCBinarySelectorToken deprecatedAliases: { #RBBinarySelectorToken}.
	OCKeywordToken deprecatedAliases: { #RBKeywordToken}.
	OCAssignmentToken deprecatedAliases: { #RBAssignmentToken}.
	OCErrorToken deprecatedAliases: { #RBErrorToken}.
	OCValueToken deprecatedAliases: { #RBValueToken}.
	OCEOFToken deprecatedAliases: { #RBEOFToken}.
	OCLiteralArrayToken deprecatedAliases: { #RBLiteralArrayToken}.
	OCPatternBlockToken deprecatedAliases: { #RBPatternBlockToken}.

	OCPatternMessageNode deprecatedAliases: { #RBPatternMessageNode }.
	OCPatternBlockNode deprecatedAliases: { #RBPatternBlockNode }.
	OCPatternWrapperBlockNode deprecatedAliases: { #RBPatternWrapperBlockNode }.
	OCPatternMethodNode deprecatedAliases: { #RBPatternMethodNode }.
	OCPatternVariableNode deprecatedAliases: { #RBPatternVariableNode }.
	OCPatternPragmaNode deprecatedAliases: { #RBPatternPragmaNode }.
	
	CompletionSorter register.
	RubSmalltalkEditor completionEngineClass: CompletionEngine.

	Initialized := true.
]

{ #category : 'baseline' }
BaselineOfBasicTools >> project [
	
	| aProject |
	
	aProject := super project.
	aProject loadType: #atomic.
	^ aProject.
]

{ #category : 'baseline' }
BaselineOfBasicTools >> specRefactoring: spec [
	
	"Package used to rename #defaultSpec methods to #defaultLayout.
	Should be removed once users of #defaultSpec are migrated."
	
	spec baseline: 'SpecRefactoring' with: [
		spec 
			repository: (self class environment at: #BaselineOfPharo) specRepository;
			className: 'BaselineOfSpec2';
			loads: #('Spec2-Transformations') ]
]
