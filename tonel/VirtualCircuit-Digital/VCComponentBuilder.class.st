Class {
	#name : #VCComponentBuilder,
	#superclass : #Object,
	#instVars : [
		'component'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #'state machine' }
VCComponentBuilder >> actionList: aSequence [
	^ VCSequentialActionList new list: aSequence
]

{ #category : #clock }
VCComponentBuilder >> autoClock [
	^ component autoClock
]

{ #category : #reset }
VCComponentBuilder >> autoReset [
	^ component autoReset
]

{ #category : #'memory bus' }
VCComponentBuilder >> axi4LiteBusMaster [
	^ self memoryBusMasterInterface: VCAXI4LiteMemoryBusMaster
]

{ #category : #'memory bus' }
VCComponentBuilder >> axi4LiteBusSlave [
	^ self memoryBusMasterInterface: VCAXI4LiteMemoryBusSlave
]

{ #category : #registers }
VCComponentBuilder >> blockRam: size depth: depth [
	^ (self ram: size depth: depth)
		distributed: false;
		yourself
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

{ #category : #constants }
VCComponentBuilder >> const: value bits: bitCount [
	^ value asVCElementFor: component bits: bitCount
]

{ #category : #registers }
VCComponentBuilder >> distributedRam: size depth: depth [
	^ (self ram: size depth: depth)
		distributed: true;
		yourself
]

{ #category : #registers }
VCComponentBuilder >> immediateVariable [
	^ self immediateVariable: 1
]

{ #category : #registers }
VCComponentBuilder >> immediateVariable: bits [
	^ component addElement: (VCVariable new
		bits: bits;
		yourself)
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

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusMasterInterface: interface [
	^ self memoryBusMasterInterface: interface prefix: '' suffix: ''
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusMasterInterface: interface prefix: prefix [
	^ self memoryBusMasterInterface: interface prefix: prefix suffix: ''
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusMasterInterface: interface prefix: prefix suffix: suffix [
	^ interface asVCMemoryBusMasterInterface
		busPrefix: prefix;
		busSuffix: suffix;
		builder: self;
		yourself
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusMasterInterface: interface suffix: suffix [
	^ self memoryBusMasterInterface: interface prefix: '' suffix: suffix
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusSlaveInterface: interface [
	^ self memoryBusSlaveInterface: interface prefix: '' suffix: ''
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusSlaveInterface: interface prefix: prefix [
	^ self memoryBusSlaveInterface: interface prefix: prefix suffix: ''
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusSlaveInterface: interface prefix: prefix suffix: suffix [
	^ interface asVCMemoryBusSlaveInterface
		busPrefix: prefix;
		busSuffix: suffix;
		builder: self;
		yourself
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusSlaveInterface: interface suffix: suffix [
	^ self memoryBusSlaveInterface: interface prefix: '' suffix: suffix
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
	| result |
	result := component addPin: (VCOutputPin new
		name: pinName;
		bits: bits;
		yourself).
	result value: value.
	^ result
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

{ #category : #pins }
VCComponentBuilder >> outputRegister: inputName [
	^ self outputRegister: inputName bits: 1
]

{ #category : #pins }
VCComponentBuilder >> outputRegister: inputName bits: bits [
	| result |
	result := self register: bits.
	result name: inputName.
	self output: inputName bits: bits value: result.
	^ result
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
VCComponentBuilder >> ram: size depth: depth [
	^ component addElement: (VCRAMModule new
		depth: depth;
		size: size;
		yourself)
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

{ #category : #reset }
VCComponentBuilder >> reset [
	^ component resetPin
]

{ #category : #actions }
VCComponentBuilder >> stateMachine [
	^ VCStateMachineBuilder new
		builder: self;
		yourself
]
