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
