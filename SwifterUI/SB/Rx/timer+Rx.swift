//
//  timer+.swift
//  secret
//
//  Created by mc on 2017/7/19.
//  Copyright © 2017年 mc. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element: FloatingPoint {
    
    /**
     用 Rx 封装的 Timer
     # 用法 #
     ```swift
     
     Observable<TimeInterval>.timer(duration: 5, interval: 1)
     .subscribe(
     onNext: { remain in
     print("剩余：", remain)
     },
     onCompleted: {
     print("计时结束！")
     }
     )
     .addDisposableTo(disposeBag)
     
     ```
     
     ## 结果 ##
     
     ```swift
     剩余： 5.0
     剩余： 4.0
     剩余： 3.0
     剩余： 2.0
     剩余： 1.0
     剩余： 0.0
     计时结束！
     ```
     - parameter duration: 总时长
     - parameter interval: 时间间隔
     - parameter ascending: true 为顺数计时，false 为倒数计时
     */
    
    public static func timer(duration: TimeInterval = TimeInterval.infinity,
                             interval: TimeInterval = 1,
                             ascending: Bool = false,
                             scheduler: SchedulerType = MainScheduler.instance)
        -> Observable<TimeInterval> {
            let count = (duration == Double.infinity) ? .max : Int(duration / interval) + 1
            return Observable<Int>
                .timer(RxTimeInterval.seconds(0), period: RxTimeInterval.milliseconds(Int(interval * 1000.0)), scheduler: scheduler)
                .map { TimeInterval($0) * interval }
                .map { ascending ? $0 : (duration - $0) }
                .take(count)
    }
}
