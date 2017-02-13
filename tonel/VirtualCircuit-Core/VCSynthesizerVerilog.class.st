Class {
	#name : #VCSynthesizerVerilog,
	#superclass : #VCSynthesizer,
	#category : #'VirtualCircuit-Core-Synthesis'
}

{ #category : #'as yet unclassified' }
VCSynthesizerVerilog >> componentSynthesizerClass [
	^ VCVerilogComponentSynthesizer
]

{ #category : #'as yet unclassified' }
VCSynthesizerVerilog >> sanitizeNameForSymbol: name [
	^ ((name copyReplaceAll: ': ' with: '_')
	   copyReplaceAll: ':' with: '_')
		copyReplaceAll: ' ' with: '_'
]
