#if Property
public import Comparison
public import Property

extension Property where Tag == Order, Base: ~Copyable {

    @inlinable
    public func isBefore(
        _ other: borrowing Base,
        by comparator: Order.Comparator<Base>
    ) -> Bool {
        comparator(base, other).isLess
    }

    @inlinable
    public func isAfter(
        _ other: borrowing Base,
        by comparator: Order.Comparator<Base>
    ) -> Bool {
        comparator(base, other).isGreater
    }

    @inlinable
    public func isEquivalent(
        to other: borrowing Base,
        by comparator: Order.Comparator<Base>
    ) -> Bool {
        comparator(base, other).isEqual
    }
}

extension Property
where Tag == Order, Base: Comparison.`Protocol` & SendableMetatype & ~Copyable {

    @inlinable
    public func isBefore(_ other: borrowing Base) -> Bool {
        isBefore(other, by: .ascending)
    }

    @inlinable
    public func isAfter(_ other: borrowing Base) -> Bool {
        isAfter(other, by: .ascending)
    }

    @inlinable
    public func isEquivalent(to other: borrowing Base) -> Bool {
        isEquivalent(to: other, by: .ascending)
    }
}
#endif
