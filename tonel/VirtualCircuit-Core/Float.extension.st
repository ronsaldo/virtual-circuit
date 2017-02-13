Extension { #name : #Float }

{ #category : #'*VirtualCircuit-Core' }
Float >> asVCElementFor: anOwner bits: bitCount [
	^ anOwner addElement: (VCConstantFloat new
		value: self;
		bits: bitCount;
		yourself)
]
