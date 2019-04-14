Class {
	#name : #VCMemoryBusSlave,
	#superclass : #VCBus,
	#category : #'VirtualCircuit-Digital-Bus'
}

{ #category : #converting }
VCMemoryBusSlave class >> asVCMemoryBusSlaveInterface [
	^ self new
]

{ #category : #'as yet unclassified' }
VCMemoryBusSlave class >> interfaceName [
	self subclassResponsibility
]

{ #category : #converting }
VCMemoryBusSlave >> asVCMemoryBusSlaveInterface [
	^ self
]
