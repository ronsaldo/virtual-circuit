Class {
	#name : #VCMemoryBusMaster,
	#superclass : #VCBus,
	#category : #'VirtualCircuit-Core-Bus'
}

{ #category : #'as yet unclassified' }
VCMemoryBusMaster class >> interfaceName [
	self subclassResponsibility
]

{ #category : #enumerating }
VCMemoryBusMaster >> read: address into: register whenFinishedDo: readFinishedActions [
	self subclassResponsibility
]
