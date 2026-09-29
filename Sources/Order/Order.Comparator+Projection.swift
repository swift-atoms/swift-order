
extension Order.Comparator where T: ~Copyable {

    @inlinable
    public static func by<Value: Swift.Comparable & SendableMetatype & ~Copyable>(
        _ selector: @escaping @Sendable (borrowing T) -> Value
    ) -> Order.Comparator<T> {
        return Order.Comparator { lhs, rhs in
            Order.Comparison(selector(lhs), selector(rhs))
        }
    }

    @inlinable
    public static func by<Value: ~Copyable>(
        using comparator: Order.Comparator<Value>,
        _ selector: @escaping @Sendable (borrowing T) -> Value
    ) -> Order.Comparator<T> {
        Order.Comparator { lhs, rhs in
            comparator(selector(lhs), selector(rhs))
        }
    }
}
