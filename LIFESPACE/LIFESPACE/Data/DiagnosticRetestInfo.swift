import Foundation

struct DiagnosticRetestInfo {
    let disorder: String                 // e.g. "Anxiety"
    let lastResultTimestamp: Double      // seconds since 1970
    let lastResultRisk: String           // "High Risk", "Moderate Risk"
    let diagnosticViewName: String       // e.g. "AnxietyDiagnosticView"
}
