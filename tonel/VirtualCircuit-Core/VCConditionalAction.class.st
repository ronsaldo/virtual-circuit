Class {
	#name : #VCConditionalAction,
	#superclass : #VCSequentialAction,
	#instVars : [
		'condition',
		'trueAction',
		'falseAction'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #accessing }
VCConditionalAction >> condition [
	^ condition
]

{ #category : #accessing }
VCConditionalAction >> condition: anObject [
	condition := anObject
]

{ #category : #accessing }
VCConditionalAction >> falseAction [
	^ falseAction
]

{ #category : #accessing }
VCConditionalAction >> falseAction: anObject [
	falseAction := anObject
]

{ #category : #accessing }
VCConditionalAction >> on: extraCondition applyInComponent: component [
	| composedCondition |
	composedCondition := condition & extraCondition.
	trueAction on: composedCondition applyInComponent: component.
	falseAction on: composedCondition not applyInComponent: component.
]

{ #category : #accessing }
VCConditionalAction >> trueAction [
	^ trueAction
]

{ #category : #accessing }
VCConditionalAction >> trueAction: anObject [
	trueAction := anObject
]