Class {
	#name : #BeaconCPUInstructionTemplateLowControl,
	#superclass : #BeaconCPUInstructionTemplate,
	#category : #'BeaconCPU-Core-ISA'
}

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplateLowControl class >> instructionTemplateName [
	^ #control
]

{ #category : #writing }
BeaconCPUInstructionTemplateLowControl >> writeInstruction: instruction with: writer [
	writer nextPutC32: opcode.
]
