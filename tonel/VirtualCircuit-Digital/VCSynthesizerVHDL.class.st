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
VCSynthesizerVHDL >> formatFinalResult [
	^ ByteString streamContents: [ :out |
		out
			nextPutAll: 'library IEEE;'; lf;
			nextPutAll: 'use IEEE.std_logic_1164.all;'; lf;
			nextPutAll: 'use IEEE.numeric_std.all;'; lf;
			lf.
		resultModules do: [ :module |
			out nextPutAll: module content; lf.
		]
	]
]

{ #category : #'as yet unclassified' }
VCSynthesizerVHDL >> sanitizeNameForSymbol: name [
	^ name collect: [:char | (ForbiddenSymbolCharacters includes: char) ifTrue: [ $_ ] ifFalse: [ char ] ]
]
