Class {
	#name : #VCMemoryBusMaster,
	#superclass : #VCBus,
	#category : #'VirtualCircuit-Digital-Bus'
}

{ #category : #converting }
VCMemoryBusMaster class >> asVCMemoryBusMasterInterface [
	^ self new
]

{ #category : #'as yet unclassified' }
VCMemoryBusMaster class >> interfaceName [
	self subclassResponsibility
]

{ #category : #converting }
VCMemoryBusMaster >> asVCMemoryBusMasterInterface [
	^ self
]

{ #category : #enumerating }
VCMemoryBusMaster >> read: address into: register whenFinishedDo: readFinishedActions [
	self subclassResponsibility
]

{ #category : #enumerating }
VCMemoryBusMaster >> write: address value: register strobe: strobe whenFinishedDo: writeFinishedActions [
	self subclassResponsibility
]

{ #category : #enumerating }
VCMemoryBusMaster >> write: address value: register whenFinishedDo: writeFinishedActions [
	self subclassResponsibility
]
