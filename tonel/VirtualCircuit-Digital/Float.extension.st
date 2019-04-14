Extension { #name : #Float }

{ #category : #'*VirtualCircuit-Digital' }
Float >> asVCElementFor: anOwner bits: bitCount [
	^ anOwner addElement: (VCConstantFloat new
		value: self;
		bits: bitCount;
		yourself)
]
