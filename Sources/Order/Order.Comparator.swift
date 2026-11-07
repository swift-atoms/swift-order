extension Order {

    public struct Comparator<T: ~Copyable>: Sendable {

        @usableFromInline
        internal let compare: @Sendable (borrowing T, borrowing T) -> Order.Comparison

        @inlinable
        public init(_ compare: @escaping @Sendable (borrowing T, borrowing T) -> Order.Comparison) {
            self.compare = compare
        }

    }
}

extension Order.Comparator where T: ~Copyable {

    @inlinable
    public func callAsFunction(_ lhs: borrowing T, _ rhs: borrowing T) -> Order.Comparison {
        compare(lhs, rhs)
    }
}

extension Order.Comparator where T: ~Copyable {

    @inlinable
    public func then(_ other: Order.Comparator<T>) -> Order.Comparator<T> {
        Order.Comparator { [compare] lhs, rhs in
            compare(lhs, rhs).then(other.compare(lhs, rhs))
        }
    }

    @inlinable
    public func then(
        with other: @escaping @Sendable () -> Order.Comparator<T>
    ) -> Order.Comparator<T> {
        Order.Comparator { [compare] lhs, rhs in
            let primary = compare(lhs, rhs)
            if primary.isEqual {
                return other().compare(lhs, rhs)
            }
            return primary
        }
    }
}

extension Order.Comparator where T: ~Copyable {

    @inlinable
    public static func by<Value: Swift::Comparable & SendableMetatype & ~Copyable>(
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

extension Order.Comparator where T: ~Copyable {

    @inlinable
    public var reversed: Order.Comparator<T> {
        Order.Comparator { [compare] lhs, rhs in
            compare(lhs, rhs).reversed
        }
    }
}
