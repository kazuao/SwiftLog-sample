//
//  FirebaseLogHandler.swift
//  SwiftLog-sample
//
//  Created by kazunori.aoki on 2022/04/28.
//

import Foundation
import Logging

// LogHandlerを使うと、複数の宛先にlogを遅れる
// https://www.subthread.co.jp/blog/20220316/
public struct FirebaseLogHandler: LogHandler {
    private let label: String
    public var logLevel: Logger.Level = .info
    public var metadata = Logger.Metadata()

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    // internal for testing only
    internal init(label: String) {
        self.label = label
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
        // trace/debugは記録しない
        if level == .trace || level == .debug {
            return
        }

        // Crashlyticsにも送る場合
//        Crashlytics.crashlytics().log("\(level)/\(function)#L\(line) :\(metadata.map { " \($0)" } ?? "") \(message)")
    }
}
