//
//  Logger+.swift
//  SwiftLog-sample
//
//  Created by kazunori.aoki on 2022/04/28.
//

import Foundation
import Logging

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
