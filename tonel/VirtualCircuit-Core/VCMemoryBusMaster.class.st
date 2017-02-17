Class {
	#name : #VCMemoryBusMaster,
	#superclass : #Object,
	#instVars : [
		'builder'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
VCMemoryBusMaster class >> interfaceName [
	self subclassResponsibility
]

{ #category : #accessing }
VCMemoryBusMaster >> builder [
	^ builder
]

{ #category : #accessing }
VCMemoryBusMaster >> builder: anObject [
	builder := anObject.
	self createInterface
]

{ #category : #enumerating }
VCMemoryBusMaster >> read: address into: register whenFinishedDo: readFinishedActions [
	self subclassResponsibility
]
