Class {
	#name : #SAsmCompilationTargetBeacon,
	#superclass : #SAsmCompilationTarget,
	#pools : [
		'BeaconSlowCPU'
	],
	#category : #'BeaconCPU-Core-ISA'
}

{ #category : #'calling conventions' }
SAsmCompilationTargetBeacon >> callingConventionNamed: callingConventionName [
	callingConventionName == #naked ifTrue: [ ^ SAsmBeaconCallingConventionNaked new ].
	^ SAsmBeaconCallingConventionC new
]

{ #category : #'as yet unclassified' }
SAsmCompilationTargetBeacon >> createInstructionLowerer [
	^ SAsmBeaconInstructionLowerer new target: self
]

{ #category : #accessing }
SAsmCompilationTargetBeacon >> pointerSize [
	^ 8
]

{ #category : #'as yet unclassified' }
SAsmCompilationTargetBeacon >> setupBinaryObjectWriter: objectWriter [
	
]

{ #category : #accessing }
SAsmCompilationTargetBeacon >> usesElf64 [
	^ true
]
