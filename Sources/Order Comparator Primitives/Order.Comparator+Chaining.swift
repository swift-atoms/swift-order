public import Comparison_Primitives

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
