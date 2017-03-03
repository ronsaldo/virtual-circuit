Class {
	#name : #BeaconCPUInstructionTemplateSpecialRegister,
	#superclass : #BeaconCPUInstructionTemplate,
	#category : #'BeaconCPU-Core-ISA'
}

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplateSpecialRegister class >> instructionTemplateName [
	^ #specialRegister
]

{ #category : #writing }
BeaconCPUInstructionTemplateSpecialRegister >> writeInstruction: instruction with: writer [
	| operands encodedInstruction  normalRegister specialRegister |
	operands := instruction arguments. 
	normalRegister := operands first.
	specialRegister := operands second.
	encodedInstruction := opcode | (normalRegister value << 8) | (specialRegister value << 13).
		
	writer nextPutC32: encodedInstruction.
]
