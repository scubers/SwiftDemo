//
//  NSDateExtension.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/17.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import Foundation

enum DateFormat {
    case yyyy
    case MM
    case dd
    case yyyy_MM
    case MM_dd
    case yyyy_MM_dd
    case yyyy_MM_dd_HH_mm
    case yyyy_MM_dd_HH_mm_mm
    
    func toString(dateSeparator:String = "-", timeSeparator:String = ":") -> String? {
        
        switch(self) {
        case .yyyy:                 return "yyyy"
        case .MM:                   return "MM"
        case .dd:                   return "dd"
        case .yyyy_MM:              return "yyyy\(dateSeparator)MM\(dateSeparator)dd"
        case .MM_dd:                return "yyyy\(dateSeparator)MM\(dateSeparator)dd"
        case .yyyy_MM_dd:           return "yyyy\(dateSeparator)MM\(dateSeparator)dd"
        case .yyyy_MM_dd_HH_mm:     return "yyyy\(dateSeparator)MM\(dateSeparator)dd HH\(timeSeparator)mm"
        case .yyyy_MM_dd_HH_mm_mm:  return "yyyy\(dateSeparator)MM\(dateSeparator)dd HH\(timeSeparator)mm\(timeSeparator)ss"
        }
    
    }
}

extension NSDate {
    // MARK: - 如果父类是NSObject，在扩展中加入变量时需要加上@nonobjc
    @nonobjc static let formatter:NSDateFormatter = NSDateFormatter()
    
    // MARK: - 各种基本秒数（间隔）
    @nonobjc static let MilliSecondInterval:NSTimeInterval = NSDate.SecondInterval / 1000
    @nonobjc static let SecondInterval:NSTimeInterval      = 1
    @nonobjc static let MinuteInterval:NSTimeInterval      = NSDate.SecondInterval * 60
    @nonobjc static let HourInterval:NSTimeInterval        = NSDate.MinuteInterval * 60
    @nonobjc static let DayInterval:NSTimeInterval         = NSDate.HourInterval * 24
    
    // MARK: - 新增方法
    class func parseDateWithString(dateString:String, format:DateFormat, timeZone:NSTimeZone = NSTimeZone.systemTimeZone()) -> NSDate? {
        
        NSDate.formatter.dateFormat = format.toString()
        NSDate.formatter.timeZone = timeZone
        return NSDate.formatter.dateFromString(dateString)
    }
    class func parseDateWithString(dateString:String, format:String, timeZone:NSTimeZone = NSTimeZone.systemTimeZone()) -> NSDate? {
        NSDate.formatter.dateFormat = format
        NSDate.formatter.timeZone = timeZone
        return NSDate.formatter.dateFromString(dateString)
    }
    
    func format(format:DateFormat, timeZone:NSTimeZone = NSTimeZone.systemTimeZone()) -> String? {
        NSDate.formatter.dateFormat = format.toString()
        NSDate.formatter.timeZone = timeZone
        return NSDate.formatter.stringFromDate(self)
    }
    func format(format:String, timeZone:NSTimeZone = NSTimeZone.systemTimeZone()) -> String? {
        NSDate.formatter.dateFormat = format
        NSDate.formatter.timeZone = timeZone
        return NSDate.formatter.stringFromDate(self)
    }
    
    func tommorow() -> NSDate {
        return self.dateByAddingTimeInterval(60 * 60 * 24)
    }
    
    func yesterday() -> NSDate {
        return self.dateByAddingTimeInterval(60 * 60 * 24 * -1)
    }
    
    func year() -> Int {
        return components().year
    }
    
    func month() -> Int {
        return components().month
    }
    
    func day() -> Int {
        return components().day
    }
    
    func hour() -> Int {
        return components().hour
    }
    
    func minute() -> Int {
        return components().minute
    }
    
    func second() -> Int {
        return components().second
    }
    
    func weekOfYear() -> Int {
        return components().weekOfYear
    }
    
    func weekOfMonth() -> Int {
        return components().weekOfMonth
    }
    
    func weekday() -> Int {
        return components().weekday
    }
    
    func isLeapYear() -> Bool {
        let year = self.year()
        if year % 400 == 0 {
            return true
        }
        return (year % 4 == 0 && year % 100 != 0)
    }
    
    func sameDayWithDate(date:NSDate) -> Bool {
        return (year() == date.year()
            && month() == date.month()
            && day() == date.day()
        )
    }
    
    func sameMonthWithDate(date:NSDate) -> Bool {
        return (year() == date.year() && month() == date.month())
    }
    
    func isLaterThan(date:NSDate) -> Bool {
        return (self.timeIntervalSinceDate(date) > 0)
    }
    
    func isEarlierThan(date:NSDate) -> Bool {
        return (self.timeIntervalSinceDate(date) < 0)
    }
    
    // MARK: - 私有方法
    private func components() -> NSDateComponents {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        
        let flags: NSCalendarUnit = [
            NSCalendarUnit.Year,
            NSCalendarUnit.Month,
            NSCalendarUnit.Day,
            NSCalendarUnit.Hour,
            NSCalendarUnit.Minute,
            NSCalendarUnit.Second,
            
            NSCalendarUnit.Weekday,
            NSCalendarUnit.WeekOfYear,
            NSCalendarUnit.WeekOfMonth,
            NSCalendarUnit.WeekdayOrdinal,
        ]
        
        let components:NSDateComponents = calendar.components(flags, fromDate: self)
        return components;
    }
    
}


func < (left: NSDate, right: NSDate) -> Bool {
    return left.isEarlierThan(right)
}

func > (left: NSDate, right: NSDate) -> Bool {
    return left.isLaterThan(right)
}

func == (left: NSDate, right: NSDate) -> Bool {
    return left.isEqualToDate(right)
}

func >= (left: NSDate, right: NSDate) -> Bool {
    return left.isLaterThan(right) || left.isLaterThan(right)
}

func <= (left: NSDate, right: NSDate) -> Bool {
    return left.isLaterThan(right) || left.isEarlierThan(right)
}

func + (left: NSDate, right: NSTimeInterval) -> NSDate {
    return left.dateByAddingTimeInterval(right)
}

func - (left: NSDate, right: NSTimeInterval) -> NSDate {
    return left.dateByAddingTimeInterval(right * -1)
}

func += (inout left: NSDate, right: NSTimeInterval) -> NSDate {
    left = left.dateByAddingTimeInterval(right)
    return left
}

func -= (inout left: NSDate, right: NSTimeInterval) -> NSDate {
    left = left.dateByAddingTimeInterval(right * -1)
    return left
}
