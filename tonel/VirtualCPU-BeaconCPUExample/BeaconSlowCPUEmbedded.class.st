Class {
	#name : #BeaconSlowCPUEmbedded,
	#superclass : #BeaconSlowCPUNoCache,
	#instVars : [
		'instructionMemory'
	],
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'VirtualCPU-BeaconCPUExample-SlowCPU'
}

{ #category : #building }
BeaconSlowCPUEmbedded >> createIOPorts [
	memoryBus := builder memoryBusMasterInterface: memoryInterfaceType.
	memoryBus createPortsWithController.
]

{ #category : #'state machine' }
BeaconSlowCPUEmbedded >> dataBus [
	^ memoryBus
]

{ #category : #accessing }
BeaconSlowCPUEmbedded >> instructionMemory [
	^ instructionMemory
]

{ #category : #accessing }
BeaconSlowCPUEmbedded >> instructionMemory: anObject [
	instructionMemory := anObject
]
