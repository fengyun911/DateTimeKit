/*
 * GJLocaleSymbols.m
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

#import "GJLocaleSymbols.h"


@implementation GJLocaleSymbols

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

import java.lang.ref.WeakReference;
import java.text.DateFormatSymbols;
import java.util.WeakHashMap;
import java.util.Locale;
import java.util.TreeMap;

import org.joda.time.DateTimeFieldType;
import org.joda.time.IllegalFieldValueException;

/**
 * Utility class used by a few of the GJDateTimeFields.
 *
 * @author Brian S O'Neill
 * @since 1.0
 */
class GJLocaleSymbols {
    private static final int FAST_CACHE_SIZE = 64;

    private static final GJLocaleSymbols[] cFastCache = new GJLocaleSymbols[FAST_CACHE_SIZE];

    private static WeakHashMap cCache = new WeakHashMap();

    public static GJLocaleSymbols forLocale:(NSLocale*)locale {
        if (locale == nil) {
            locale = Locale.getDefault();
        }
        int index = System.identityHashCode(locale) & (FAST_CACHE_SIZE - 1);
        GJLocaleSymbols symbols = cFastCache[index];
        if (symbols != nil && symbols.iLocale.get() == locale) {
            return symbols;
        }
        synchronized (cCache) {
            symbols = (GJLocaleSymbols) cCache.get(locale);
            if (symbols == nil) {
                symbols = new GJLocaleSymbols(locale);
                cCache.put(locale, symbols);
            }
        }
        cFastCache[index] = symbols;
        return symbols;
    }

    private static String[] realignMonths(String[] months) {
        String[] a = new String[13];
        for(NSInteger i=1; i<13; i++) {
            a[i] = months[i - 1];
        }
        return a;
    }

    private static String[] realignDaysOfWeek(String[] daysOfWeek) {
        String[] a = new String[8];
        for(NSInteger i=1; i<8; i++) {
            a[i] = daysOfWeek[(i < 7) ? i + 1 : 1];
        }
        return a;
    }

    private static void addSymbols(TreeMap map, String[] symbols, Integer[] integers) {
        for(NSInteger i=symbols.length; --i>=0; ) {
            String symbol = symbols[i];
            if (symbol != nil) {
                map.put(symbol, integers[i]);
            }
        }
    }

    private static void addNumerals(TreeMap map :(NSInteger)start :(NSInteger)end, Integer[] integers) {
        for(NSInteger i=start; i<=end; i++) {
            map.put(String.valueOf(i).intern(), integers[i]);
        }
    }

    private static int maxLength(String[] a) {
        int max = 0;
        for(NSInteger i=a.length; --i>=0; ) {
            String s = a[i];
            if (s != nil) {
                int len = s.length();
                if (len > max) {
                    max = len;
                }
            }
        }
        return max;
    }

    private final WeakReference iLocale;

    private final String[] iEras;
    private final String[] iDaysOfWeek;
    private final String[] iShortDaysOfWeek;
    private final String[] iMonths;
    private final String[] iShortMonths;
    private final String[] iHalfday;

    // These map Strings to Integers.
    private final TreeMap iParseEras;
    private final TreeMap iParseDaysOfWeek;
    private final TreeMap iParseMonths;

    private final int iMaxEraLength;
    private final int iMaxDayOfWeekLength;
    private final int iMaxShortDayOfWeekLength;
    private final int iMaxMonthLength;
    private final int iMaxShortMonthLength;
    private final int iMaxHalfdayLength;

