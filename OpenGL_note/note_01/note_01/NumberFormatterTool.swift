//
//  NumberFormatterTool.swift
//  swiftjson
//
//  Created by qiansheng on 2017/9/15.
//  Copyright © 2017年 qiansheng. All rights reserved.
//

import UIKit

class NumberFormatterTool: NSObject {
    
    func changeFormatter() {
        let formatter = NumberFormatter()
        print(formatter.locale)
        formatter.locale = Locale(identifier: "fr_FR")
        print(formatter.currencySymbol)
       // print(Locale.availableIdentifiers)
      
       
       // print(Locale.isoCurrencyCodes)
        //print(Locale.isoLanguageCodes)
        formatter.locale = Locale(identifier: "en_US")
        print(formatter.currencySymbol)
        
        formatter.generatesDecimalNumbers = true
        let str = formatter.number(from: "123.568789")
        if str!.isMember(of: NSNumber.self) {
            print("number")
        }else if str!.isMember(of: NSDecimalNumber.self){
            print("DecimalNumber")
        }
        print(formatter.formatterBehavior)
        
        let for1 = NumberFormatter()
        print(for1.negativeFormat)
        for1.numberStyle = NumberFormatter.Style.currency
        print(for1.numberStyle)
        print(for1.string(from: -70.00)!)
        for1.negativeFormat = "¤-#,##0.00"
        print(for1.string(from: -70.00)!)
        
        let for2 = NumberFormatter()
        print(for1.textAttributesForNegativeValues as Any)
        print(for2.textAttributesForNegativeValues as Any)
        
        
        let for3 =  NumberFormatter()
        print(for3.positiveFormat)
        for3.numberStyle = NumberFormatter.Style.currency
        print(for3.string(from: 70.00)!)
        for3.positiveFormat = "+¤#,##0.00"
        print(for3.string(from: 70.00)!)
        
        
        let for4 = NumberFormatter()
        let str1 = for4.number(from: "123456789.124556")
        print(str1!)
        print("+++++")
        for4.allowsFloats = false
        let str2 = for4.number(from: "123456789.124556")
        print(str2 as Any)
         print("----")
        print(str1 as Any)
        
        let for5 = NumberFormatter()
        for5.numberStyle = NumberFormatter.Style.decimal
        print(for5.decimalSeparator)
        for5.decimalSeparator = ","
        let str3 = for5.number(from: "1234556,98765")
        
        print(str3!)
        
        let for6 = NumberFormatter()
        for6.numberStyle = .decimal
        print(for6.alwaysShowsDecimalSeparator)
        for6.alwaysShowsDecimalSeparator = true
        let str4 = for6.string(from: 1432143645236)
        print(str4!)
        
        let for7 = NumberFormatter()
        for7.numberStyle = .currency
        print(for7.currencyDecimalSeparator)
        print(for7.currencyGroupingSeparator)
        let str5 = for7.string(from: 1234345667.290)
        
        for7.currencyDecimalSeparator = "_"
        print(str5!)
        let str6 = for7.string(from:1234345667.290 )
        print(str6!)
        
        let for8 = NumberFormatter()
        for8.numberStyle = .currency
        print(for8.usesGroupingSeparator)
        //for8.groupingSeparator = "*"
        let str7 = for8.string(from: 14321423.123)
        print(str7!)
        for8.usesGroupingSeparator = false
        let str8 = for8.string(from:14321423.123)
        print(str8!)
        
        let for9 = NumberFormatter()
        for9.numberStyle = .decimal
        for9.groupingSeparator = "*"
        let str9 = for9.string(from:1432142334.123)
        print(str9!)
        
        let for10 = NumberFormatter()
        for10.numberStyle  = .decimal
        print(for10.zeroSymbol as Any)
        let str10 = for10.string(from: 0)
        print(str10!)
        for10.zeroSymbol = "*"
        let str11 = for10.string(from: 102304)
        print(str11!)
        
        
        let for11 = NumberFormatter()
        print(for11.textAttributesForZero as Any)
        
        let for12 = NumberFormatter()
        for12.numberStyle = .decimal
        print(for12.nilSymbol)
        for12.nilSymbol = ">"
        let str12 = for12.number(from: "--")
        print(str12 as Any)
        
        let for13 = NumberFormatter()
        for13.numberStyle = .decimal
        print(for13.textAttributesForNil as Any)
        
        let for14 = NumberFormatter()
        for14.numberStyle = .decimal
        print(for14.notANumberSymbol)
        
        let for15 = NumberFormatter()
        for15.numberStyle = .decimal
        print(for15.textAttributesForPositiveValues as Any)
        
        let for16 = NumberFormatter()
        for16.numberStyle = .decimal
        print(for16.textAttributesForNegativeValues as Any)
        
        
        let for17 = NumberFormatter()
        print(for17.positivePrefix,"☺")
        let str17 = for17.string(from: 123456)
        print(str17 as Any)
        for17.positivePrefix = "+"
        print(for17.string(from: 1234456) as Any)
        
        
        
    }
    

}
