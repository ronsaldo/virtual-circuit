Class {
	#name : #BeaconCPUInstructionTemplateMemoryLoad,
	#superclass : #BeaconCPUInstructionTemplateALU,
	#category : #'BeaconCPU-Core-ISA'
}

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplateMemoryLoad class >> instructionTemplateName [
	^ #memoryLoad
]
