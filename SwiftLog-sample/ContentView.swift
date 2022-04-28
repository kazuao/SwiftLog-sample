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
        let logger = Logger(label: Bundle.main.bundleIdentifier!)

        // example
        logger.info("Hello World!")

        // MARK: Log Levels
        logger.trace("")
        logger.debug("")
        logger.info("")
        logger.notice("")
        logger.warning("")
        logger.error("")
        logger.critical("")

        useExtension()
        useLogHandler()
    }


    // MARK: Extensionを使用した場合
    func useExtension() {
        // extensionを使わないと下記のような形
        var logger = Logger(label: Bundle.main.bundleIdentifier!)
        logger[metadataKey: "request-uuid"] = "\(UUID())"
        logger.info("hello world")
        // 2019-03-13T18:30:02+0000 info: request-uuid=F8633013-3DD8-481C-9256-B296E43443ED hello world
    }


    // MARK: カスタムLogHandlerを使用する場合
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
