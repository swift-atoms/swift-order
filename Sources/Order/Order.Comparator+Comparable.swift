
extension Order.Comparator where T: Swift.Comparable & SendableMetatype & ~Copyable {

    @inlinable
    public init() {
        self.init { lhs, rhs in
            Order.Comparison(lhs, rhs)
        }
    }

    @inlinable
    public static var ascending: Order.Comparator<T> {
        Order.Comparator()
    }

    @inlinable
    public static var descending: Order.Comparator<T> {
        Order.Comparator().reversed
    }
}
