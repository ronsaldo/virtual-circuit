Extension { #name : #Boolean }

{ #category : #'*VirtualCircuit-Digital' }
Boolean >> asVCElementFor: anOwner bits: bitCount [
	^ anOwner addElement: (VCConstantInteger new
		value: self asBit;
		bits: 1;
		yourself)
]
