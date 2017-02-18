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

{ #category : #'as yet unclassified' }
VCPin >> connectWith: anotherPin [ 
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
VCPin >> connectWithSinkPin: sinkPin [
	sinkPin value: self.
]

{ #category : #'as yet unclassified' }
VCPin >> connectWithSourcePin: sourcePin [
	self value: sourcePin.
]

{ #category : #testing }
VCPin >> isInput [
	^ false
]

{ #category : #testing }
VCPin >> isOutput [
	^ false
]

{ #category : #'as yet unclassified' }
VCPin >> localPrefix [
	^ '_pin'
]
