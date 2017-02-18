Class {
	#name : #BeaconSlowCPUCacheMemoryMux,
	#superclass : #VCComplexComponentDefinition,
	#instVars : [
		'memoryInterfaceType',
		'memoryBus',
		'instructionCacheBus',
		'dataCacheBus'
	],
	#category : #'BeaconCPU-Core-SlowCPU'
}

{ #category : #building }
BeaconSlowCPUCacheMemoryMux >> build [
	builder autoClock; autoReset.
	
	self
		createIOPorts
]

{ #category : #building }
BeaconSlowCPUCacheMemoryMux >> createIOPorts [
	memoryBus := builder memoryBusMasterInterface: memoryInterfaceType prefix: #MAIN_.
	memoryBus createPortsWithController.
	
	instructionCacheBus := builder memoryBusSlaveInterface: memoryInterfaceType prefix: #INSTRUCTION_.
	instructionCacheBus createPortsWithController.
	
	dataCacheBus := builder memoryBusSlaveInterface: memoryInterfaceType prefix: #DATA_.
	dataCacheBus createPortsWithController.
]

{ #category : #initialization }
BeaconSlowCPUCacheMemoryMux >> initialize [
	super initialize.
	memoryInterfaceType := #BSM.
]
