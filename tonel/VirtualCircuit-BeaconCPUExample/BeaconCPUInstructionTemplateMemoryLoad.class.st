Class {
	#name : #BeaconCPUInstructionTemplateMemoryLoad,
	#superclass : #BeaconCPUInstructionTemplateALU,
	#category : #'VirtualCircuit-BeaconCPUExample-ISA'
}

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplateMemoryLoad class >> instructionTemplateName [
	^ #memoryLoad
]
