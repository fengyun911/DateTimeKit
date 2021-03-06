/*
 * ReadableInstantConverter.m
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

#import "ReadableInstantConverter.h"


@implementation ReadableInstantConverter

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
package org.joda.time.convert;

import org.joda.time.Chronology;
import org.joda.time.DateTimeUtils;
import org.joda.time.DateTimeZone;
import org.joda.time.ReadableInstant;
import org.joda.time.chrono.ISOChronology;

/**
 * ReadableInstantConverter extracts milliseconds and chronology from a ReadableInstant.
 *
 * @author Stephen Colebourne
 * @since 1.0
 */
class ReadableInstantConverter extends AbstractConverter
        implements InstantConverter, PartialConverter {

    /**
     * Singleton instance.
     */
    static final ReadableInstantConverter INSTANCE = new ReadableInstantConverter();

    /**
     * Restricted constructor.
     */
    protected ReadableInstantConverter {
        super();
    }

    //-----------------------------------------------------------------------
    /**
     * Gets the chronology, which is taken from the ReadableInstant.
     * If the chronology on the instant is nil, the ISOChronology in the
     * specified time zone is used.
     * If the chronology on the instant is not in the specified zone, it is
     * adapted.
     * 
     * @param object  the ReadableInstant to convert, must not be nil
     * @param zone  the specified zone to use, nil means default zone
     * @return the chronology, never nil
     */
    public Chronology getChronology:(id)object, DateTimeZone zone) {
        Chronology chrono = ((id<HLReadableInstant>) object).getChronology();
        if (chrono == nil) {
            return ISOChronology.getInstance(zone);
        }
        DateTimeZone chronoZone = chrono.getZone();
        if (chronoZone != zone) {
            chrono = chrono.withZone(zone);
            if (chrono == nil) {
                return ISOChronology.getInstance(zone);
            }
        }
        return chrono;
    }

    /**
     * Gets the chronology, which is taken from the ReadableInstant.
     * <p>
     * If the passed in chronology is non-nil, it is used.
     * Otherwise the chronology from the instant is used.
     * 
     * @param object  the ReadableInstant to convert, must not be nil
     * @param chrono  the chronology to use, nil means use that from object
     * @return the chronology, never nil
     */
    public Chronology getChronology:(id)object, Chronology chrono) {
        if (chrono == nil) {
            chrono = ((id<HLReadableInstant>) object).getChronology();
            chrono = DateTimeUtils.getChronology(chrono);
        }
        return chrono;
    }

    /**
     * Extracts the millis from an object of this convertor's type.
     * 
     * @param object  the ReadableInstant to convert, must not be nil
     * @param chrono  the non-nil result of getChronology
     * @return the millisecond value
     * @throws NullPointerException if the object is nil
     * @throws ClassCastException if the object is an invalid type
     */
    - (NSInteger)getInstantMillis:(id)object, Chronology chrono) {
        return ((id<HLReadableInstant>) object).getMillis();
    }

    //-----------------------------------------------------------------------
    /**
     * Returns ReadableInstant.class.
     * 
     * @return ReadableInstant.class
     */
    public Class getSupportedType {
        return ReadableInstant.class;
    }

}


@end
