Class {
	#name : #VCConstant,
	#superclass : #VCExpression,
	#instVars : [
		'value'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #initialization }
VCConstant >> initialize [
	"Subclasses should redefine this method to perform initializations on instance creation" 
]

{ #category : #accessing }
VCConstant >> value [
	^ value
]

{ #category : #accessing }
VCConstant >> value: anObject [
	value := anObject
]
