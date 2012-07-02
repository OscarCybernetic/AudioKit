//
//  OCSEnvelope.m
//
//  Created by Aurelius Prochazka on 5/17/12.
//  Copyright (c) 2012 Hear For Yourself. All rights reserved.
//

#import "OCSLinearEnvelope.h"

@interface OCSLinearEnvelope () {
    OCSParam *amp;
    OCSConstantParam *rise;
    OCSConstantParam *dur;
    OCSConstantParam *decay;    
}

@end

@implementation OCSLinearEnvelope


@synthesize audio;
@synthesize control;
@synthesize output;

- (id)initWithRiseTime:(OCSConstantParam *)riseTime
         totalDuration:(OCSConstantParam *)totalDuration
             decayTime:(OCSConstantParam *)decayTime
             amplitude:(OCSParam *)amplitude
{
    self = [super init];
    if (self) {
        audio   = [OCSParam paramWithString:[self opcodeName]];
        control = [OCSControlParam paramWithString:[self opcodeName]];
        output  =  audio;
        amp     = amplitude;
        rise    = riseTime;
        dur     = totalDuration;
        decay   = decayTime;
    }
    return self; 
}


- (NSString *)stringForCSD {
    return [NSString stringWithFormat:
            @"%@ linen %@, %@, %@, %@",
            output, amp, rise, dur, decay];
}

/// Gives the CSD string for the output parameter.  
- (NSString *)description {
    return [output parameterString];
}

@end
