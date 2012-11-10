//
//  EffectsProcessor.m
//  Objective-C Sound Example
//
//  Created by Aurelius Prochazka on 6/9/12.
//  Copyright (c) 2012 Hear For Yourself. All rights reserved.
//

#import "EffectsProcessor.h"
#import "OCSReverb.h"
#import "OCSAudioOutput.h"

@implementation EffectsProcessor

- (id)initWithToneGenerator:(ToneGenerator *)toneGenerator
{
    self = [super init];
    if (self) {                  
        
        // INPUTS ==============================================================
        
        OCSAudio *sourceAudio = toneGenerator.auxilliaryOutput;
        
        // INSTRUMENT DEFINITION ===============================================
        
        OCSReverb * reverb = [[OCSReverb alloc] initWithSourceAudio:sourceAudio
                                                      feedbackLevel:ocsp(0.8)
                                                    cutoffFrequency:ocsp(12000)];
        [self connect:reverb];
        
        // AUDIO OUTPUT ========================================================
            
        OCSAudioOutput *audio = [[OCSAudioOutput alloc] initWithStereoInput:[reverb scaledBy:0.2] ];
        [self connect:audio];
        
        // RESET INPUTS ========================================================
        [self resetParam:sourceAudio];
    }
    return self;
}

@end
