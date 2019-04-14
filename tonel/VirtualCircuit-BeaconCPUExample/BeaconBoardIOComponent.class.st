"
32 bit component IO.
"
Class {
	#name : #BeaconBoardIOComponent,
	#superclass : #Object,
	#instVars : [
		'constraints'
	],
	#category : #'VirtualCircuit-BeaconCPUExample-Board'
}

{ #category : #'as yet unclassified' }
BeaconBoardIOComponent >> connectToSlave: slaveBus registerBase: registerOffset [
	self subclassResponsibility
]

{ #category : #accessing }
BeaconBoardIOComponent >> constraints [
	^ constraints
]

{ #category : #accessing }
BeaconBoardIOComponent >> constraints: anObject [
	constraints := anObject
]

{ #category : #'as yet unclassified' }
BeaconBoardIOComponent >> emitConstraintsInto: out [
	out nextPutAll: constraints
]

{ #category : #accessing }
BeaconBoardIOComponent >> registerCount [
	^ 1
]
