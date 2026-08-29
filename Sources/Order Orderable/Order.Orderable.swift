public import Property_Inout

extension Order {

    public protocol Orderable: ~Copyable {}
}

extension Order.Orderable where Self: ~Copyable {

    public var order: Property::Property<Order, Self>.Inout {
        mutating _read {
            yield Property::Property<Order, Self>.Inout(&self)
        }
    }
}
