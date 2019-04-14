Class {
	#name : #VCExpression,
	#superclass : #VCElement,
	#instVars : [
		'bits'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #'logical operations' }
VCExpression >> & other [
	^ self bitAnd: other
	
]

{ #category : #'logical operations' }
VCExpression >> * other [
	^ owner addElement: (VCLogicalOperation operation: #* bits: bits first: self second: (self adaptElement: other))
]

{ #category : #'logical operations' }
VCExpression >> + other [
	^ owner addElement: (VCLogicalOperation operation: #+ bits: bits first: self second: (self adaptElement: other))
]

{ #category : #packing }
VCExpression >> , other [
	^ owner addElement: (VCBitPack new
		wires: {self . other asVCElementFor: owner };
		computeBitCount;
		yourself)
]

{ #category : #'logical operations' }
VCExpression >> - other [
	^ owner addElement: (VCLogicalOperation operation: #- bits: bits first: self second: (self adaptElement: other))
]

{ #category : #'logical operations' }
VCExpression >> / other [
	^ owner addElement: (VCLogicalOperation operation: #/ bits: bits first: self second: (self adaptElement: other))
]

{ #category : #'logical operations' }
VCExpression >> << bitShiftAmount [
	^ self bitLeftShift: bitShiftAmount
]

{ #category : #'logical operations' }
VCExpression >> >> bitShiftAmount [
	^ self bitLogicalRightShift: bitShiftAmount
]

{ #category : #'as yet unclassified' }
VCExpression >> adaptElement: anElement [
	^ anElement asVCElementFor: owner bits: bits
]

{ #category : #'logical operations' }
VCExpression >> alignedDownTo: alignment [
	| discardedBits |
	discardedBits := (alignment - 1) highBit.
	^ discardedBits <= 0
		ifTrue: [ self ]
		ifFalse: [ (self bit: 1 + discardedBits count: bits - discardedBits) ,
				(VCConstantInteger new value: 0; bits: discardedBits; yourself)  ]
]

{ #category : #converting }
VCExpression >> asVCElementFor: anOwner bits: bitCount [
	| paddingSizeCount |
	bits > bitCount ifTrue: [
		^ self bit: 1 count: bitCount
	].
	bits < bitCount ifTrue: [
		paddingSizeCount := bitCount - bits.
		self assert: paddingSizeCount > 0.
		^ (0 asVCElementFor: owner bits: paddingSizeCount) , self
	].

	^ self
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
		bits: bitCount;
		yourself)
]

{ #category : #'logical operations' }
VCExpression >> bitAnd: other [
	^ owner addElement: (VCLogicalOperation operation: #and bits: bits first: self second: (self adaptElement: other))
]

{ #category : #'logical operations' }
VCExpression >> bitArithmeticRightShift: shiftAmount [
	^ self bitArithmeticRightShift: shiftAmount bits: bits
]

{ #category : #'logical operations' }
VCExpression >> bitArithmeticRightShift: shiftAmount bits: resultBits [
	^ owner addElement: (VCLogicalOperation operation: #arshift bits: resultBits first: self second: (self adaptElement: shiftAmount))
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
	^ owner addElement: (VCLogicalOperation operation: #lshift bits: resultBits first: self second: (self adaptElement: shiftAmount))
]

{ #category : #'logical operations' }
VCExpression >> bitLogicalRightShift: shiftAmount [
	^ self bitLogicalRightShift: shiftAmount bits: bits
]

{ #category : #'logical operations' }
VCExpression >> bitLogicalRightShift: shiftAmount bits: resultBits [
	^ owner addElement: (VCLogicalOperation operation: #lrshift bits: resultBits first: self second: (self adaptElement: shiftAmount))
]

{ #category : #'logical operations' }
VCExpression >> bitOr: other [
	^ owner addElement: (VCLogicalOperation operation: #or bits: bits first: self second: (self adaptElement: other))
]

{ #category : #'logical operations' }
VCExpression >> bitXor: other [
	^ owner addElement: (VCLogicalOperation operation: #xor bits: bits first: self second: (self adaptElement: other))
]

{ #category : #accessing }
VCExpression >> bits [
	^ bits
]

{ #category : #accessing }
VCExpression >> bits: anObject [
	self assert: anObject > 0.
	bits := anObject
]

{ #category : #comparison }
VCExpression >> equals: other [
	^ owner addElement: (VCLogicalOperation operation: #equals bits: 1 first: self second: (self adaptElement: other))
]

{ #category : #'logical operations' }
VCExpression >> ifFalse: falseValue ifTrue: trueValue [
	| resultBits |
	self assert: bits = 1.
	resultBits := self inferMaxBitDepth: { falseValue . trueValue }.
	"Mux"
	^ owner addElement: (VCSelectCondition new
		condition: self;
		bits: resultBits;
		trueValue: (trueValue asVCElementFor: owner bits: resultBits);
		falseValue: (falseValue asVCElementFor: owner bits: resultBits);
		yourself)
]

{ #category : #'logical operations' }
VCExpression >> ifTrue: trueValue ifFalse: falseValue [
	| resultBits |
	self assert: bits = 1.
	resultBits := self inferMaxBitDepth: { falseValue . trueValue }.
	"Mux"
	^ owner addElement: (VCSelectCondition new
		condition: self;
		bits: resultBits;
		trueValue: (trueValue asVCElementFor: owner bits: resultBits);
		falseValue: (falseValue asVCElementFor: owner bits: resultBits);
		yourself)
]

{ #category : #'as yet unclassified' }
VCExpression >> inferMaxBitDepth: anArray [
	| result |
	result := 1.
	anArray do: [ :element |
		(element isVirtualCircuitElement and: [ element isExpression ]) ifTrue: [ 
			result := result max: element bits
		]
	].
	^ result
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

{ #category : #packing }
VCExpression >> lastBit [
	^ self bit: self bits
]

{ #category : #'logical operations' }
VCExpression >> not [
	^ self bitInvert
]

{ #category : #comparison }
VCExpression >> notEquals: other [
	^ owner addElement: (VCLogicalOperation operation: #notEquals bits: 1 first: self second: (self adaptElement: other))
]

{ #category : #packing }
VCExpression >> repeat: repeatCount [
	^ owner addElement: (VCBitRepeat new
		wire: self;
		count: repeatCount;
		bits: bits*repeatCount;
		yourself)
]

{ #category : #packing }
VCExpression >> splitBits: bitSizes [
	| index result |
	index := bits.
	result := bitSizes collect: [ :size |
		index := index - size.
		self bit: index + 1 count: size.
	].

	self assert: index = 0.
	^ result
]

{ #category : #packing }
VCExpression >> splitBitsReverse: bitSizes [
	| index result |
	index := 1.
	result := bitSizes collect: [ :size |
		|value|
		value := self bit: index count: size.
		index := index + size.
		value
	].

	self assert: index = (bits + 1).
	^ result
]

{ #category : #conditions }
VCExpression >> whenFalse: action [
	^ self whenTrue: nil whenFalse: action
]

{ #category : #conditions }
VCExpression >> whenFalse: falseAction whenTrue: trueAction [
	self assert: bits = 1.
	^ VCConditionalAction new
		condition: self;
		trueAction: trueAction asVCSequentialAction;
		falseAction: falseAction asVCSequentialAction;
		yourself
]

{ #category : #conditions }
VCExpression >> whenFalseDo: actions [
	self assert: bits = 1.
	^ self not whenTrueDo: actions
]

{ #category : #conditions }
VCExpression >> whenTrue: action [
	^ self whenTrue: action whenFalse: nil
]

{ #category : #conditions }
VCExpression >> whenTrue: trueAction whenFalse: falseAction [
	self assert: bits = 1.
	^ VCConditionalAction new
		condition: self;
		trueAction: trueAction asVCSequentialAction;
		falseAction: falseAction asVCSequentialAction;
		yourself
]

{ #category : #conditions }
VCExpression >> whenTrueDo: action [
	self assert: bits = 1.
	action asVCSequentialAction on: self applyInComponent: owner
]

{ #category : #'logical operations' }
VCExpression >> | other [
	^ self bitOr: other
	
]
