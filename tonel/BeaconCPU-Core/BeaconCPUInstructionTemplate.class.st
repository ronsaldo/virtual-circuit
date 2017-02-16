Class {
	#name : #BeaconCPUInstructionTemplate,
	#superclass : #SAsmObject,
	#instVars : [
		'name',
		'opcode'
	],
	#category : #'BeaconCPU-Core'
}

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplate class >> instructionTemplateName [
	self subclassResponsibility
]

{ #category : #writing }
BeaconCPUInstructionTemplate >> computeMaximalSizeFor: instruction [
	^ 4
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
