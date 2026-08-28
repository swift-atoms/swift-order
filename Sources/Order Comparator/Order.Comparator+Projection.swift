public import Comparison_Protocol

extension Order.Comparator where T: ~Copyable {

    @inlinable
    public static func by<Value: Comparison::Comparison.`Protocol` & SendableMetatype & ~Copyable>(
        _ selector: @escaping @Sendable (borrowing T) -> Value
    ) -> Order.Comparator<T> {
        return Order.Comparator { lhs, rhs in
            Comparison(selector(lhs), selector(rhs))
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
