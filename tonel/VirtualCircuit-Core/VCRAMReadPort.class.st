Class {
	#name : #VCRAMReadPort,
	#superclass : #VCExpression,
	#instVars : [
		'ram',
		'address'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCRAMReadPort >> accept: aVisitor [
	^ aVisitor visitRAMReadPort: self
]

{ #category : #accessing }
VCRAMReadPort >> address [
	^ address
]

{ #category : #accessing }
VCRAMReadPort >> address: anObject [
	address := anObject
]

{ #category : #testing }
VCRAMReadPort >> isReadPort [
	^ true
]

{ #category : #testing }
VCRAMReadPort >> isReadWritePort [
	^ false
]

{ #category : #testing }
VCRAMReadPort >> isWritePort [
	^ false
]

{ #category : #'as yet unclassified' }
VCRAMReadPort >> localPrefix [
	^ '_ram_read_port'
]

{ #category : #accessing }
VCRAMReadPort >> ram [
	^ ram
]

{ #category : #accessing }
VCRAMReadPort >> ram: anObject [
	ram := anObject
]
