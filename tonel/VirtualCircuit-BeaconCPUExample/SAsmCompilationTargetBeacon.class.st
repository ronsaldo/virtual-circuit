Class {
	#name : #SAsmCompilationTargetBeacon,
	#superclass : #SAsmCompilationTarget,
	#category : #'VirtualCircuit-BeaconCPUExample-ISA'
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

{ #category : #'as yet unclassified' }
SAsmCompilationTargetBeacon >> emitNopOfSize: paddingSize with: writer [
	| nopCount |
	self assert: paddingSize % 4 = 0.
	nopCount := paddingSize // 4.
	1 to: nopCount do: [:i |
		writer nextPutC32: 0
	]
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
