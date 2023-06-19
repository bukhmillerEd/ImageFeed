//
//  SomeClass.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 17.06.2023.
//

import Foundation

class SomeClass {
  
    static func printFunctionName(callStack: [String]) -> String {
        //let callStack = Thread.callStackSymbols
        if callStack.count > 1 {
            let address = UInt(callStack[1].prefix(18), radix: 16)!
            var info = Dl_info()
            if dladdr(UnsafeRawPointer(bitPattern: address), &info) != 0,
               let symbolName = info.dli_sname.map({ String(cString: $0) }) {
                return symbolName
            }
        }
        return ""
    }


}
