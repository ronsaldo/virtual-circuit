Class {
	#name : #VCSynthRegisterAssignment,
	#superclass : #Object,
	#instVars : [
		'name',
		'bits',
		'value',
		'clock',
		'reset',
		'resetValue',
		'resetActiveLow'
	],
	#category : #'VirtualCircuit-Core-Synthesis'
}

{ #category : #accessing }
VCSynthRegisterAssignment >> bits [
	^ bits
]

{ #category : #accessing }
VCSynthRegisterAssignment >> bits: anObject [
	bits := anObject
]

{ #category : #accessing }
VCSynthRegisterAssignment >> clock [
	^ clock
]

{ #category : #accessing }
VCSynthRegisterAssignment >> clock: anObject [
	clock := anObject
]

{ #category : #accessing }
VCSynthRegisterAssignment >> name [
	^ name
]

{ #category : #accessing }
VCSynthRegisterAssignment >> name: anObject [
	name := anObject
]

{ #category : #accessing }
VCSynthRegisterAssignment >> reset [
	^ reset
]

{ #category : #accessing }
VCSynthRegisterAssignment >> reset: anObject [
	reset := anObject
]

{ #category : #accessing }
VCSynthRegisterAssignment >> resetActiveLow [
	^ resetActiveLow
]

{ #category : #accessing }
VCSynthRegisterAssignment >> resetActiveLow: anObject [
	resetActiveLow := anObject
]

{ #category : #accessing }
VCSynthRegisterAssignment >> resetValue [
	^ resetValue
]

{ #category : #accessing }
VCSynthRegisterAssignment >> resetValue: anObject [
	resetValue := anObject
]

{ #category : #accessing }
VCSynthRegisterAssignment >> value [
	^ value
]

{ #category : #accessing }
VCSynthRegisterAssignment >> value: anObject [
	value := anObject
]
