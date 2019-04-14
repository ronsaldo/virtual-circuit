Class {
	#name : #BeaconSimpleMemoryBusSlave,
	#superclass : #VCAXI4LiteMemoryBusSlave,
	#category : #'VirtualCircuit-BeaconCPUExample-SlowCPU'
}

{ #category : #'as yet unclassified' }
BeaconSimpleMemoryBusSlave class >> interfaceName [
	^ #BSM
]

{ #category : #initialization }
BeaconSimpleMemoryBusSlave >> initialize [
	super initialize.
	self
		addressBusSize: 64;
		dataBusSize: 64.
]
