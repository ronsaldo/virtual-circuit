Class {
	#name : #BeaconSlowCPU,
	#superclass : #BeaconSlowCPUNoCache,
	#instVars : [
		'instructionCacheSize',
		'dataCacheSize',
		'instructionCacheBus',
		'dataCacheBus',
		'cacheMemoryBusMux',
		'instructionCache',
		'dataCache'
	],
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'BeaconCPU-Core-SlowCPU'
}

{ #category : #building }
BeaconSlowCPU >> createCaches [
	instructionCache := builder instance: (BeaconSlowCPUCache new
		name: #BeaconSlowCPUInstructionCache;
		size: instructionCacheSize;
		component).
	instructionCacheBus := instructionCache memoryBusMasterInterface: #BSM prefix: #CORE_.
	instructionCacheBus createControllerWithBuilder: builder.
		
	dataCache := builder instance: (BeaconSlowCPUCache new
		name: #BeaconSlowCPUDataCache;
		size: dataCacheSize;
		component).
	dataCacheBus := dataCache memoryBusMasterInterface: #BSM prefix: #CORE_.
	dataCacheBus createControllerWithBuilder: builder.

	cacheMemoryBusMux := builder instance: (BeaconSlowCPUCacheMemoryMux new component).
	(cacheMemoryBusMux memoryBusMasterInterface: #BSM prefix: #MAIN_) connectWith: memoryBus.
	(instructionCache memoryBusMasterInterface: #BSM prefix: #MAIN_) connectWith: (cacheMemoryBusMux memoryBusSlaveInterface: #BSM prefix: #INSTRUCTION_).
	(dataCache memoryBusMasterInterface: #BSM prefix: #MAIN_) connectWith: (cacheMemoryBusMux memoryBusSlaveInterface: #BSM prefix: #DATA_).

]

{ #category : #'state machine' }
BeaconSlowCPU >> createFetchState [
	| instructionFullData |
	instructionAddress := builder register: 64.
	instructionFullData := builder register: 64.
	instructionData := (instructionAddress bit: 3)
		ifTrue: (instructionFullData bit: 33 count: 32)
		ifFalse: (instructionFullData bit: 1 count: 32).
	
	stateMachine 
		state: #fetchWait do: { 
		};
		state: #fetch do: {
			instructionAddress <== pc.
			stateMachine <== #fetchWait.
			instructionCacheBus read: (pc alignedDownTo: 4) into: instructionFullData whenFinishedDo: {
				stateMachine <== #decode.
			}.
		}.
		
]

{ #category : #building }
BeaconSlowCPU >> createIOPorts [
	memoryBus := builder memoryBusMasterInterface: memoryInterfaceType.
	memoryBus createPortsWithoutController.
]

{ #category : #'state machine' }
BeaconSlowCPU >> dataBus [
	^ dataCacheBus
]

{ #category : #initialization }
BeaconSlowCPU >> initialize [
	super initialize.
	instructionCacheSize := 4096.
	dataCacheSize := 4096.
]
