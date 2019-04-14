Class {
	#name : #VCSynthesizerVerilog,
	#superclass : #VCSynthesizer,
	#classVars : [
		'ForbiddenSymbolCharacters'
	],
	#category : #'VirtualCircuit-Digital-Synthesis'
}

{ #category : #initialization }
VCSynthesizerVerilog class >> initialize [
	super initialize.
	
	ForbiddenSymbolCharacters := #($: $_ $ $# )
]

{ #category : #'as yet unclassified' }
VCSynthesizerVerilog >> componentSynthesizerClass [
	^ VCVerilogComponentSynthesizer
]

{ #category : #'as yet unclassified' }
VCSynthesizerVerilog >> sanitizeNameForSymbol: name [
	^ name collect: [:char | (ForbiddenSymbolCharacters includes: char) ifTrue: [ $_ ] ifFalse: [ char ] ]
]
