Class {
	#name : #BeaconBoardIOComponentInputPins,
	#superclass : #BeaconBoardIOComponent,
	#instVars : [
		'portName',
		'bits',
		'pins'
	],
	#category : #'VirtualCircuit-BeaconCPUExample-Board'
}

{ #category : #accessing }
BeaconBoardIOComponentInputPins >> bits [
	^ bits
]

{ #category : #accessing }
BeaconBoardIOComponentInputPins >> bits: anObject [
	bits := anObject
]

{ #category : #'as yet unclassified' }
BeaconBoardIOComponentInputPins >> connectToSlave: slaveBus registerBase: registerBase [
	slaveBus register: registerBase onRead: [ :condition :resultRegister :finish |
		condition whenTrueDo: {
			resultRegister <== pins.
			finish
		}
	].

]

{ #category : #'as yet unclassified' }
BeaconBoardIOComponentInputPins >> createPortsWith: builder [
	pins := builder input: portName bits: bits.
]

{ #category : #accessing }
BeaconBoardIOComponentInputPins >> portName [
	^ portName
]

{ #category : #accessing }
BeaconBoardIOComponentInputPins >> portName: anObject [
	portName := anObject
]

{ #category : #enumerating }
BeaconBoardIOComponentInputPins >> with: builder when: condition readInto: dataRegister at: registerIndex thenDo: finishedAction [
	condition whenTrueDo: {
		dataRegister <== pins.
		finishedAction
	}
]

{ #category : #enumerating }
BeaconBoardIOComponentInputPins >> with: builder when: condition write: value at: registerIndex thenDo: finishedAction [
	condition whenTrueDo: finishedAction
]
