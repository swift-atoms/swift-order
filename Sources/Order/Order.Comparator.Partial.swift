
extension Order.Comparator {

    public struct Partial: Sendable {

        @usableFromInline
        internal let compare: @Sendable (borrowing T, borrowing T) -> Order.Comparison?

        @inlinable
        public init(_ compare: @escaping @Sendable (borrowing T, borrowing T) -> Order.Comparison?) {
            self.compare = compare
        }

    }
}

extension Order.Comparator.Partial {

    @inlinable
    public func callAsFunction(_ lhs: borrowing T, _ rhs: borrowing T) -> Order.Comparison? {
        compare(lhs, rhs)
    }
}
