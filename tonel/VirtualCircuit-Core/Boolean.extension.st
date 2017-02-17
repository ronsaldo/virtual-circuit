Extension { #name : #Boolean }

{ #category : #'*VirtualCircuit-Core' }
Boolean >> asVCElementFor: anOwner bits: bitCount [
	^ anOwner addElement: (VCConstantInteger new
		value: self asBit;
		bits: 1;
		yourself)
]
