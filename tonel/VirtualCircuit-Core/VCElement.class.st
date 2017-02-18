Class {
	#name : #VCElement,
	#superclass : #Object,
	#instVars : [
		'name',
		'owner'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visualization }
VCElement >> addRoassalEdgesFrom: element toView: view [
]

{ #category : #converting }
VCElement >> asVCElementFor: anOwner [
	^ self
]

{ #category : #converting }
VCElement >> asVCElementFor: anOwner bits: bitCount [
	^ self
]

{ #category : #testing }
VCElement >> hasReset [
	^ false
]

{ #category : #testing }
VCElement >> isComponent [
	^ false
]

{ #category : #testing }
VCElement >> isComponentInstance [
	^ false
]

{ #category : #testing }
VCElement >> isExpression [
	^ false
]

{ #category : #testing }
VCElement >> isRegister [
	^ false
]

{ #category : #testing }
VCElement >> isResetActiveHigh [
	^ false
]

{ #category : #testing }
VCElement >> isResetActiveLow [
	^ true
]

{ #category : #testing }
VCElement >> isVariable [
	^ false
]

{ #category : #testing }
VCElement >> isVirtualCircuitElement [
	^ true
]

{ #category : #'as yet unclassified' }
VCElement >> localPrefix [
	^ '_local'
]

{ #category : #accessing }
VCElement >> name [
	^ name
]

{ #category : #accessing }
VCElement >> name: anObject [
	name := anObject
]

{ #category : #testing }
VCElement >> needsClock [
	^ false
]

{ #category : #accessing }
VCElement >> owner [
	^ owner
]

{ #category : #accessing }
VCElement >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
VCElement >> printableName [
	^ name ifNil: [ '' ]
]

{ #category : #visualization }
VCElement >> roassalElementForView: aView [
	| rtElement shape |
	shape := RTCompositeShape new.
	shape add: (RTEllipse new).
	shape add: (RTLabel new text: #printableName).
	shape vertical.

	rtElement := shape elementOn: self.
	aView add: rtElement.
	^ rtElement
]
