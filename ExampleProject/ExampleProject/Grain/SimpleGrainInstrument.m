//
//  SimpleGrainInstrument.m
//  ExampleProject
//
//  Created by Adam Boulanger on 6/21/12.
//  Copyright (c) 2012 Hear For Yourself. All rights reserved.
//

#import "SimpleGrainInstrument.h"

@implementation SimpleGrainInstrument

-(id)initWithOrchestra:(OCSOrchestra *)newOrchestra
{
    self = [super initWithOrchestra:newOrchestra];
    if (self) {
        
        // INPUTS AND CONTROLS =================================================
        
        // INSTRUMENT DEFINITION ===============================================
        NSString * file = [[NSBundle mainBundle] pathForResource:@"beats" ofType:@"wav"];
        OCSSoundFileTable *fileTable = [[OCSSoundFileTable alloc] initWithFilename:file TableSize:16384];
        [self addFunctionTable:fileTable];
        
        
        OCSFunctionTable *hamming = [[OCSWindowsTable alloc] initWithSize:512 
                                                               WindowType:kWindowHanning];
        [self addFunctionTable:hamming];
    
        OCSFileLength * fileLength = [[OCSFileLength alloc] initWithInput:fileTable];
        [self addOpcode:fileLength];
        
        OCSParamConstant * baseFreq = [OCSParamConstant paramWithFormat:@"44100 / %@", fileLength];
        
        OCSParamArray * amplitudeSegmentArray = 
            [OCSParamArray paramArrayFromParams:[OCSParamConstant paramWithFormat:@"%@ / 2", duration],
                                                [OCSParamConstant paramWithFloat:0.01], nil];
        
        OCSExpSegment *amplitudeExp = 
        [[OCSExpSegment alloc] initWithFirstSegmentStartValue:[OCSParamConstant paramWithFloat:0.001f] 
                                         FirstSegmentDuration:[OCSParamConstant paramWithFormat:@"%@ / 2", duration]
                                     FirstSegementTargetValue:[OCSParamConstant paramWithFloat:0.1f]
                                                 SegmentArray:amplitudeSegmentArray];
        [self addOpcode:amplitudeExp];

        OCSLine * pitchLine = 
        [[OCSLine alloc] initWithStartingValue:baseFreq 
                                      Duration:duration 
                                   TargetValue:[OCSParamConstant paramWithFormat:@"0.8 * (%@)", baseFreq]];
        [self addOpcode:pitchLine];
        
        OCSLine * grainDensityLine = 
        [[OCSLine alloc] initWithStartingValue:[OCSParamConstant paramWithInt:600] 
                                      Duration:duration 
                                   TargetValue:[OCSParamConstant paramWithInt:300]];
        [self addOpcode:grainDensityLine];
        
        OCSLine * ampOffsetLine = 
        [[OCSLine alloc] initWithStartingValue:[OCSParamConstant paramWithInt:0] 
                                      Duration:duration 
                                   TargetValue:[OCSParamConstant paramWithFloat:0.1]];
        [self addOpcode:ampOffsetLine];
        
        OCSLine * pitchOffsetLine = 
        [[OCSLine alloc] initWithStartingValue:[OCSParamConstant paramWithInt:0] 
                                      Duration:duration 
                                   TargetValue:[OCSParamConstant paramWithFormat:@"0.5 * (%@)", baseFreq]];
        [self addOpcode:pitchOffsetLine];   
        
        OCSLine * grainDurationLine = 
        [[OCSLine alloc] initWithStartingValue:[OCSParamConstant paramWithFloat:0.1] 
                                      Duration:duration 
                                   TargetValue:[OCSParamConstant paramWithFloat:0.1f]];
        [self addOpcode:grainDurationLine];
        
        OCSGrain * grainL = 
        [[OCSGrain alloc] initWithAmplitude:[amplitudeExp output] 
                                      pitch:[pitchLine output]
                               grainDensity:[grainDensityLine output]
                            amplitudeOffset:[ampOffsetLine output]
                                pitchOffset:[pitchOffsetLine output] 
                              grainDuration:[grainDurationLine output]  
                           maxGrainDuration:[OCSParamConstant paramWithInt:5] 
                              grainFunction:fileTable 
                             windowFunction:hamming 
                 isRandomGrainFunctionIndex:NO];
        [self addOpcode:grainL];
        
        OCSGrain * grainR = 
        [[OCSGrain alloc] initWithAmplitude:[amplitudeExp output] 
                                      pitch:[pitchLine output]
                               grainDensity:[grainDensityLine output]
                            amplitudeOffset:[ampOffsetLine output]
                                pitchOffset:[pitchOffsetLine output] 
                              grainDuration:[grainDurationLine output]  
                           maxGrainDuration:[OCSParamConstant paramWithInt:5] 
                              grainFunction:fileTable 
                             windowFunction:hamming 
                 isRandomGrainFunctionIndex:NO];
        [self addOpcode:grainR];
        
        // AUDIO OUTPUT ========================================================
        
        OCSOutputStereo *stereoOutput = 
        [[OCSOutputStereo alloc] initWithInputLeft:[grainL output] 
                                        InputRight:[grainR output]]; 
        [self addOpcode:stereoOutput];
    }
    return self;
}


@end
