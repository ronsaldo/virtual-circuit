Class {
	#name : #VCACircuitBuilder,
	#superclass : #Object,
	#instVars : [
		'circuit'
	],
	#category : #'VirtualCircuit-Analog'
}

{ #category : #'as yet unclassified' }
VCACircuitBuilder >> ac: value [
	^ circuit addComponent: (VCAACVoltageSource new value: value)
]

{ #category : #'as yet unclassified' }
VCACircuitBuilder >> capacitor: value [
	^ circuit addComponent: (VCACapacitor new value: value)
]

{ #category : #accessing }
VCACircuitBuilder >> circuit [
	^ circuit
]

{ #category : #accessing }
VCACircuitBuilder >> circuit: anObject [
	circuit := anObject
]

{ #category : #'as yet unclassified' }
VCACircuitBuilder >> dc: value [
	^ circuit addComponent: (VCADCVoltageSource new value: value)
]

{ #category : #accessing }
VCACircuitBuilder >> ground [
	^ circuit addComponent: (VCAGround new)
]

{ #category : #'as yet unclassified' }
VCACircuitBuilder >> inductor: value [
	^ circuit addComponent: (VCAInductor new value: value)
]

{ #category : #'as yet unclassified' }
VCACircuitBuilder >> resistor: value [
	^ circuit addComponent: (VCAResistor new value: value)
]

{ #category : #accessing }
VCACircuitBuilder >> wire [
	^ circuit addWire: (VCAWire new)
]
