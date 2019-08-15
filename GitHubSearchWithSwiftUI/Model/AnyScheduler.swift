//
//  AnyScheduler.swift
//  GitHubSearchWithSwiftUI
//
//  Created by .marty-suzuki on 2019/08/15.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import Combine

final class AnyScheduler<SchedulerTimeType: Strideable, SchedulerOptions>: Scheduler where SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {

    var now: SchedulerTimeType { _now() }
    var minimumTolerance: SchedulerTimeType.Stride { _minimumTolerance() }

    private let _now: () -> SchedulerTimeType
    private let _minimumTolerance: () -> SchedulerTimeType.Stride
    private let _scheduleAfterDateInterValToleranceOptionsAction: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Cancellable
    private let _scheduleAfterDateToleranceOptionsAction: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> ()
    private let _scheduleOptionsAction: (SchedulerOptions?, @escaping () -> Void) -> ()

    init<S: Scheduler>(_ scheduler: S) where S.SchedulerTimeType == SchedulerTimeType, S.SchedulerOptions == SchedulerOptions {
        self._now = { scheduler.now }
        self._minimumTolerance = { scheduler.minimumTolerance }
        self._scheduleAfterDateInterValToleranceOptionsAction = {
            scheduler.schedule(after: $0, interval: $1, tolerance: $2, options: $3, $4)
        }
        self._scheduleAfterDateToleranceOptionsAction = {
            scheduler.schedule(after: $0, tolerance: $1, options: $2, $3)
        }
        self._scheduleOptionsAction = {
            scheduler.schedule(options: $0, $1)
        }
    }

    func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
        _scheduleAfterDateInterValToleranceOptionsAction(date, interval, tolerance, options, action)
    }

    func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _scheduleAfterDateToleranceOptionsAction(date, tolerance, options, action)
    }

    func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _scheduleOptionsAction(options, action)
    }
}
