Class {
	#name : #VCComponentBuilder,
	#superclass : #Object,
	#instVars : [
		'component'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #clock }
VCComponentBuilder >> autoClock [
	^ component autoClock
]

{ #category : #clock }
VCComponentBuilder >> clock [
	^ component ensureClockPin
]

{ #category : #accessing }
VCComponentBuilder >> component [
	^ component
]

{ #category : #pins }
VCComponentBuilder >> component: aComponent [
	component := aComponent
]

{ #category : #pins }
VCComponentBuilder >> inout: inputName [
	^ self inout: inputName bits: 1
]

{ #category : #pins }
VCComponentBuilder >> inout: inputName bits: bits [
]

{ #category : #pins }
VCComponentBuilder >> input: inputName [
	^ self input: inputName bits: 1
]

{ #category : #pins }
VCComponentBuilder >> input: pinName bits: bits [
	^ component addPin: (VCInputPin new
		name: pinName;
		bits: bits;
		yourself
	)
]

{ #category : #pins }
VCComponentBuilder >> instance: aComponent [
	^ component addElement: aComponent makeInstance
]

{ #category : #pins }
VCComponentBuilder >> output: inputName [
	^ self output: inputName bits: 1
]

{ #category : #pins }
VCComponentBuilder >> output: inputName bits: bits [
	^ self output: inputName bits: bits value: nil
]

{ #category : #pins }
VCComponentBuilder >> output: pinName bits: bits value: value [
	^ component addPin: (VCOutputPin new
		name: pinName;
		bits: bits;
		value: value
	)
]

{ #category : #pins }
VCComponentBuilder >> output: inputName pack: collection [
	| packed |
	packed := self pack: collection.
	
	^ self output: inputName bits: packed bits value: packed
]

{ #category : #pins }
VCComponentBuilder >> output: inputName pack: collection with: aBlock [
	| packed |
	packed := self pack: collection with: aBlock.
	^ self output: inputName bits: packed bits value: packed
]

{ #category : #pins }
VCComponentBuilder >> output: inputName value: value [
	^ self output: inputName bits: 1 value: value
]

{ #category : #packing }
VCComponentBuilder >> pack: elements [
	| bits |
	bits := 0.
	elements do: [ :el |
		bits := bits + el bits
	].

	^ component addElement: (VCBitPack new
		bits: bits;
		wires: elements;
		yourself)
]

{ #category : #packing }
VCComponentBuilder >> pack: elements with: aBlock [
	^ self pack: (elements collect: aBlock)
]

{ #category : #registers }
VCComponentBuilder >> register [
	^ self register: 1
]

{ #category : #registers }
VCComponentBuilder >> register: bits [
	^ component addElement: (VCRegister new
		bits: bits;
		yourself)
]
