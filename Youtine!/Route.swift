import Foundation

/// App-wide navigation destinations for the main stack
enum Route: Hashable {
    case view(Routine)
    case edit(Routine)
}
