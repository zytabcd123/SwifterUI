//
//  Number+random.swift
//  BNKit
//
//  Created by luojie on 2016/11/19.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
/**
 Generate random Number
 # Usage Exampe #
 ```swift
 
 let randomInt = (1..<5).random() // randomInt is in [1, 2, 3, 4]
 
 let randomInt = (1...5).random() // randomInt is in [1, 2, 3, 4, 5]
 
 let randomUInt = (1...5).random() as UInt // randomUInt is UInt Type
 
 
 let randomDouble = (1.0..<5.0).random() //  1.0 <= randomDouble < 5.0
 
 let randomDouble = (1.0...5.0).random() //  1.0 <= randomDouble <= 5.0
 
 let randomFloat = (1.0...5.0).random() as Float // randomFloat is Float Type
 
 ```
 */
public protocol IntegerHasRandom: BinaryInteger {
    init(_ value: UInt32)
    func toUInt32() -> UInt32
}

public protocol FloatingPointHasRandom: FloatingPoint {
    init(_ value: UInt32)
    func toUInt32() -> UInt32
}

extension Range where Bound: IntegerHasRandom {
    public func random() -> Bound {
        let delta = upperBound - lowerBound
        return lowerBound + Bound(arc4random_uniform(delta.toUInt32()))
    }
}

extension ClosedRange where Bound: IntegerHasRandom {
    
    public func random() -> Bound {
        let delta = upperBound - lowerBound + 1
        return lowerBound + Bound(arc4random_uniform(delta.toUInt32()))
    }
}

extension Range where Bound: FloatingPointHasRandom {
    
    public func random() -> Bound {
        let delta = upperBound - lowerBound, randomOne = Bound(arc4random_uniform(UInt32.max)) / Bound(UInt32.max)
        return lowerBound + randomOne * delta
    }
}

extension ClosedRange where Bound: FloatingPointHasRandom {
    
    public func random() -> Bound {
        let delta = upperBound - lowerBound, randomOne = Bound(arc4random_uniform(UInt32.max)) / Bound(UInt32.max - 1)
        return lowerBound + randomOne * delta
    }
}

// ------ IntegerHasRandom

extension Int: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension Int8: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension Int16: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension Int32: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension Int64: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension UInt: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension UInt8: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension UInt16: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension UInt32: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension UInt64: IntegerHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

// ------ FloatingPointHasRandom

extension Float: FloatingPointHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

//extension Float80: FloatingPointHasRandom {
//    public func toUInt32() -> UInt32 {
//        return UInt32(self)
//    }
//}

extension Double: FloatingPointHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}

extension CGFloat: FloatingPointHasRandom {
    public func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}




