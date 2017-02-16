Extension { #name : #SAsmModule }

{ #category : #'*BeaconCPU-Core' }
SAsmModule classSide >> beacon [
	^ self new target: SAsmCompilationTargetBeacon new
]
