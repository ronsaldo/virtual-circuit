Class {
	#name : #VCVariable,
	#superclass : #VCElement,
	#instVars : [
		'bits',
		'value'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'logical operations' }
VCVariable >> & other [
	^ self bitAnd: other
	
]

{ #category : #visualization }
VCVariable >> addRoassalEdgesFrom: element toView: view [
	value isVirtualCircuitElement ifTrue: [
		view add: (RTLine edgeFrom: element to: (view elementFromModel: value))
	].
]

{ #category : #packing }
VCVariable >> bit: bitIndex [
	^ self bit: bitIndex count: 1
]

{ #category : #packing }
VCVariable >> bit: bitIndex count: bitCount [
	^ owner addElement: (VCBitExtract new
		wire: self;
		index: bitIndex;
		count: bitCount;
		yourself)
]

{ #category : #'logical operations' }
VCVariable >> bitAnd: other [
	self assert: bits = other bits.
	^ owner addElement: (VCLogicalOperation operation: #and bits: bits first: self second: other)
]

{ #category : #'logical operations' }
VCVariable >> bitArithmeticRightShift: shiftAmount [
	^ self bitArithmeticRightShift: shiftAmount bits: bits
]

{ #category : #'logical operations' }
VCVariable >> bitArithmeticRightShift: shiftAmount bits: resultBits [
	^ owner addElement: (VCLogicalOperation operation: #arshift bits: resultBits first: self second: shiftAmount)
]

{ #category : #'logical operations' }
VCVariable >> bitInvert [
	^ owner addElement: (VCLogicalOperation operation: #not bits: bits operand: self)
]

{ #category : #'logical operations' }
VCVariable >> bitLeftShift: shiftAmount [
	^ self bitLeftShift: shiftAmount bits: bits
]

{ #category : #'logical operations' }
VCVariable >> bitLeftShift: shiftAmount bits: resultBits [
	^ owner addElement: (VCLogicalOperation operation: #lshift bits: resultBits first: self second: shiftAmount)
]

{ #category : #'logical operations' }
VCVariable >> bitLogicalRightShift: shiftAmount [
	^ self bitLogicalRightShift: shiftAmount bits: bits
]

{ #category : #'logical operations' }
VCVariable >> bitLogicalRightShift: shiftAmount bits: resultBits [
	^ owner addElement: (VCLogicalOperation operation: #lrshift bits: resultBits first: self second: shiftAmount)
]

{ #category : #'logical operations' }
VCVariable >> bitOr: other [
	self assert: bits = other bits.
	^ owner addElement: (VCLogicalOperation operation: #or bits: bits first: self second: other)
]

{ #category : #'logical operations' }
VCVariable >> bitXor: other [
	self assert: bits = other bits.
	^ owner addElement: (VCLogicalOperation operation: #xor bits: bits first: self second: other)
]

{ #category : #accessing }
VCVariable >> bits [
	^ bits
]

{ #category : #accessing }
VCVariable >> bits: anObject [
	bits := anObject
]

{ #category : #initialization }
VCVariable >> initialize [
	super initialize.
	bits := 1.
	isRegister := false
	
]

{ #category : #testing }
VCVariable >> isRegister [
	^ isRegister
]

{ #category : #'logical operations' }
VCVariable >> not [
	^ self bitInvert
]

{ #category : #'tools registry' }
VCVariable >> register [
	isRegister := true
]

{ #category : #accessing }
VCVariable >> value [
	^ value
]

{ #category : #accessing }
VCVariable >> value: anObject [
	value := anObject
]

{ #category : #accessing }
VCVariable >> wire [
	isRegister := false
]

{ #category : #'logical operations' }
VCVariable >> | other [
	^ self bitOr: other
	
]
