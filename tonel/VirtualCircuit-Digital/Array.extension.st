Extension { #name : #Array }

{ #category : #'*VirtualCircuit-Digital' }
Array >> asVCSequentialAction [
	^ VCSequentialActionList new list: (self collect: #asVCSequentialAction)
]
