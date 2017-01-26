Class {
	#name : #VCConstant,
	#superclass : #VCExpression,
	#instVars : [
		'value'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCConstant >> accept: aVisitor [
	^ aVisitor visitConstant: self
]

{ #category : #accessing }
VCConstant >> value [
	^ value
]

{ #category : #accessing }
VCConstant >> value: anObject [
	value := anObject
]
