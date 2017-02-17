Class {
	#name : #BeaconCPUInstructionTemplateALU,
	#superclass : #BeaconCPUInstructionTemplate,
	#category : #'BeaconCPU-Core-ISA'
}

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplateALU class >> instructionTemplateName [
	^ #alu
]

{ #category : #writing }
BeaconCPUInstructionTemplateALU >> writeInstruction: instruction with: writer [
	| operands encodedInstruction dest left right |
	operands := instruction arguments. 
	dest := operands first.
	left := operands second.
	right := operands third.
	self assert: dest isRegister.
	self assert: left isRegister.
	right isImmediate ifTrue: [ 
		encodedInstruction := opcode | (dest value << 8) | "13 NoCC" (left value << 14) | (1 << 19) | ((right value & ((1<<12) - 1)) << 20) .

	] ifFalse: [
		encodedInstruction := opcode | (dest value << 8) | "13 NoCC" (left value << 14) | (0 << 19) | (right value << 20).
	].

	
	writer nextPutC32: encodedInstruction.
]
