extension Order.Comparison {

    @inlinable
    public init<T: Swift.Comparable & ~Copyable>(_ lhs: borrowing T, _ rhs: borrowing T) {
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
