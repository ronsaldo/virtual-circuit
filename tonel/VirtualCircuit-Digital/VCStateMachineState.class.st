Class {
	#name : #VCStateMachineState,
	#superclass : #Object,
	#instVars : [
		'name',
		'value',
		'condition',
		'component'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #accessing }
VCStateMachineState >> component [
	^ component
]

{ #category : #accessing }
VCStateMachineState >> component: anObject [
	component := anObject
]

{ #category : #accessing }
VCStateMachineState >> condition [
	^ condition
]

{ #category : #accessing }
VCStateMachineState >> condition: anObject [
	condition := anObject
]

{ #category : #enumerating }
VCStateMachineState >> do: newAction [
	newAction asVCSequentialAction on: condition applyInComponent: component
]

{ #category : #enumerating }
VCStateMachineState >> initialize [
	actions := #()
]

{ #category : #accessing }
VCStateMachineState >> name [
	^ name
]

{ #category : #accessing }
VCStateMachineState >> name: anObject [
	name := anObject
]

{ #category : #accessing }
VCStateMachineState >> value [
	^ value
]

{ #category : #accessing }
VCStateMachineState >> value: anObject [
	value := anObject
]
