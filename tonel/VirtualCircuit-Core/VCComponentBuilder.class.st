Class {
	#name : #VCComponentBuilder,
	#superclass : #Object,
	#instVars : [
		'component'
	],
	#category : #'VirtualCircuit-Core-Circuit'
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
VCComponentBuilder >> axiBusMaster [
	^ VCAXIMemoryBusMaster new builder: self
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
VCComponentBuilder >> memoryBusMasterInterface: interfaceName [
	^ self memoryBusMasterInterface: interfaceName prefix: '' suffix: ''
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusMasterInterface: interfaceName prefix: prefix [
	^ self memoryBusMasterInterface: interfaceName prefix: prefix suffix: ''
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusMasterInterface: interfaceName prefix: prefix suffix: suffix [
	^ (VCMemoryBusMaster subclasses detect: [ :busClass | busClass interfaceName == interfaceName ]) new
		busPrefix: prefix;
		busSuffix: suffix;
		builder: self;
		yourself
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusMasterInterface: interfaceName suffix: suffix [
	^ self memoryBusMasterInterface: interfaceName prefix: '' suffix: suffix
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusSlaveInterface: interfaceName [
	^ self memoryBusSlaveInterface: interfaceName prefix: '' suffix: ''
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusSlaveInterface: interfaceName prefix: prefix [
	^ self memoryBusSlaveInterface: interfaceName prefix: prefix suffix: ''
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusSlaveInterface: interfaceName prefix: prefix suffix: suffix [
	^ (VCMemoryBusSlave subclasses detect: [ :busClass | busClass interfaceName == interfaceName ]) new
		busPrefix: prefix;
		busSuffix: suffix;
		builder: self;
		yourself
]

{ #category : #'memory bus' }
VCComponentBuilder >> memoryBusSlaveInterface: interfaceName suffix: suffix [
	^ self memoryBusSlaveInterface: interfaceName prefix: '' suffix: suffix
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
