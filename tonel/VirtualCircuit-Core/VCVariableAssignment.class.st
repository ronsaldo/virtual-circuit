Class {
	#name : #VCVariableAssignment,
	#superclass : #VCSequentialAction,
	#instVars : [
		'variable',
		'value'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #accessing }
VCVariableAssignment >> on: condition applyInComponent: component [
	variable value ifNil: [ variable setDefaultValue ].
	variable value: (condition ifTrue: value ifFalse: variable value)
]

{ #category : #accessing }
VCVariableAssignment >> value [
	^ value
]

{ #category : #accessing }
VCVariableAssignment >> value: anObject [
	value := anObject
]

{ #category : #accessing }
VCVariableAssignment >> variable [
	^ variable
]

{ #category : #accessing }
VCVariableAssignment >> variable: anObject [
	variable := anObject
]
