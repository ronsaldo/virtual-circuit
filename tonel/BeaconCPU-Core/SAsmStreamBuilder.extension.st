Extension { #name : #SAsmStreamBuilder }

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: opcode [
	^ self beacon: opcode withOperands: #()
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: opcode into: result base: base disp: disp [
	^ self beacon: opcode with: result with: base with: disp
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: opcode into: result disp: disp [
	^ self beacon: opcode into: result base: BeaconCPUISA R0 disp: disp
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: opcode value: value base: base disp: disp [
	^ self beacon: opcode with: value with: base with: disp
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: opcode value: value disp: disp [
	^ self beacon: opcode value: value base: BeaconCPUISA R0 disp: disp
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: opcode with: dest with: rl [
	^ self beacon: opcode withOperands: { dest asSAsmInstructionOperand . rl asSAsmInstructionOperand}
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: opcode with: dest with: rl with: rr [
	^ self beacon: opcode withOperands: { dest asSAsmInstructionOperand . rl asSAsmInstructionOperand . rr asSAsmInstructionOperand}
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: operation withOperands: operands [
	^ self add: (
		SAsmInstruction new
			template: operation;
			arguments: operands;
			validate;
			yourself)
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beaconMove: source to: target [
	^ self beacon: BeaconCPUISA add with: target asSAsmInstructionOperand with: BeaconCPUISA R0 with: source asSAsmInstructionOperand
]
