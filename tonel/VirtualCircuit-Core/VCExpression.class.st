Class {
	#name : #VCExpression,
	#superclass : #VCElement,
	#instVars : [
		'bits'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'logical operations' }
VCExpression >> & other [
	^ self bitAnd: other
	
]

{ #category : #packing }
VCExpression >> bit: bitIndex [
	^ self bit: bitIndex count: 1
]

{ #category : #packing }
VCExpression >> bit: bitIndex count: bitCount [
	^ owner addElement: (VCBitExtract new
		wire: self;
		index: bitIndex;
		count: bitCount;
		yourself)
]

{ #category : #'logical operations' }
VCExpression >> bitAnd: other [
	self assert: bits = other bits.
	^ owner addElement: (VCLogicalOperation operation: #and bits: bits first: self second: other)
]

{ #category : #'logical operations' }
VCExpression >> bitArithmeticRightShift: shiftAmount [
	^ self bitArithmeticRightShift: shiftAmount bits: bits
]

{ #category : #'logical operations' }
VCExpression >> bitArithmeticRightShift: shiftAmount bits: resultBits [
	^ owner addElement: (VCLogicalOperation operation: #arshift bits: resultBits first: self second: shiftAmount)
]

{ #category : #'logical operations' }
VCExpression >> bitInvert [
	^ owner addElement: (VCLogicalOperation operation: #not bits: bits operand: self)
]

{ #category : #'logical operations' }
VCExpression >> bitLeftShift: shiftAmount [
	^ self bitLeftShift: shiftAmount bits: bits
]

{ #category : #'logical operations' }
VCExpression >> bitLeftShift: shiftAmount bits: resultBits [
	^ owner addElement: (VCLogicalOperation operation: #lshift bits: resultBits first: self second: shiftAmount)
]

{ #category : #'logical operations' }
VCExpression >> bitLogicalRightShift: shiftAmount [
	^ self bitLogicalRightShift: shiftAmount bits: bits
]

{ #category : #'logical operations' }
VCExpression >> bitLogicalRightShift: shiftAmount bits: resultBits [
	^ owner addElement: (VCLogicalOperation operation: #lrshift bits: resultBits first: self second: shiftAmount)
]

{ #category : #'logical operations' }
VCExpression >> bitOr: other [
	self assert: bits = other bits.
	^ owner addElement: (VCLogicalOperation operation: #or bits: bits first: self second: other)
]

{ #category : #'logical operations' }
VCExpression >> bitXor: other [
	self assert: bits = other bits.
	^ owner addElement: (VCLogicalOperation operation: #xor bits: bits first: self second: other)
]

{ #category : #accessing }
VCExpression >> bits [
	^ bits
]

{ #category : #accessing }
VCExpression >> bits: anObject [
	bits := anObject
]

{ #category : #'logical operations' }
VCExpression >> ifFalse: falseValue ifTrue: trueValue [
	self assert: bits = 1.
	"Mux"
	^ owner addElement: (VCSelectCondition new
		condition: self;
		trueValue: trueValue;
		falseValue: falseValue;
		yourself)
]

{ #category : #'logical operations' }
VCExpression >> ifTrue: trueValue ifFalse: falseValue [
	self assert: bits = 1.
	"Mux"
	^ owner addElement: (VCSelectCondition new
		condition: self;
		trueValue: trueValue;
		falseValue: falseValue;
		yourself)
]

{ #category : #initialization }
VCExpression >> initialize [
	super initialize.
	bits := 1.
]

{ #category : #'as yet unclassified' }
VCExpression >> isExpression [
	^ true
]

{ #category : #'logical operations' }
VCExpression >> not [
	^ self bitInvert
]

{ #category : #conditions }
VCExpression >> whenFalseDo: actions [
	self assert: bits = 1.
	^ self not whenTrueDo: actions
]

{ #category : #conditions }
VCExpression >> whenTrueDo: actions [
	self assert: bits = 1.
	actions do: [ :action |
		action on: self applyInComponent: owner
	]
]

{ #category : #'logical operations' }
VCExpression >> | other [
	^ self bitOr: other
	
]
