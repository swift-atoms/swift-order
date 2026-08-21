public import Comparison_Primitives
public import Order_Direction_Primitives

extension Order {

    public struct Projection<
        Root: ~Copyable,
        Value: Comparison.`Protocol` & SendableMetatype & ~Copyable
    >: Sendable {

        @usableFromInline
        internal let extract: @Sendable (borrowing Root) -> Value

        public let direction: Direction

        @inlinable
        public init(
            direction: Direction = .ascending,
            _ extract: @escaping @Sendable (borrowing Root) -> Value
        ) {
            self.extract = extract
            self.direction = direction
        }

    }
}

extension Order.Projection where Root: ~Copyable, Value: Comparison.`Protocol` & ~Copyable {

    @inlinable
    public var reversed: Self {
        Self(direction: direction.reversed, extract)
    }

    @inlinable
    public var comparator: Order.Comparator<Root> {
        let base = Order.Comparator<Root>.by(extract)
        return direction == .ascending ? base : base.reversed
    }
}
