Class {
	#name : #BeaconSimpleMemoryBusMaster,
	#superclass : #VCAXI4LiteMemoryBusMaster,
	#category : #'VirtualCircuit-BeaconCPUExample-SlowCPU'
}

{ #category : #'as yet unclassified' }
BeaconSimpleMemoryBusMaster class >> interfaceName [
	^ #BSM
]

{ #category : #initialization }
BeaconSimpleMemoryBusMaster >> initialize [
	super initialize.
	addressBusSize := 64.
	dataBusSize := 64.
]
