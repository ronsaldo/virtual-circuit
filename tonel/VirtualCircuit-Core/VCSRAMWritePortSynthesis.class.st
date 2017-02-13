Class {
	#name : #VCSRAMWritePortSynthesis,
	#superclass : #VCSRAMPortSynthesis,
	#instVars : [
		'address',
		'enabled',
		'value'
	],
	#category : #'VirtualCircuit-Core-Synthesis'
}

{ #category : #accessing }
VCSRAMWritePortSynthesis >> address [
	^ address
]

{ #category : #accessing }
VCSRAMWritePortSynthesis >> address: anObject [
	address := anObject
]

{ #category : #'as yet unclassified' }
VCSRAMWritePortSynthesis >> emitClockedImplementationWith: synthesizer for: ramModule into: out [
	^ synthesizer emitRAMWritePort: self clockedImplementationFor: ramModule into: out
]

{ #category : #'as yet unclassified' }
VCSRAMWritePortSynthesis >> emitDeclarationWith: synthesizer for: ramModule into: out [
	^ synthesizer emitRAMWritePortDeclaration: self for: ramModule into: out
]

{ #category : #'as yet unclassified' }
VCSRAMWritePortSynthesis >> emitUnclockedImplementationWith: synthesizer for: ramModule into: out [
	^ synthesizer emitRAMWritePort: self unclockedImplementationFor: ramModule into: out
]

{ #category : #accessing }
VCSRAMWritePortSynthesis >> enabled [
	^ enabled
]

{ #category : #accessing }
VCSRAMWritePortSynthesis >> enabled: anObject [
	enabled := anObject
]

{ #category : #accessing }
VCSRAMWritePortSynthesis >> value [
	^ value
]

{ #category : #accessing }
VCSRAMWritePortSynthesis >> value: anObject [
	value := anObject
]
