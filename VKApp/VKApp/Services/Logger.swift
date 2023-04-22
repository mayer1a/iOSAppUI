//
//  Logger.swift
//  VKApp
//
//  Created by Artem Mayer on 24.12.2022.
//

import Foundation

final class Logger {

    // MARK: - Private properties

    private let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    private let batchLogSize = 10
    private var logs: [String] = []
    private let fileNameDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = .current

        return dateFormatter
    }()
    private let logAddedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        dateFormatter.timeZone = .current

        return dateFormatter
    }()

    // MARK: - Functions

    func addLog(_ log: String) {
        let currentTime = Date()
        logs.append("\(logAddedDateFormatter.string(from: currentTime)): \(log)")

        writeLogsIfNeeded()
    }

    // MARK: - Private functions

    private func writeLogsIfNeeded() {
        if logs.count >= batchLogSize {
            writeLogToFile()

            logs = []
        }
    }

    private func writeLogToFile() {
        let currentDate = Date()
        let fileName = fileNameDateFormatter.string(from: currentDate)
        var fileUrl: URL
        var resultLoggerString = ""

        if #available(iOS 16.0, *) {
            fileUrl = URL(filePath: fileName, relativeTo: directoryUrl).appendingPathExtension("txt")
        } else {
            fileUrl = URL(fileURLWithPath: fileName, relativeTo: directoryUrl).appendingPathExtension("txt")
        }

        logs.forEach { log in
            resultLoggerString.append("\(log)\n")
        }

        guard let writeData = resultLoggerString.data(using: .utf8) else { return }

        do {
            try writeData.write(to: fileUrl)
            print("Logs successfully written to file: \(fileName)")
            print("Written logs:\n\(resultLoggerString)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
