//
//  AKTanhDistortion.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

/**  */
public class AKTanhDistortion: AKNode {

    // MARK: - Properties

    private var internalAU: AKTanhDistortionAudioUnit?
    private var token: AUParameterObserverToken?

    private var pregainParameter: AUParameter?
    private var postgainParameter: AUParameter?
    private var postiveShapeParameterParameter: AUParameter?
    private var negativeShapeParameterParameter: AUParameter?

    /** Determines the amount of gain applied to the signal before waveshaping. A value
     of 1 gives slight distortion. */
    public var pregain: Float = 2.0 {
        didSet {
            pregainParameter?.setValue(pregain, originator: token!)
        }
    }
    /** Gain applied after waveshaping */
    public var postgain: Float = 0.5 {
        didSet {
            postgainParameter?.setValue(postgain, originator: token!)
        }
    }
    /** Shape of the positive part of the signal. A value of 0 gets a flat clip. */
    public var postiveShapeParameter: Float = 0.0 {
        didSet {
            postiveShapeParameterParameter?.setValue(postiveShapeParameter, originator: token!)
        }
    }
    /** Like the positive shape parameter, only for the negative part. */
    public var negativeShapeParameter: Float = 0.0 {
        didSet {
            negativeShapeParameterParameter?.setValue(negativeShapeParameter, originator: token!)
        }
    }

    // MARK: - Initializers

    /** Initialize this distortion node */
    public init(
        _ input: AKNode,
        pregain: Float = 2.0,
        postgain: Float = 0.5,
        postiveShapeParameter: Float = 0.0,
        negativeShapeParameter: Float = 0.0) {

        self.pregain = pregain
        self.postgain = postgain
        self.postiveShapeParameter = postiveShapeParameter
        self.negativeShapeParameter = negativeShapeParameter
        super.init()

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Effect
        description.componentSubType      = 0x64697374 /*'dist'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKTanhDistortionAudioUnit.self,
            asComponentDescription: description,
            name: "Local AKTanhDistortion",
            version: UInt32.max)

        AVAudioUnit.instantiateWithComponentDescription(description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitEffect = avAudioUnit else { return }

            self.output = avAudioUnitEffect
            self.internalAU = avAudioUnitEffect.AUAudioUnit as? AKTanhDistortionAudioUnit
            AKManager.sharedInstance.engine.attachNode(self.output!)
            AKManager.sharedInstance.engine.connect(input.output!, to: self.output!, format: AKManager.format)
        }

        guard let tree = internalAU?.parameterTree else { return }

        pregainParameter                = tree.valueForKey("pregain")                as? AUParameter
        postgainParameter               = tree.valueForKey("postgain")               as? AUParameter
        postiveShapeParameterParameter  = tree.valueForKey("postiveShapeParameter")  as? AUParameter
        negativeShapeParameterParameter = tree.valueForKey("negativeShapeParameter") as? AUParameter

        token = tree.tokenByAddingParameterObserver {
            address, value in

            dispatch_async(dispatch_get_main_queue()) {
                if address == self.pregainParameter!.address {
                    self.pregain = value
                } else if address == self.postgainParameter!.address {
                    self.postgain = value
                } else if address == self.postiveShapeParameterParameter!.address {
                    self.postiveShapeParameter = value
                } else if address == self.negativeShapeParameterParameter!.address {
                    self.negativeShapeParameter = value
                }
            }
        }

        pregainParameter?.setValue(pregain, originator: token!)
        postgainParameter?.setValue(postgain, originator: token!)
        postiveShapeParameterParameter?.setValue(postiveShapeParameter, originator: token!)
        negativeShapeParameterParameter?.setValue(negativeShapeParameter, originator: token!)

    }
}
