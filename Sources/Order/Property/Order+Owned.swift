#if Property
public import Property

extension Order.Orderable where Self: ~Copyable {
    @inlinable
    public consuming func ordered() -> Property<Order, Self> { Property(consume self) }
}

extension Swift.Comparable where Self: ~Copyable {
    @_disfavoredOverload
    @inlinable
    public consuming func ordered() -> Property<Order, Self> { Property(consume self) }
}
#endif
