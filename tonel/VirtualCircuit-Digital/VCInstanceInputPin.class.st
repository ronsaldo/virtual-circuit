Class {
	#name : #VCInstanceInputPin,
	#superclass : #VCInputPin,
	#instVars : [
		'instance'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #'as yet unclassified' }
VCInstanceInputPin >> accept: aVisitor [
	^ aVisitor visitInstanceInputPin: self
]

{ #category : #'as yet unclassified' }
VCInstanceInputPin >> connectWith: anotherPin [ 
	anotherPin connectWithSinkPin: self
]

{ #category : #accessing }
VCInstanceInputPin >> instance [
	^ instance
]

{ #category : #accessing }
VCInstanceInputPin >> instance: anObject [
	instance := anObject
]

{ #category : #'register value' }
VCInstanceInputPin >> register [
	^ value ifNil: [ value := owner addElement: (VCRegister new
			bits: self bits;
			yourself) ]
]
