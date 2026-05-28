import Foundation
import Security

struct KeychainHelper {
    static let service = "com.yourcompany.LIFESPACE"
    static let account = "dreamJournalPassword"

    // MARK: - Password
    static func savePassword(_ password: String) {
        saveToKeychain(value: password, key: account)
    }

    static func getPassword() -> String? {
        return getFromKeychain(key: account)
    }

    // MARK: - Secret Question
    static func saveSecretQuestion(_ question: String) {
        saveToKeychain(value: question, key: "dreamSecretQuestion")
    }

    static func getSecretQuestion() -> String? {
        return getFromKeychain(key: "dreamSecretQuestion")
    }

    // MARK: - Secret Answer
    static func saveSecretAnswer(_ answer: String) {
        saveToKeychain(value: answer, key: "dreamSecretAnswer")
    }

    static func getSecretAnswer() -> String? {
        return getFromKeychain(key: "dreamSecretAnswer")
    }

    // MARK: - Internal Helpers
    private static func saveToKeychain(value: String, key: String) {
        guard let data = value.data(using: .utf8) else { return }

        // Delete existing entry
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)

        // Add new entry
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemAdd(attributes as CFDictionary, nil)
    }

    private static func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else { return nil }

        return value
    }
}

