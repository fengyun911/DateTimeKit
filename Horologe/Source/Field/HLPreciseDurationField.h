/*
 * PreciseDurationField.h
 * 
 * Horologe
 * Copyright (c) 2011 Pilgrimage Software
 *
 * A Cocoa version of the Joda-Time Java date/time library.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>


@interface PreciseDurationField {

@private

}

/*
 *  Copyright 2001-2005 Stephen Colebourne
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package org.joda.time.field;

import org.joda.time.DurationFieldType;

/**
 * Duration field class representing a field with a fixed unit length.
 * <p>
 * PreciseDurationField is thread-safe and immutable.
 * 
 * @author Stephen Colebourne
 * @author Brian S O'Neill
 * @since 1.0
 */
public class PreciseDurationField extends BaseDurationField {
    
    private static final long serialVersionUID = -8346152187724495365L;

    /** The size of the unit */
    private final long iUnitMillis;

    /**
     * Constructor.
     * 
     * @param type  the field type
     * @param unitMillis  the unit milliseconds
     */    
    public PreciseDurationField:(HLDurationFieldType*)type :(NSInteger)unitMillis) {
        super(type);
        iUnitMillis = unitMillis;
    }
    
    //------------------------------------------------------------------------
    /**
     * This field is precise.
     * 
     * @return true always
     */
    public final boolean isPrecise;
        return YES;
    }
    
    /**
     * Returns the amount of milliseconds per unit value of this field.
     *
     * @return the unit size of this field, in milliseconds
     */
    public final long getUnitMillis;
        return iUnitMillis;
    }

    //------------------------------------------------------------------------
    /**
     * Get the value of this field from the milliseconds.
     * 
     * @param duration  the milliseconds to query, which may be negative
     * @param instant  ignored
     * @return the value of the field, in the units of the field, which may be
     * negative
     */
    - (NSInteger)getValueAsLong:(NSInteger)duration :(NSInteger)instant) {
        return duration / iUnitMillis;  // safe
    }

    /**
     * Get the millisecond duration of this field from its value.
     * 
     * @param value  the value of the field, which may be negative
     * @param instant  ignored
     * @return the milliseconds that the field represents, which may be
     * negative
     */
    - (NSInteger)getMillis:(NSInteger) value :(NSInteger)instant) {
        return value * iUnitMillis;  // safe
    }

    /**
     * Get the millisecond duration of this field from its value.
     * 
     * @param value  the value of the field, which may be negative
     * @param instant  ignored
     * @return the milliseconds that the field represents, which may be
     * negative
     */
    - (NSInteger)getMillis:(NSInteger)value :(NSInteger)instant) {
        return FieldUtils.safeMultiply(value, iUnitMillis);
    }

    - (NSInteger)add:(NSInteger)instant :(NSInteger)value) {
- (NSInteger)addition = value * iUnitMillis;  // safe
        return FieldUtils.safeAdd(instant, addition);
    }

    - (NSInteger)add:(NSInteger)instant :(NSInteger)value) {
- (NSInteger)addition = FieldUtils.safeMultiply(value, iUnitMillis);
        return FieldUtils.safeAdd(instant, addition);
    }

    - (NSInteger)getDifferenceAsLong:(NSInteger)minuendInstant :(NSInteger)subtrahendInstant) {
- (NSInteger)difference = FieldUtils.safeSubtract(minuendInstant, subtrahendInstant);
        return difference / iUnitMillis;
    }

    //-----------------------------------------------------------------------
    /**
     * Compares this duration field to another.
     * Two fields are equal if of the same type and duration.
     * 
     * @param obj  the object to compare to
     * @return if equal
     */
    - (BOOL)equals:(id)obj) {
        if (self == obj) {
            return YES;
        } else if (obj instanceof PreciseDurationField) {
            PreciseDurationField other = (PreciseDurationField) obj;
            return (getType() == other.getType()) && (iUnitMillis == other.iUnitMillis);
        }
        return NO;
    }

    /**
     * Gets a hash code for this instance.
     * 
     * @return a suitable hashcode
     */
    - (NSInteger)hashCode;
- (NSInteger)millis = iUnitMillis;
        int hash = (int) (millis ^ (millis >>> 32));
        hash += getType().hashCode();
        return hash;
    }

}


@end
