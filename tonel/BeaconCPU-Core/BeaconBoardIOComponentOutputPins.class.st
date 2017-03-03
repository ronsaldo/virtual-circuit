Class {
	#name : #BeaconBoardIOComponentOutputPins,
	#superclass : #BeaconBoardIOComponent,
	#instVars : [
		'portName',
		'bits',
		'default',
		'register'
	],
	#category : #'BeaconCPU-Core-Board'
}

{ #category : #accessing }
BeaconBoardIOComponentOutputPins >> bits [
	^ bits
]

{ #category : #accessing }
BeaconBoardIOComponentOutputPins >> bits: anObject [
	bits := anObject
]

{ #category : #'as yet unclassified' }
BeaconBoardIOComponentOutputPins >> connectToSlave: slaveBus registerBase: registerBase [
	slaveBus register: registerBase onWrite: [ :condition :value :strobe :finish |
		condition whenTrueDo: {
			register <== value.
			finish
		}
	].

	slaveBus register: registerBase onRead: [ :condition :resultRegister :finish |
		condition whenTrueDo: {
			resultRegister <== register.
			finish
		}
	].

]

{ #category : #'as yet unclassified' }
BeaconBoardIOComponentOutputPins >> createPortsWith: builder [
	register := builder outputRegister: portName bits: bits.
]

{ #category : #accessing }
BeaconBoardIOComponentOutputPins >> default [
	^ default
]

{ #category : #accessing }
BeaconBoardIOComponentOutputPins >> default: anObject [
	default := anObject
]

{ #category : #accessing }
BeaconBoardIOComponentOutputPins >> portName [
	^ portName
]

{ #category : #accessing }
BeaconBoardIOComponentOutputPins >> portName: anObject [
	portName := anObject
]
