public import Order

#if !hasFeature(Embedded)
    extension Order.Monotonicity: Codable {
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            switch value {
            case "increasing": self = .increasing
            case "decreasing": self = .decreasing
            case "constant": self = .constant
            default:
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Unknown Order.Monotonicity value: \(value)"
                    )
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .increasing: try container.encode("increasing")
            case .decreasing: try container.encode("decreasing")
            case .constant: try container.encode("constant")
            }
        }
    }
#endif
