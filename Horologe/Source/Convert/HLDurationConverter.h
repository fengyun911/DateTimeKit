/*
 * DurationConverter.h
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

#import "HLConverter.h"


/**
 * DurationConverter defines how an object is converted to a millisecond duration.
 *
 * @author Stephen Colebourne
 * @author Brian S O'Neill
 * @since 1.0
 */
@protocol HLDurationConverter <HLConverter>

/**
 * Extracts the millis from an object of this convertor's type.
 * 
 * @param object  the object to convert, must not be nil
 * @return the millisecond duration
 * @throws ClassCastException if the object is invalid
 */
- (NSInteger)durationMillis:(id)object;

@end
