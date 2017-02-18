Extension { #name : #Array }

{ #category : #'*VirtualCircuit-Core' }
Array >> asVCSequentialAction [
	^ VCSequentialActionList new list: (self collect: #asVCSequentialAction)
]
