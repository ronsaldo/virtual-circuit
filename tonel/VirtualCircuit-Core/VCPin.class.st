Class {
	#name : #VCPin,
	#superclass : #VCVariable,
	#instVars : [
		'component'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #converting }
VCPin >> asInstancePin [
	^ self subclassResponsibility
]

{ #category : #accessing }
VCPin >> component [
	^ component
]

{ #category : #accessing }
VCPin >> component: anObject [
	component := anObject
]

{ #category : #testing }
VCPin >> isInput [
	^ false
]

{ #category : #testing }
VCPin >> isOutput [
	^ false
]
