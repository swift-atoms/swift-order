extension Order {

    public enum Direction: Sendable, Hashable, CaseIterable {

        case ascending

        case descending

    }
}

extension Order.Direction {

    @inlinable
    public var reversed: Self {
        switch self {
        case .ascending: return .descending
        case .descending: return .ascending
        }
    }
}
