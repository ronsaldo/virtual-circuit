Class {
	#name : #BeaconSlowCPU,
	#superclass : #VCComponentLibrary,
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'BeaconCPU-Core-SlowCPU'
}

{ #category : #cpu }
BeaconSlowCPU >> cpuICache: icacheSize dCache: dcacheSize memoryBusType: memoryInterfaceType [
	| iCache dCache registerFile stateMachine pcBank memoryBus instructionData instructionAddress |
	^ self componentBuild: [ :builder |
		builder autoClock; autoReset.
		
		memoryBus := builder memoryBusMasterInterface: memoryInterfaceType.
		
		iCache := builder instance: (VCProcessingComponentLibrary new cache: icacheSize depth: 64).
		dCache := builder instance: (VCProcessingComponentLibrary new cache: dcacheSize depth: 64).
		
		
		instructionData := builder register: 32.
		instructionAddress := builder register: 64.
		
		registerFile := builder instance: self registerFile.
		pcBank := registerFile pcBank register.
		
		stateMachine := builder stateMachine.
		stateMachine
			states: #(initial fetch wait decode execute);
			initial: #initial;
			state: #wait do: {
				stateMachine <== #wait.
				registerFile writeAddress <== (pcBank , PC)
			};
			state: #initial do: {
				pcBank <== 0.
				stateMachine <== #fetch
			};
			state: #fetch do: {
				instructionAddress <== registerFile pc.
				memoryBus read: registerFile pc into: instructionData whenFinishedDo: {
					stateMachine <== #decode.
				}.
				stateMachine <== #wait
			};
			state: #decode do: {
				stateMachine <== #execute
			};
			state: #execute do: {
				stateMachine <== #fetch
			}.
		]
]

{ #category : #'cpu components' }
BeaconSlowCPU >> registerFile [
	| readAddress1 readAddress2 writeAddress writeValue writeEnabled memory pcBank |
	^ self componentBuild: [ :builder |
		builder autoClock.
		
		readAddress1 := builder input: #readAddress1 bits: 7.
		readAddress2 := builder input: #readAddress2 bits: 7.
		pcBank := builder input: #pcBank bits: 2.

		writeAddress := builder input: #writeAddress bits: 7.
		writeValue := builder input: #writeValue bits: 64.
		writeEnabled := builder input: #writeEnabled.
		
		memory := builder distributedRam: 32*4 depth: 64.
		
		memory write: writeAddress value: writeValue when: writeEnabled.
		builder output: #read1 bits: 64 value: ((readAddress1 equals: 0) ifTrue: 0 ifFalse: (memory read: readAddress1)).
		builder output: #read2 bits: 64 value: ((readAddress2 equals: 0) ifTrue: 0 ifFalse: (memory read: readAddress2)).
		builder output: #pc bits: 64 value: (memory read: pcBank << 5).
	]
]
