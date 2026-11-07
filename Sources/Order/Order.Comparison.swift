extension Order {

    public enum Comparison: Sendable, Hashable, CaseIterable {

        case less

        case equal

        case greater
    }
}

#if !hasFeature(Embedded)
    extension Order.Comparison: Swift::Codable {}
#endif

extension Order.Comparison {

    @inlinable
    public func then(_ other: Order.Comparison) -> Order.Comparison {
        switch self {
        case .equal: other
        case .less, .greater: self
        }
    }

    @inlinable
    public func then(with other: () -> Order.Comparison) -> Order.Comparison {
        switch self {
        case .equal: other()
        case .less, .greater: self
        }
    }
}

extension Order.Comparison {

    @inlinable
    public init<T: Swift::Comparable & ~Copyable>(_ lhs: borrowing T, _ rhs: borrowing T) {
        if lhs < rhs {
            self = .less
        } else if lhs > rhs {
            self = .greater
        } else if lhs == rhs {
            self = .equal
        } else {
            preconditionFailure("Unordered values have no Order.Comparison; use Order.Comparator.Partial")
        }
    }
}

extension Order.Comparison {

    @inlinable
    public var isLess: Bool { self == .less }

    @inlinable
    public var isEqual: Bool { self == .equal }

    @inlinable
    public var isGreater: Bool { self == .greater }

    @inlinable
    public var isLessOrEqual: Bool { self != .greater }

    @inlinable
    public var isGreaterOrEqual: Bool { self != .less }
}

extension Order.Comparison {

    @inlinable
    public var reversed: Order.Comparison {
        switch self {
        case .less: .greater
        case .equal: .equal
        case .greater: .less
        }
    }
}
