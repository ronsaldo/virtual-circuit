Class {
	#name : #VCAVoltageSource,
	#superclass : #VCAComponent,
	#instVars : [
		'value',
		'positive',
		'negative',
		'variableIndex'
	],
	#category : #'VirtualCircuit-Analog'
}

{ #category : #adding }
VCAVoltageSource >> addToWires [
	positive addEdge: self.
	negative addEdge: self.
]

{ #category : #testing }
VCAVoltageSource >> isVoltageSource [
	^ true
]

{ #category : #accessing }
VCAVoltageSource >> negative [
	^ negative
]

{ #category : #accessing }
VCAVoltageSource >> negative: anObject [
	negative := anObject
]

{ #category : #accessing }
VCAVoltageSource >> positive [
	^ positive
]

{ #category : #accessing }
VCAVoltageSource >> positive: anObject [
	positive := anObject
]

{ #category : #accessing }
VCAVoltageSource >> value [
	^ value
]

{ #category : #accessing }
VCAVoltageSource >> value: anObject [
	value := anObject
]

{ #category : #accessing }
VCAVoltageSource >> variableIndex [
	^ variableIndex
]

{ #category : #accessing }
VCAVoltageSource >> variableIndex: anObject [
	variableIndex := anObject
]
