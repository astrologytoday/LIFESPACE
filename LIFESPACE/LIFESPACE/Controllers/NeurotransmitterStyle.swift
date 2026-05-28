import SwiftUI

extension Neurotransmitter {
    var displayName: String {
        switch self {
        case .gaba:
            return "GABA"
        default:
            return rawValue.capitalized
        }
    }
    
    var badgeIcon: String {
        switch self {
        case .gaba:           return "leaf"            // Calm, green, natural
        case .serotonin:      return "sun.max"         // Bright, mood, happiness
        case .acetylcholine:  return "brain.head.profile" // Cognition, memory, focus
        case .dopamine:       return "sparkles"        // Reward, motivation
        case .epinephrine:    return "bolt.horizontal" // Fight/flight, adrenaline
        }
    }
    
    var badgeColor: Color {
        switch self {
        case .gaba:           return Color.green.opacity(0.40)
        case .serotonin:      return Color.purple.opacity(0.18)
        case .acetylcholine:  return Color.blue.opacity(0.22)
        case .dopamine:       return Color.yellow.opacity(0.22)
        case .epinephrine:    return Color.red.opacity(0.22)
        }
    }
}
