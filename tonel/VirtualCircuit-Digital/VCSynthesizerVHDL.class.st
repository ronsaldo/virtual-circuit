Class {
	#name : #VCSynthesizerVHDL,
	#superclass : #VCSynthesizer,
	#classVars : [
		'ForbiddenSymbolCharacters'
	],
	#category : #'VirtualCircuit-Digital-Synthesis'
}

{ #category : #'class initialization' }
VCSynthesizerVHDL class >> initialize [
	super initialize.
	
	ForbiddenSymbolCharacters := #($: $_ $ $# )
]

{ #category : #'as yet unclassified' }
VCSynthesizerVHDL >> componentSynthesizerClass [
	^ VCVHDLComponentSynthesizer
]

{ #category : #'as yet unclassified' }
VCSynthesizerVHDL >> sanitizeNameForSymbol: name [
	^ name collect: [:char | (ForbiddenSymbolCharacters includes: char) ifTrue: [ $_ ] ifFalse: [ char ] ]
]
