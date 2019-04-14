Class {
	#name : #VCBusPortDescription,
	#superclass : #Object,
	#instVars : [
		'variableName',
		'portName',
		'direction',
		'bits',
		'options'
	],
	#category : #'VirtualCircuit-Digital-Bus'
}

{ #category : #accessing }
VCBusPortDescription >> bits [
	^ bits
]

{ #category : #accessing }
VCBusPortDescription >> bits: anObject [
	bits := anObject
]

{ #category : #accessing }
VCBusPortDescription >> direction [
	^ direction
]

{ #category : #accessing }
VCBusPortDescription >> direction: anObject [
	direction := anObject
]

{ #category : #accessing }
VCBusPortDescription >> options [
	^ options
]

{ #category : #accessing }
VCBusPortDescription >> options: anObject [
	options := anObject
]

{ #category : #accessing }
VCBusPortDescription >> portName [
	^ portName
]

{ #category : #accessing }
VCBusPortDescription >> portName: anObject [
	portName := anObject
]

{ #category : #accessing }
VCBusPortDescription >> variableName [
	^ variableName
]

{ #category : #accessing }
VCBusPortDescription >> variableName: anObject [
	variableName := anObject
]
