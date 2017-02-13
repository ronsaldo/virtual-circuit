Class {
	#name : #VCRAMWritePort,
	#superclass : #VCExpression,
	#instVars : [
		'ram',
		'enabled',
		'address',
		'value'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCRAMWritePort >> accept: aVisitor [
	^ aVisitor visitRAMWritePort: self
]

{ #category : #accessing }
VCRAMWritePort >> address [
	^ address
]

{ #category : #accessing }
VCRAMWritePort >> address: anObject [
	address := anObject
]

{ #category : #accessing }
VCRAMWritePort >> enabled [
	^ enabled
]

{ #category : #accessing }
VCRAMWritePort >> enabled: anObject [
	enabled := anObject
]

{ #category : #visiting }
VCRAMWritePort >> isReadPort [
	^ false
]

{ #category : #visiting }
VCRAMWritePort >> isReadWritePort [
	^ false
]

{ #category : #visiting }
VCRAMWritePort >> isWritePort [
	^ true
]

{ #category : #accessing }
VCRAMWritePort >> ram [
	^ ram
]

{ #category : #accessing }
VCRAMWritePort >> ram: anObject [
	ram := anObject
]

{ #category : #accessing }
VCRAMWritePort >> value [
	^ value
]

{ #category : #accessing }
VCRAMWritePort >> value: anObject [
	value := anObject
]
