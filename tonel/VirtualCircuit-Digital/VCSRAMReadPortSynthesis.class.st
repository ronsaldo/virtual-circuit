Class {
	#name : #VCSRAMReadPortSynthesis,
	#superclass : #VCSRAMPortSynthesis,
	#instVars : [
		'name',
		'address'
	],
	#category : #'VirtualCircuit-Digital-Synthesis'
}

{ #category : #accessing }
VCSRAMReadPortSynthesis >> address [
	^ address
]

{ #category : #accessing }
VCSRAMReadPortSynthesis >> address: anObject [
	address := anObject
]

{ #category : #'as yet unclassified' }
VCSRAMReadPortSynthesis >> emitClockedImplementationWith: synthesizer for: ramModule into: out [
	^ synthesizer emitRAMReadPort: self clockedImplementationFor: ramModule into: out
]

{ #category : #'as yet unclassified' }
VCSRAMReadPortSynthesis >> emitDeclarationWith: synthesizer for: ramModule into: out [
	^ synthesizer emitRAMReadPortDeclaration: self for: ramModule into: out
]

{ #category : #'as yet unclassified' }
VCSRAMReadPortSynthesis >> emitUnclockedImplementationWith: synthesizer for: ramModule into: out [
	^ synthesizer emitRAMReadPort: self unclockedImplementationFor: ramModule into: out
]

{ #category : #accessing }
VCSRAMReadPortSynthesis >> name [
	^ name
]

{ #category : #accessing }
VCSRAMReadPortSynthesis >> name: anObject [
	name := anObject
]
