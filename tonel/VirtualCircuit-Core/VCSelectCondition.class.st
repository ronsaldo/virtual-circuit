Class {
	#name : #VCSelectCondition,
	#superclass : #VCExpression,
	#instVars : [
		'condition',
		'falseValue',
		'trueValue'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
VCSelectCondition >> accept: aVisitor [
	^ aVisitor visitSelectCondition: self.
]

{ #category : #accessing }
VCSelectCondition >> condition [
	^ condition
]

{ #category : #accessing }
VCSelectCondition >> condition: anObject [
	condition := anObject
]

{ #category : #accessing }
VCSelectCondition >> falseValue [
	^ falseValue
]

{ #category : #accessing }
VCSelectCondition >> falseValue: anObject [
	falseValue := anObject
]

{ #category : #accessing }
VCSelectCondition >> trueValue [
	^ trueValue
]

{ #category : #accessing }
VCSelectCondition >> trueValue: anObject [
	trueValue := anObject
]
