Class {
	#name : #VCAComponent,
	#superclass : #Object,
	#instVars : [
		'index'
	],
	#category : #'VirtualCircuit-Analog'
}

{ #category : #adding }
VCAComponent >> addToMatrices: matrices vector: vector [

]

{ #category : #adding }
VCAComponent >> addToWires [
	self subclassResponsibility
]

{ #category : #accessing }
VCAComponent >> index [
	^ index
]

{ #category : #accessing }
VCAComponent >> index: anObject [
	index := anObject
]

{ #category : #testing }
VCAComponent >> isPassive [
	^ false
]

{ #category : #testing }
VCAComponent >> isVoltageSource [
	^ false
]
