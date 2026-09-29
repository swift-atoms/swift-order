extension Order {

    public enum Comparison: Sendable, Hashable, CaseIterable {

        case less

        case equal

        case greater
    }
}

#if !hasFeature(Embedded)
extension Order.Comparison: Swift.Codable {}
#endif
