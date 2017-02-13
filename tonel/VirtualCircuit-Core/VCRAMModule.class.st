Class {
	#name : #VCRAMModule,
	#superclass : #VCElement,
	#instVars : [
		'size',
		'depth',
		'ports',
		'clock',
		'distributed'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCRAMModule >> accept: aVisitor [
	^ aVisitor visitRAMModule: self
]

{ #category : #accessing }
VCRAMModule >> clock [
	^ clock
]

{ #category : #accessing }
VCRAMModule >> clock: anObject [
	clock := anObject
]

{ #category : #accessing }
VCRAMModule >> depth [
	^ depth
]

{ #category : #accessing }
VCRAMModule >> depth: anObject [
	depth := anObject
]

{ #category : #accessing }
VCRAMModule >> distributed [
	^ distributed
]

{ #category : #accessing }
VCRAMModule >> distributed: anObject [
	distributed := anObject
]

{ #category : #initialization }
VCRAMModule >> initialize [
	super initialize.
	ports := OrderedCollection new.
	distributed := false.
]

{ #category : #testing }
VCRAMModule >> needsClock [
	^ true
]

{ #category : #accessing }
VCRAMModule >> ports [
	^ ports
]

{ #category : #'meta-object-protocol' }
VCRAMModule >> read: address [
	| port |
	port := VCRAMReadPort new
		ram: self;
		address: address;
		yourself.
	ports add: port.
	^ port
]

{ #category : #accessing }
VCRAMModule >> size [
	^ size
]

{ #category : #accessing }
VCRAMModule >> size: anObject [
	size := anObject
]

{ #category : #'meta-object-protocol' }
VCRAMModule >> write: address value: value when: writeEnabled [
	| port |
	port := VCRAMWritePort new
		ram: self;
		address: address;
		enabled: writeEnabled;
		value: value;
		yourself.
	ports add: port.
	^ port
]
