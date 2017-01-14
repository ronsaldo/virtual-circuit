Class {
	#name : #VCSynthesizer,
	#superclass : #Object,
	#instVars : [
		'synthesizedElements',
		'generatedSymbols',
		'resultModules'
	],
	#category : #'VirtualCircuit-Core-Synthesis'
}

{ #category : #'as yet unclassified' }
VCSynthesizer class >> synthesize: component [
	^ self new synthesize: component
]

{ #category : #'as yet unclassified' }
VCSynthesizer >> componentSynthesizerClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
VCSynthesizer >> formatFinalResult [
	^ ByteString streamContents: [ :out |
		resultModules do: [ :module |
			out nextPutAll: module content; lf.
		]
	]
]

{ #category : #'as yet unclassified' }
VCSynthesizer >> generateSymbolFor: name [
	| sanitizedNamed |
	sanitizedNamed := self sanitizeNameForSymbol: name.
	(generatedSymbols includes: sanitizedNamed) ifTrue: [
		self halt.
	].

	generatedSymbols add: sanitizedNamed.
	^ sanitizedNamed
]

{ #category : #initialization }
VCSynthesizer >> initialize [
	super initialize.
	synthesizedElements := Dictionary new.
	generatedSymbols := Set new.
	resultModules := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
VCSynthesizer >> sanitizeNameForSymbol: name [
	^ name
]

{ #category : #'as yet unclassified' }
VCSynthesizer >> synthesize: aComponentOrComponentInstance [
	synthesizedElements at: aComponentOrComponentInstance ifPresent: [ :se | ^ se ].
	aComponentOrComponentInstance synthesizeWith: self.
	
	^ self formatFinalResult
]

{ #category : #'as yet unclassified' }
VCSynthesizer >> synthesizeComponent: aComponent [
	| module synthesizer |
	synthesizedElements at: aComponent ifPresent: [ :se | ^ se ].
	module := VCSModule new name: (self generateSymbolFor: aComponent name).
	synthesizedElements at: aComponent put: module.
	
	synthesizer := self componentSynthesizerClass new
		globalSynthesizer: self.
	synthesizer synthesizeComponent: aComponent into: module.
	resultModules add: module.
	^ module
]

{ #category : #'as yet unclassified' }
VCSynthesizer >> synthesizeComponentInstance: aComponentInstance [
	self halt
]
