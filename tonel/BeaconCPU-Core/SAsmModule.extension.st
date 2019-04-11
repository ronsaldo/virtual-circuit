Extension { #name : #SAsmModule }

{ #category : #'*BeaconCPU-Core' }
SAsmModule class >> beacon [
	^ self new target: SAsmCompilationTargetBeacon new
]
