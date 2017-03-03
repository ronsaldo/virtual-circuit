Class {
	#name : #VCROM,
	#superclass : #Object,
	#instVars : [
		'content',
		'wordSize'
	],
	#category : #'VirtualCircuit-Core-Library'
}

{ #category : #'as yet unclassified' }
VCROM class >> content: romCode wordSize: wordSize [
	^ self new content: romCode; wordSize: wordSize; yourself

]

{ #category : #accessing }
VCROM >> content [
	^ content
]

{ #category : #accessing }
VCROM >> content: anObject [
	content := anObject
]

{ #category : #enumerating }
VCROM >> read: address into: resultRegister whenFinishedDo: action [
	| wordByteCount wordCount builder addressSignificantBitCount addressAlignmentBitCount addressSignificantBits readReady readAddressRegister romValue |
	wordByteCount := wordSize // 8.
	self assert: wordSize % 8 == 0.
	self assert: resultRegister bits == wordSize. 
	wordCount := (content size + wordByteCount - 1) // wordByteCount.
	builder := resultRegister owner builder.	
	addressSignificantBitCount := (wordCount - 1) highBit.
	addressAlignmentBitCount := (wordByteCount - 1) highBit.
	
	addressSignificantBits := address bit: addressAlignmentBitCount + 1 count: addressSignificantBitCount.
	
	readReady := builder register value: 0.
	readAddressRegister := builder register: addressSignificantBitCount.
	
	romValue := builder immediateVariable: wordSize.
	romValue value: 0.
	
	1 to: wordCount do: [ :i |
		romValue value: ((readAddressRegister equals: i - 1) ifTrue: (self wordAt: i) ifFalse: romValue value)
	].
	
	readReady whenTrueDo: {
		resultRegister <== romValue .
		action.
	}.
	
	^ {
		readAddressRegister <== addressSignificantBits.
		readReady <== 1.
	}
]

{ #category : #enumerating }
VCROM >> wordAt: index [
	wordSize = 32 ifTrue: [ ^ content unsignedLongAt: index*4 - 3].
	self halt
]

{ #category : #accessing }
VCROM >> wordSize [
	^ wordSize
]

{ #category : #accessing }
VCROM >> wordSize: anObject [
	wordSize := anObject
]
