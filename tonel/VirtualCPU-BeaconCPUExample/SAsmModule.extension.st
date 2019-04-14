Extension { #name : #SAsmModule }

{ #category : #'*VirtualCPU-BeaconCPUExample' }
SAsmModule class >> beacon [
	^ self new target: SAsmCompilationTargetBeacon new
]
