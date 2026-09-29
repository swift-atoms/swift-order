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
