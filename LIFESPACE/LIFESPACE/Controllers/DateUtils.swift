// DateUtils.swift
import Foundation

func currentDateMMDD() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
    return formatter.string(from: Date())
}

