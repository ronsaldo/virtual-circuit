Extension { #name : #Integer }

{ #category : #'*VirtualCircuit-Digital' }
Integer >> asVCElementFor: anOwner bits: bitCount [ 
	^ anOwner addElement: (VCConstantInteger new
		value: self;
		bits: (bitCount max: self highBit);
		yourself)
]
