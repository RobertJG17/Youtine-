import Foundation

/// Segmented control options for filtering routines
enum RoutineSelection: String, CaseIterable, Identifiable {
    case all
    case todo
    case complete
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
}
