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
