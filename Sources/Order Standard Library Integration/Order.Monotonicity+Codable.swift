public import Order

#if !hasFeature(Embedded)
    extension Order.Monotonicity: Codable {}
#endif
