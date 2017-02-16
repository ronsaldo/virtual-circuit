Class {
	#name : #BeaconRegister,
	#superclass : #SAsmRegister,
	#instVars : [
		'name',
		'value'
	],
	#category : #'BeaconCPU-Core'
}

{ #category : #printing }
BeaconRegister >> fullPrintOn: aStream [
	aStream putKeyword: name
]

{ #category : #accessing }
BeaconRegister >> name [
	^ name
]

{ #category : #accessing }
BeaconRegister >> name: anObject [
	name := anObject
]

{ #category : #printing }
BeaconRegister >> printOn: aStream [
	aStream nextPutAll: name
]

{ #category : #printing }
BeaconRegister >> size [
	^ self subclassResponsibility
]

{ #category : #accessing }
BeaconRegister >> value [
	^ value
]

{ #category : #accessing }
BeaconRegister >> value: anObject [
	value := anObject
]