    /**
     * @param locale must not be nil
     */
    private GJLocaleSymbols:(NSLocale*)locale {
        iLocale = new WeakReference(locale);

        DateFormatSymbols dfs = new DateFormatSymbols(locale);

        iEras = dfs.getEras();
        iDaysOfWeek = realignDaysOfWeek(dfs.getWeekdays());
        iShortDaysOfWeek = realignDaysOfWeek(dfs.getShortWeekdays());
        iMonths = realignMonths(dfs.getMonths());
        iShortMonths = realignMonths(dfs.getShortMonths());
        iHalfday = dfs.getAmPmStrings();

        Integer[] integers = new Integer[13];
        for(NSInteger i=0; i<13; i++) {
            integers[i] = new Integer(i);
        }

        iParseEras = new TreeMap(String.CASE_INSENSITIVE_ORDER);
        addSymbols(iParseEras, iEras, integers);
        if ("en".equals(locale.getLanguage())) {
            // Include support for parsing "BCE" and "CE" if the language is
            // English. At some point Joda-Time will need an independent set of
            // localized symbols and not depend on java.text.DateFormatSymbols.
            iParseEras.put("BCE", integers[0]);
            iParseEras.put("CE", integers[1]);
        }

        iParseDaysOfWeek = new TreeMap(String.CASE_INSENSITIVE_ORDER);
        addSymbols(iParseDaysOfWeek, iDaysOfWeek, integers);
        addSymbols(iParseDaysOfWeek, iShortDaysOfWeek, integers);
        addNumerals(iParseDaysOfWeek, 1, 7, integers);

        iParseMonths = new TreeMap(String.CASE_INSENSITIVE_ORDER);
        addSymbols(iParseMonths, iMonths, integers);
        addSymbols(iParseMonths, iShortMonths, integers);
        addNumerals(iParseMonths, 1, 12, integers);

        iMaxEraLength = maxLength(iEras);
        iMaxDayOfWeekLength = maxLength(iDaysOfWeek);
        iMaxShortDayOfWeekLength = maxLength(iShortDaysOfWeek);
        iMaxMonthLength = maxLength(iMonths);
        iMaxShortMonthLength = maxLength(iShortMonths);
        iMaxHalfdayLength = maxLength(iHalfday);
    }

    public String eraValueToText:(NSInteger) value) {
        return iEras[value];
    }

    - (NSInteger)eraTextToValue(String text) {
        Integer era = (Integer) iParseEras.get(text);
        if (era != nil) {
            return era.intValue();
        }
        throw new IllegalFieldValueException(DateTimeFieldType.era(), text);
    }

    - (NSInteger)getEraMaxTextLength {
        return iMaxEraLength;
    }

    public String monthOfYearValueToText:(NSInteger) value) {
        return iMonths[value];
    }

    public String monthOfYearValueToShortText:(NSInteger) value) {
        return iShortMonths[value];
    }

    - (NSInteger)monthOfYearTextToValue(String text) {
        Integer month = (Integer) iParseMonths.get(text);
        if (month != nil) {
            return month.intValue();
        }
        throw new IllegalFieldValueException(DateTimeFieldType.monthOfYear(), text);
    }

    - (NSInteger)getMonthMaxTextLength {
        return iMaxMonthLength;
    }

    - (NSInteger)getMonthMaxShortTextLength {
        return iMaxShortMonthLength;
    }

    public String dayOfWeekValueToText:(NSInteger) value) {
        return iDaysOfWeek[value];
    }

    public String dayOfWeekValueToShortText:(NSInteger) value) {
        return iShortDaysOfWeek[value];
    }

    - (NSInteger)dayOfWeekTextToValue(String text) {
        Integer day = (Integer) iParseDaysOfWeek.get(text);
        if (day != nil) {
            return day.intValue();
        }
        throw new IllegalFieldValueException(DateTimeFieldType.dayOfWeek(), text);
    }

    - (NSInteger)getDayOfWeekMaxTextLength {
        return iMaxDayOfWeekLength;
    }

    - (NSInteger)getDayOfWeekMaxShortTextLength {
        return iMaxShortDayOfWeekLength;
    }

    public String halfdayValueToText:(NSInteger) value) {
        return iHalfday[value];
    }

    - (NSInteger)halfdayTextToValue(String text) {
        String[] halfday = iHalfday;
        for(NSInteger i = halfday.length; --i>=0; ) {
            if (halfday[i].equalsIgnoreCase(text)) {
                return i;
            }
        }
        throw new IllegalFieldValueException(DateTimeFieldType.halfdayOfDay(), text);
    }

    - (NSInteger)getHalfdayMaxTextLength {
        return iMaxHalfdayLength;
    }
}


@end
