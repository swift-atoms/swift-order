public import Comparison

extension Order {

    public struct Comparator<T: ~Copyable>: Sendable {

        @usableFromInline
        internal let compare: @Sendable (borrowing T, borrowing T) -> Comparison

        @inlinable
        public init(_ compare: @escaping @Sendable (borrowing T, borrowing T) -> Comparison) {
            self.compare = compare
        }

    }
}

extension Order.Comparator where T: ~Copyable {

    @inlinable
    public func callAsFunction(_ lhs: borrowing T, _ rhs: borrowing T) -> Comparison {
        compare(lhs, rhs)
    }
}
