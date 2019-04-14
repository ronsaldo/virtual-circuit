Extension { #name : #UndefinedObject }

{ #category : #'*VirtualCircuit-Digital' }
UndefinedObject >> asVCElementFor: anOwner bits: bitCoint [
	^ self
]

{ #category : #'*VirtualCircuit-Digital' }
UndefinedObject >> asVCSequentialAction [
	^ VCNopAction new
]
