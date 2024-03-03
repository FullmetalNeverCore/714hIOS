//
//  BackgroundTaskManager.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 02/03/2024.
//

import Foundation
import BackgroundTasks


class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    
    private let identifier = "com.mikoshi.pushnoti"
    private let ipAddr = IPModel.shared
    private var prevAnsw: String = "Offline"
    
    private var backgroundTask: BGTask?
    
    private var timer: Timer?

    private init() {
        registerBackgroundTask()
        scheduleBackgroundTask()

        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.performBackgroundTask()
        }
    }

    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
    }

    func scheduleBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: identifier)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Error scheduling background task: \(error)")
        }
    }

    private func performBackgroundTask() {
    
        DataEx().getJSON(ip: ipAddr.ipAddress, endp: "msg_buffer") { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let fdata):

                if let brValue = fdata["text"] as? [String], let lastElement = brValue.last {
                    if lastElement != self.prevAnsw {
                        print("Notification sent")
                        self.prevAnsw = lastElement
                        sendNotification(title: "Mikoshi", subtitle: "", body: "New message has been received!", id: "Mikoshi")
                    }
                    print(self.ipAddr.ipAddress)
                    print("Updated")
                } else {
                    print("The array is empty or 'text' not found in the dictionary.")
                }
            case .failure(let error):
                print("Error fetching charData: \(error)")
            }
        }
    }

    private func handleBackgroundTask(task: BGProcessingTask) {
        performBackgroundTask()
        task.setTaskCompleted(success: true)
        scheduleBackgroundTask()
    }
}
