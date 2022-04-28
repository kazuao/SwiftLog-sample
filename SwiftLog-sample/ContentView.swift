//
//  ContentView.swift
//  SwiftLog-sample
//
//  Created by kazunori.aoki on 2022/04/28.
//

import SwiftUI
import Logging

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear(perform: onAppear)
    }
}

private extension ContentView {
    func onAppear() {
        let logger = Logger(label: "com.example.logger.sample")
        // MARK: Log Levels
        logger.trace("")
        logger.debug("")
        logger.info("")
        logger.notice("")
        logger.warning("")
        logger.error("")
        logger.critical("")

        // extensionを使わないと下記のような形
        var varLogger = logger
        varLogger[metadataKey: "request-uuid"] = "\(UUID())"
        logger.info("hello world")
        // 2019-03-13T18:30:02+0000 info: request-uuid=F8633013-3DD8-481C-9256-B296E43443ED hello world

        useLogHandler()
    }

    func useLogHandler() {
        // LogHandlerを設定する
        LoggingSystem.bootstrap { label in
            MultiplexLogHandler([
                FirebaseLogHandler(label: label),
                StreamLogHandler.standardOutput(label: label)
            ])
        }

        // ログ出力
        let logger = Logger(label: Bundle.main.bundleIdentifier!)
        logger.info("example")

        let userId = 12345
        logger.info("example with metadata", metadata: [
            "user_id": "\(userId)"
        ])

        // info/testLog()#L20 : example
        // info/testLog()#L23 : ["user_id": 12345] example with metadata
    }
}

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

// MARK: Loggerに対し、クラス名、ファンクション名、行数を出力するextension
// https://kumonosu.cloudsquare.jp/program/swift/post-4306/
// sample: 2020-09-27T10:30:15+0900 info ViewController : [viewDidLoad():70] message
extension Logger {

    static var level = Logger.Level.info

    init(function: String = #function) {
        self.init(label: function)
        self.logLevel = Logger.level
    }

    func trace(_ message: String = "" , function: String = #function, line: Int = #line) {
        self.trace(Logger.Message(stringLiteral: String("[\(function):\(line)] \(message)")))
    }

    func debug(_ message: String = "" , function: String = #function, line: Int = #line) {
        self.debug(Logger.Message(stringLiteral: String("[\(function):\(line)] \(message)")))
    }

    func info(_ message: String = "" , function: String = #function, line: Int = #line) {
        self.info(Logger.Message(stringLiteral: String("[\(function):\(line)] \(message)")))
    }

    func notice(_ message: String = "" , function: String = #function, line: Int = #line) {
        self.notice(Logger.Message(stringLiteral: String("[\(function):\(line)] \(message)")))
    }

    func warning(_ message: String = "" , function: String = #function, line: Int = #line) {
        self.warning(Logger.Message(stringLiteral: String("[\(function):\(line)] \(message)")))
    }

    func error(_ message: String = "" , function: String = #function, line: Int = #line) {
        self.error(Logger.Message(stringLiteral: String("[\(function):\(line)] \(message)")))
    }

    func critical(_ message: String = "" , function: String = #function, line: Int = #line) {
        self.critical(Logger.Message(stringLiteral: String("[\(function):\(line)] \(message)")))
    }
}
