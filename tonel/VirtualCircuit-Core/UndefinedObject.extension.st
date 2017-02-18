Extension { #name : #UndefinedObject }

{ #category : #'*VirtualCircuit-Core' }
UndefinedObject >> asVCElementFor: anOwner bits: bitCoint [
	^ self
]

{ #category : #'*VirtualCircuit-Core' }
UndefinedObject >> asVCSequentialAction [
	^ VCNopAction new
]
