public import Comparison_Primitives

extension Order.Comparator where T: ~Copyable {

    @inlinable
    public var reversed: Order.Comparator<T> {
        Order.Comparator { [compare] lhs, rhs in
            compare(lhs, rhs).reversed
        }
    }
}
