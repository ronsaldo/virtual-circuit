Class {
	#name : #SAsmBeaconCallingConvention,
	#superclass : #SAsmCallingConvention,
	#category : #'BeaconCPU-Core-ISA'
}

{ #category : #stack }
SAsmBeaconCallingConvention >> stackAlignment [
	^ 16
]
