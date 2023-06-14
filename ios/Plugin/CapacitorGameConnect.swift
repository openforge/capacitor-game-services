import Foundation

@objc public class CapacitorGameConnect: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
