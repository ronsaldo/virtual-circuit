Class {
	#name : #BeaconIntRegister,
	#superclass : #BeaconRegister,
	#category : #'BeaconCPU-Core-ISA'
}

{ #category : #converting }
BeaconIntRegister >> asVCElementFor: owner [
	^ VCConstantInteger new owner: owner;
		value: value;
		bits: 5;
		yourself
]

{ #category : #printing }
BeaconIntRegister >> size [
	^ 8
]
