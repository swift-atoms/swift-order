public import Pair

extension Order {

    public enum Monotonicity: Sendable, Hashable, CaseIterable {

        case increasing

        case decreasing

        case constant
    }
}

extension Order.Monotonicity {

    @inlinable
    public static func reversed(_ monotonicity: Order.Monotonicity) -> Order.Monotonicity {
        switch monotonicity {
        case .increasing: return .decreasing
        case .decreasing: return .increasing
        case .constant: return .constant
        }
    }

    @inlinable
    public var reversed: Order.Monotonicity {
        Self.reversed(self)
    }

    @inlinable
    public static prefix func ! (value: Order.Monotonicity) -> Order.Monotonicity {
        value.reversed
    }
}

extension Order.Monotonicity {

    @inlinable
    public static func composing(
        _ lhs: Order.Monotonicity,
        _ rhs: Order.Monotonicity
    ) -> Order.Monotonicity {
        switch (lhs, rhs) {
        case (.constant, _), (_, .constant): return .constant
        case (.increasing, .increasing), (.decreasing, .decreasing): return .increasing
        case (.increasing, .decreasing), (.decreasing, .increasing): return .decreasing
        }
    }

    @inlinable
    public func composing(_ other: Order.Monotonicity) -> Order.Monotonicity {
        Self.composing(self, other)
    }
}

extension Order.Monotonicity {

    @inlinable
    public var isIncreasing: Bool { self == .increasing }

    @inlinable
    public var isDecreasing: Bool { self == .decreasing }

    @inlinable
    public var isConstant: Bool { self == .constant }

    @inlinable
    public var isNonDecreasing: Bool { self != .decreasing }

    @inlinable
    public var isNonIncreasing: Bool { self != .increasing }
}

extension Order.Monotonicity {

    public typealias Value<Payload> = Pair<Order.Monotonicity, Payload>
}

#if !hasFeature(Embedded)
    extension Order.Monotonicity: Codable {}
#endif
