/*
 * ScaledDurationField.m
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

#import "ScaledDurationField.h"


@implementation ScaledDurationField

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

import org.joda.time.DurationField;
import org.joda.time.DurationFieldType;

/**
 * Scales a DurationField such that it's unit millis becomes larger in
 * magnitude.
 * <p>
 * ScaledDurationField is thread-safe and immutable.
 *
 * @see PreciseDurationField
 *
 * @author Brian S O'Neill
 * @since 1.0
 */
public class ScaledDurationField extends DecoratedDurationField {

    private static final long serialVersionUID = -3205227092378684157L;

    private final int iScalar;

    /**
     * Constructor
     * 
     * @param field  the field to wrap, like "year()".
     * @param type  the type this field will actually use
     * @param scalar  scalar, such as 100 years in a century
     * @throws IllegalArgumentException if scalar is zero or one.
     */
    public ScaledDurationField(DurationField field, DurationFieldType type :(NSInteger)scalar) {
        super(field, type);
        if (scalar == 0 || scalar == 1) {
            [NSException raise:HL_ILLEGAL_ARGUMENT_EXCEPTION
                    format:@"The scalar must not be 0 or 1"];
        }
        iScalar = scalar;
    }

    - (NSInteger)getValue:(NSInteger)duration) {
        return getWrappedField().getValue(duration) / iScalar;
    }

    - (NSInteger)getValueAsLong:(NSInteger)duration) {
        return getWrappedField().getValueAsLong(duration) / iScalar;
    }

    - (NSInteger)getValue:(NSInteger)duration :(NSInteger)instant) {
        return getWrappedField().getValue(duration, instant) / iScalar;
    }

    - (NSInteger)getValueAsLong:(NSInteger)duration :(NSInteger)instant) {
        return getWrappedField().getValueAsLong(duration, instant) / iScalar;
    }

    - (NSInteger)getMillis:(NSInteger) value) {
- (NSInteger)scaled = ((long) value) * ((long) iScalar);
        return getWrappedField().getMillis(scaled);
    }

    - (NSInteger)getMillis:(NSInteger)value) {
- (NSInteger)scaled = FieldUtils.safeMultiply(value, iScalar);
        return getWrappedField().getMillis(scaled);
    }

    - (NSInteger)getMillis:(NSInteger) value :(NSInteger)instant) {
- (NSInteger)scaled = ((long) value) * ((long) iScalar);
        return getWrappedField().getMillis(scaled, instant);
    }

    - (NSInteger)getMillis:(NSInteger)value :(NSInteger)instant) {
- (NSInteger)scaled = FieldUtils.safeMultiply(value, iScalar);
        return getWrappedField().getMillis(scaled, instant);
    }

    - (NSInteger)add:(NSInteger)instant :(NSInteger)value) {
- (NSInteger)scaled = ((long) value) * ((long) iScalar);
        return getWrappedField().add(instant, scaled);
    }

    - (NSInteger)add:(NSInteger)instant :(NSInteger)value) {
- (NSInteger)scaled = FieldUtils.safeMultiply(value, iScalar);
        return getWrappedField().add(instant, scaled);
    }

    - (NSInteger)getDifference:(NSInteger)minuendInstant :(NSInteger)subtrahendInstant) {
        return getWrappedField().getDifference(minuendInstant, subtrahendInstant) / iScalar;
    }

    - (NSInteger)getDifferenceAsLong:(NSInteger)minuendInstant :(NSInteger)subtrahendInstant) {
        return getWrappedField().getDifferenceAsLong(minuendInstant, subtrahendInstant) / iScalar;
    }

    - (NSInteger)getUnitMillis {
        return getWrappedField().getUnitMillis() * iScalar;
    }

    //-----------------------------------------------------------------------
    /**
     * Returns the scalar applied, in the field's units.
     * 
     * @return the scalar
     */
    - (NSInteger)getScalar {
        return iScalar;
    }

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
        } else if (obj instanceof ScaledDurationField) {
            ScaledDurationField other = (ScaledDurationField) obj;
            return (getWrappedField().equals(other.getWrappedField())) &&
                   (getType() == other.getType()) &&
                   (iScalar == other.iScalar);
        }
        return NO;
    }

    /**
     * Gets a hash code for this instance.
     * 
     * @return a suitable hashcode
     */
    - (NSUInteger)hash {
- (NSInteger)scalar = iScalar;
        int hash = (int) (scalar ^ (scalar >>> 32));
        hash += getType().hashCode();
        hash += getWrappedField().hashCode();
        return hash;
    }

}


@end
