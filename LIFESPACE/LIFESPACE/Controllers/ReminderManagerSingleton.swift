//
//  ReminderManagerSingleton.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-06.
//

import Foundation
import EventKit

class ReminderManagerSingleton {
    static let shared = ReminderManagerSingleton()

    let store = EKEventStore()

    private init() {}
}
