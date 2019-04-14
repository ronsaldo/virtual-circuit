Extension { #name : #Symbol }

{ #category : #'*VirtualCircuit-Digital' }
Symbol >> asVCMemoryBusMasterInterface [
	^ (VCMemoryBusMaster allSubclasses detect: [ :busClass | busClass interfaceName == self ]) new.
]

{ #category : #'*VirtualCircuit-Digital' }
Symbol >> asVCMemoryBusSlaveInterface [
	^ (VCMemoryBusSlave allSubclasses detect: [ :busClass | busClass interfaceName == self ]) new.
]
