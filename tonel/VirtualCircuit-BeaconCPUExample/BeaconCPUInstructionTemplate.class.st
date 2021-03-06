Class {
	#name : #BeaconCPUInstructionTemplate,
	#superclass : #SAsmObject,
	#instVars : [
		'name',
		'opcode'
	],
	#category : #'VirtualCircuit-BeaconCPUExample-ISA'
}

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplate class >> instructionTemplateName [
	self subclassResponsibility
]

{ #category : #writing }
BeaconCPUInstructionTemplate >> computeMaximalSizeFor: instruction [
	^ 4
]

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplate >> computeSizeForInstruction: instruction with: aWriter [
	^ 4
]

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplate >> findBestLongAlternativeFor: instruction [
	^ self
]

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplate >> findBestShortAlternativeFor: instruction [
	^ self
]

{ #category : #accessing }
BeaconCPUInstructionTemplate >> instructionTemplateName [
	^ self class instructionTemplateName
]

{ #category : #accessing }
BeaconCPUInstructionTemplate >> name [
	^ name
]

{ #category : #accessing }
BeaconCPUInstructionTemplate >> name: anObject [
	name := anObject
]

{ #category : #accessing }
BeaconCPUInstructionTemplate >> opcode [
	^ opcode
]

{ #category : #accessing }
BeaconCPUInstructionTemplate >> opcode: anObject [
	opcode := anObject
]

{ #category : #writing }
BeaconCPUInstructionTemplate >> writeInstruction: instruction with: writer [
	self subclassResponsibility
]
