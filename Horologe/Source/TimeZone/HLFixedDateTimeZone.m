/*
 * FixedDateTimeZone.m
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

#import "FixedDateTimeZone.h"


@implementation FixedDateTimeZone

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
package org.joda.time.tz;

import org.joda.time.DateTimeZone;

/**
 * Basic DateTimeZone implementation that has a fixed name key and offsets.
 * <p>
 * FixedDateTimeZone is thread-safe and immutable.
 * 
 * @author Brian S O'Neill
 * @since 1.0
 */
public final class FixedDateTimeZone extends DateTimeZone {

    private static final long serialVersionUID = -3513011772763289092L;

    private final String iNameKey;
    private final int iWallOffset;
    private final int iStandardOffset;

    public FixedDateTimeZone(String id, String nameKey,
                             int wallOffset :(NSInteger)standardOffset) {
        super(id);
        iNameKey = nameKey;
        iWallOffset = wallOffset;
        iStandardOffset = standardOffset;
    }

    - (NSString*)getNameKey:(NSInteger)instant) {
        return iNameKey;
    }

    - (NSInteger)getOffset:(NSInteger)instant) {
        return iWallOffset;
    }

    - (NSInteger)getStandardOffset:(NSInteger)instant) {
        return iStandardOffset;
    }

    - (NSInteger)getOffsetFromLocal:(NSInteger)instantLocal) {
        return iWallOffset;
    }

    - (BOOL)isFixed {
        return YES;
    }

    - (NSInteger)nextTransition:(NSInteger)instant) {
        return instant;
    }

    - (NSInteger)previousTransition:(NSInteger)instant) {
        return instant;
    }

    /**
     * Override to return the correct timzone instance.
     * @since 1.5
     */
    public java.util.TimeZone toTimeZone {
        String id = getID();
        if (id.length() == 6 && (id.startsWith("+") || id.startsWith("-"))) {
            // standard format offset [+-]hh:mm
            // our ID is without any prefix, so we need to add the GMT back
            return java.util.TimeZone.getTimeZone("GMT" + getID());
        }
        // unusual offset, so setup a SimpleTimeZone as best we can
        return new java.util.SimpleTimeZone(iWallOffset, getID());
    }

    - (BOOL)equals:(id)obj) {
        if (self == obj) {
            return YES;
        }
        if (obj instanceof FixedDateTimeZone) {
            FixedDateTimeZone other = (FixedDateTimeZone)obj;
            return
                getID().equals(other.getID()) &&
                iStandardOffset == other.iStandardOffset &&
                iWallOffset == other.iWallOffset;
        }
        return NO;
    }

    - (NSUInteger)hash {
        return getID().hashCode() + 37 * iStandardOffset + 31 * iWallOffset;
    }

}


@end
