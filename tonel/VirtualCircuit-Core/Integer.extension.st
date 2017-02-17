Extension { #name : #Integer }

{ #category : #'*VirtualCircuit-Core' }
Integer >> asVCElementFor: anOwner bits: bitCount [ 
	^ anOwner addElement: (VCConstantInteger new
		value: self;
		bits: (bitCount max: self highBit);
		yourself)
]
