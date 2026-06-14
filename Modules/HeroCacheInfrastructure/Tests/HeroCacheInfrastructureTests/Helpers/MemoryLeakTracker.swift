import Testing

final class MemoryLeakTracker: Sendable {
    private let instance: WeakRef
    private let sourceLocation: SourceLocation

    init(instance: AnyObject, sourceLocation: SourceLocation) {
        self.instance = WeakRef(value: instance)
        self.sourceLocation = sourceLocation
    }

    func verify() {
        if instance.value != nil {
            Issue.record(
                "Instance should have been deallocated. Potential memory leak.",
                sourceLocation: sourceLocation
            )
        }
    }
}

private final class WeakRef: @unchecked Sendable {
    weak var value: AnyObject?
    init(value: AnyObject) { self.value = value }
}
