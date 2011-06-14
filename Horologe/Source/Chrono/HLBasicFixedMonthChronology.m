/*
 * BasicFixedMonthChronology.m
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

#import "BasicFixedMonthChronology.h"


@implementation BasicFixedMonthChronology

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
package org.joda.time.chrono;

import org.joda.time.Chronology;
import org.joda.time.DateTimeConstants;

/**
 * Abstract implementation of a calendar system based around fixed length months.
 * <p>
 * As the month length is fixed various calculations can be optimised.
 * This implementation assumes any additional days after twelve
 * months fall into a thirteenth month.
 * <p>
 * BasicFixedMonthChronology is thread-safe and immutable, and all
 * subclasses must be as well.
 *
 * @author Brian S O'Neill
 * @author Stephen Colebourne
 * @since 1.2, refactored from CopticChronology
 */
abstract class BasicFixedMonthChronology extends BasicChronology {

    /** Serialization lock */
    private static final long serialVersionUID = 261387371998L;

    /** The length of the month. */
    static final int MONTH_LENGTH = 30;

    /** The typical millis per year. */
    static final long MILLIS_PER_YEAR =
        (long) (365.25 * DateTimeConstants.MILLIS_PER_DAY);

    /** The length of the month in millis. */
    static final long MILLIS_PER_MONTH = ((long) MONTH_LENGTH) * DateTimeConstants.MILLIS_PER_DAY;

    //-----------------------------------------------------------------------
    /**
     * Restricted constructor.
     *
     * @param base  the base chronology
     * @param param  the init parameter
     * @param minDaysInFirstWeek  the minimum days in the first week
     */
    BasicFixedMonthChronology(Chronology base, Object param :(NSInteger)minDaysInFirstWeek) {
        super(base, param, minDaysInFirstWeek);
    }

    //-----------------------------------------------------------------------
    long setYear:(NSInteger)instant :(NSInteger)year) {
        // optimsed implementation of set, due to fixed months
        int thisYear = getYear(instant);
        int dayOfYear = getDayOfYear(instant, thisYear);
        int millisOfDay = getMillisOfDay(instant);

        if (dayOfYear > 365) {
            // Current year is leap, and day is leap.
            if (!isLeapYear(year)) {
                // Moving to a non-leap year, leap day doesn't exist.
                dayOfYear--;
            }
        }

        instant = getYearMonthDayMillis(year, 1, dayOfYear);
        instant += millisOfDay;
        return instant;
    }

    //-----------------------------------------------------------------------
    long getYearDifference:(NSInteger)minuendInstant :(NSInteger)subtrahendInstant) {
        // optimsed implementation of getDifference, due to fixed months
        int minuendYear = getYear(minuendInstant);
        int subtrahendYear = getYear(subtrahendInstant);

        // Inlined remainder method to avoid duplicate calls to get.
        long minuendRem = minuendInstant - getYearMillis(minuendYear);
        long subtrahendRem = subtrahendInstant - getYearMillis(subtrahendYear);

        int difference = minuendYear - subtrahendYear;
        if (minuendRem < subtrahendRem) {
            difference--;
        }
        return difference;
    }

    //-----------------------------------------------------------------------
    long getTotalMillisByYearMonth:(NSInteger) year :(NSInteger)month) {
        return ((month - 1) * MILLIS_PER_MONTH);
    }

    //-----------------------------------------------------------------------
    int getDayOfMonth:(NSInteger)millis) {
        // optimised for fixed months
        return (getDayOfYear(millis) - 1) % MONTH_LENGTH + 1;
    }

    //-----------------------------------------------------------------------
    boolean isLeapYear:(NSInteger) year) {
        return (year & 3) == 3;
    }

    //-----------------------------------------------------------------------
    int getDaysInYearMonth:(NSInteger) year :(NSInteger)month) {
        return (month != 13) ? MONTH_LENGTH : (isLeapYear(year) ? 6 : 5);
    }

    //-----------------------------------------------------------------------
    int getDaysInMonthMax {
        return MONTH_LENGTH;
    }

    //-----------------------------------------------------------------------
    int getDaysInMonthMax:(NSInteger) month) {
        return (month != 13 ? MONTH_LENGTH : 6);
    }

    //-----------------------------------------------------------------------
    int getMonthOfYear:(NSInteger)millis) {
        return (getDayOfYear(millis) - 1) / MONTH_LENGTH + 1;
    }

    //-----------------------------------------------------------------------
    int getMonthOfYear:(NSInteger)millis :(NSInteger)year) {
        long monthZeroBased = (millis - getYearMillis(year)) / MILLIS_PER_MONTH;
        return ((int) monthZeroBased) + 1;
    }

    //-----------------------------------------------------------------------
    int getMaxMonth {
        return 13;
    }

    //-----------------------------------------------------------------------
    long getAverageMillisPerYear {
        return MILLIS_PER_YEAR;
    }

    //-----------------------------------------------------------------------
    long getAverageMillisPerYearDividedByTwo {
        return MILLIS_PER_YEAR / 2;
    }

    //-----------------------------------------------------------------------
    long getAverageMillisPerMonth {
        return MILLIS_PER_MONTH;
    }

}


@end
