Class {
	#name : #VCRAMWritePortAction,
	#superclass : #VCSequentialAction,
	#instVars : [
		'port',
		'address',
		'value'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #accessing }
VCRAMWritePortAction >> address [
	^ address
]

{ #category : #accessing }
VCRAMWritePortAction >> address: anObject [
	address := anObject
]

{ #category : #accessing }
VCRAMWritePortAction >> on: condition applyInComponent: component [
	port value ifNil: [ port setDefaultValues ].
	
	port value: (condition ifTrue: value ifFalse: port value).
	port address: (condition ifTrue: address ifFalse: port value).
	port enabled: (condition bitOr: port value).
]

{ #category : #accessing }
VCRAMWritePortAction >> port [
	^ port
]

{ #category : #accessing }
VCRAMWritePortAction >> port: anObject [
	port := anObject
]

{ #category : #accessing }
VCRAMWritePortAction >> value [
	^ value
]

{ #category : #accessing }
VCRAMWritePortAction >> value: anObject [
	value := anObject
]
