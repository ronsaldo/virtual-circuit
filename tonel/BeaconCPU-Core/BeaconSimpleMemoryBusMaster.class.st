Class {
	#name : #BeaconSimpleMemoryBusMaster,
	#superclass : #VCAXI4LiteMemoryBusMaster,
	#category : #'BeaconCPU-Core-SlowCPU'
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
