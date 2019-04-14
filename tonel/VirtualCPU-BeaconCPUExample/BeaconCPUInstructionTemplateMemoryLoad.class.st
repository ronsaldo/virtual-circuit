Class {
	#name : #BeaconCPUInstructionTemplateMemoryLoad,
	#superclass : #BeaconCPUInstructionTemplateALU,
	#category : #'VirtualCPU-BeaconCPUExample-ISA'
}

{ #category : #'as yet unclassified' }
BeaconCPUInstructionTemplateMemoryLoad class >> instructionTemplateName [
	^ #memoryLoad
]
