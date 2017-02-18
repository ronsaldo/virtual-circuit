Class {
	#name : #VCRegister,
	#superclass : #VCVariable,
	#instVars : [
		'clock',
		'reset',
		'resetValue'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCRegister >> accept: aVisitor [
	^ aVisitor visitRegister: self
]

{ #category : #accessing }
VCRegister >> clock [
	^ clock
]

{ #category : #accessing }
VCRegister >> clock: anObject [
	clock := anObject
]

{ #category : #testing }
VCRegister >> hasReset [
	^ true
]

{ #category : #initialization }
VCRegister >> initialize [
	"Registers by default tend to keep their values."
	self value: self
]

{ #category : #testing }
VCRegister >> isRegister [
	^ true
]

{ #category : #'as yet unclassified' }
VCRegister >> localPrefix [
	^ '_register'
]

{ #category : #testing }
VCRegister >> needsClock [
	^ true
]

{ #category : #accessing }
VCRegister >> reset [
	^ reset
]

{ #category : #accessing }
VCRegister >> reset: anObject [
	reset := anObject
]

{ #category : #accessing }
VCRegister >> resetValue [
	^ resetValue
]

{ #category : #accessing }
VCRegister >> resetValue: aValue [
	resetValue := self adaptElement: aValue
]

{ #category : #initialization }
VCRegister >> setDefaultValue [
	self value: self
]
