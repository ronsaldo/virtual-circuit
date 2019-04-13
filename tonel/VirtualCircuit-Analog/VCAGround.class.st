Class {
	#name : #VCAGround,
	#superclass : #VCAComponent,
	#instVars : [
		'wire'
	],
	#category : #'VirtualCircuit-Analog'
}

{ #category : #adding }
VCAGround >> addToWires [
	wire grounded: true.
]

{ #category : #accessing }
VCAGround >> wire [
	^ wire
]

{ #category : #accessing }
VCAGround >> wire: anObject [
	wire := anObject
]
