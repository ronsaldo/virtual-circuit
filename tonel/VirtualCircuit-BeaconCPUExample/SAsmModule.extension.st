Extension { #name : #SAsmModule }

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmModule class >> beacon [
	^ self new target: SAsmCompilationTargetBeacon new
]
