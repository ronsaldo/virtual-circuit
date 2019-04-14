Class {
	#name : #BeaconCPUSpecialRegister,
	#superclass : #Object,
	#instVars : [
		'index',
		'register',
		'readPermission',
		'writePermission'
	],
	#category : #'VirtualCircuit-BeaconCPUExample-SlowCPU'
}

{ #category : #accessing }
BeaconCPUSpecialRegister >> index [
	^ index
]

{ #category : #accessing }
BeaconCPUSpecialRegister >> index: anObject [
	index := anObject
]

{ #category : #initialization }
BeaconCPUSpecialRegister >> initialize [
	super initialize.
	readPermission := true.
	writePermission := true.
]

{ #category : #'as yet unclassified' }
BeaconCPUSpecialRegister >> readInto: targetRegister [
	^ targetRegister <== register 
]

{ #category : #accessing }
BeaconCPUSpecialRegister >> readPermission [
	^ readPermission
]

{ #category : #accessing }
BeaconCPUSpecialRegister >> readPermission: anObject [
	readPermission := anObject
]

{ #category : #accessing }
BeaconCPUSpecialRegister >> register [
	^ register
]

{ #category : #accessing }
BeaconCPUSpecialRegister >> register: anObject [
	register := anObject
]

{ #category : #writing }
BeaconCPUSpecialRegister >> write: value [
	^ register <== value
]

{ #category : #accessing }
BeaconCPUSpecialRegister >> writePermission [
	^ writePermission
]

{ #category : #accessing }
BeaconCPUSpecialRegister >> writePermission: anObject [
	writePermission := anObject
]
