/*
 * Copyright (c) 2015, Nordic Semiconductor
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "GlucoseReadingContext.h"
#import "GlucoseReading.h"
#import "CharacteristicReader.h"

@implementation GlucoseReadingContext

+ (GlucoseReadingContext *)readingContextFromBytes:(uint8_t *)bytes
{
    GlucoseReadingContext* context = [GlucoseReadingContext alloc];
    [context updateFromBytes:bytes];
    return context;
}

- (void)updateFromBytes:(uint8_t *)bytes
{
    uint8_t* pointer = bytes;
    
    // Parse flags
    UInt8 flags = [CharacteristicReader readUInt8Value:&pointer];
    BOOL carbohydrateIdPresent = (flags & 0x01) > 0;
    BOOL mealPresent = (flags & 0x02) > 0;
    BOOL testerAndHelathPresent = (flags & 0x04) > 0;
    BOOL exerciseInfoPresent = (flags & 0x08) > 0;
    BOOL medicationPresent = (flags & 0x10) > 0;
    BgmMedicationUnit medicationUnit = (flags & 0x20) >> 5;
    BOOL HbA1cPresent = (flags & 0x40) > 0;
    BOOL extendedFlags = (flags & 0x80) > 0;
    
    // Sequence number is used to match the reading with the glucose measurement
    self.sequenceNumber = [CharacteristicReader readUInt16Value:&pointer];
    
    if (extendedFlags)
    {
        pointer++; // skip Extended Flags, not supported
    }
    
    self.carbohydratePresent = carbohydrateIdPresent;
    if (carbohydrateIdPresent)
    {
        self.carbohydrateId = [CharacteristicReader readUInt8Value:&pointer];
        self.carbohydrate = [CharacteristicReader readSFloatValue:&pointer] / 1000;
    }
    
    self.mealPresent = mealPresent;
    if (mealPresent)
    {
        self.meal = [CharacteristicReader readUInt8Value:&pointer];
    }
    
    self.testerAndHealthPresent = testerAndHelathPresent;
    if (testerAndHelathPresent)
    {
        Nibble nibble = [CharacteristicReader readNibble:&pointer];
        self.tester = nibble.first;
        self.health = nibble.second;
    }
    
    self.exercisePresent = exerciseInfoPresent;
    if (exerciseInfoPresent)
    {
        self.exerciseDuration = [CharacteristicReader readUInt16Value:&pointer];
        self.exerciseIntensity = [CharacteristicReader readUInt8Value:&pointer];
    }
    
    self.medicationPresent = medicationPresent;
    if (medicationPresent)
    {
        self.medicationId = [CharacteristicReader readUInt8Value:&pointer];
        self.medication = [CharacteristicReader readSFloatValue:&pointer] / 1000000;
        self.medicationUnit = medicationUnit;
    }
    
    self.HbA1cPresent = HbA1cPresent;
    if (HbA1cPresent)
    {
        self.HbA1c = [CharacteristicReader readSFloatValue:&pointer];
    }
}

- (NSString *)carbohydrateIdAsString
{
    switch (self.carbohydrateId) {
        case BREAKFEST:
            return @"BREAKFEST";
        case BRUNCH:
            return @"BRUNCH";
        case DINNER:
            return @"DINNER";
        case DRINK:
            return @"DRINK";
        case LUNCH:
            return @"LUNCH";
        case SNACK:
            return @"SNACK";
        case SUPPER:
            return @"SUPPER";
        default:
            return [NSString stringWithFormat:@"RESERVED: %d", self.carbohydrateId];
    }
}

-(NSString *)mealIdAsString
{
    switch (self.meal) {
        case BEDTIME:
            return @"BEDTIME";
        case CASUAL:
            return @"CASUAL";
        case FASTING:
            return @"FASTING";
        case POSTPRANDIAL:
            return @"POSTPRANDIAL";
        case PREPRANDIAL:
            return @"PREPRANDIAL";
        default:
            return [NSString stringWithFormat:@"RESERVED: %d", self.meal];
    }
}

- (NSString *)testerAsString
{
    switch (self.tester) {
        case HEALTH_CARE_PROFESSIONAL:
            return @"HEALTH CARE PROF.";
        case LAB_TEST:
            return @"LAB TEST";
        case SELF:
            return @"SELF";
        case TESTER_NOT_AVAILABLE:
            return @"NOT AVAILABLE";
        default:
            return [NSString stringWithFormat:@"RESERVED: %d", self.tester];
    }
}

- (NSString *)healthAsString
{
    switch (self.health) {
        case DURING_MENSES:
            return @"HEALTH CARE PROF.";
        case MINOR_HEALTH_ISSUES:
            return @"MINOR HEALTH ISSUES";
        case MAJOR_HEALTH_ISSUES:
            return @"MAJOR HEALTH ISSUES";
        case UNDER_STRESS:
            return @"UNDER STRESS";
        case NO_HEALTH_ISSUES:
            return @"NO HEALTH ISSUES";
        case HEALTH_NOT_AVAILABLE:
            return @"NOT AVAILABLE";
        default:
            return [NSString stringWithFormat:@"RESERVED: %d", self.health];
    }
}

-(NSString *)medicationIdAsString
{
    
    switch (self.medicationId) {
        case INTERMEDIATE_ACTING_INSULIN:
            return @"INTERMEDIATE ACTING INSULIN";
        case LONG_ACTING_INSULINE:
            return @"LONG ACTING INSULIN";
        case PRE_MIXED_INSULINE:
            return @"PRE MIXED INSULINE";
        case RAPID_ACTING_INSULIN:
            return @"RAPID ACTING INSULINE";
        case SHORT_ACTING_INSULIN:
            return @"SHORT ACTING INSULINE";
        default:
            return [NSString stringWithFormat:@"RESERVED: %d", self.medicationId];
    }
}

-(BOOL)isEqual:(id)object
{
    // The context class is compared to the reading while searching for rading with its sequence number
    GlucoseReading* reading = (GlucoseReading*) object;
    return self.sequenceNumber == reading.sequenceNumber;
}

@end
