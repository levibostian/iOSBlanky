import Foundation

// Exists for times when you need to use Observable<> but because Observable does not allow nil, we wrap.
//
// Note: This is a typo on puropse! When it's spelled correctly, SwiftFormat will edit it and break everything.
struct Optnal<DataType: Any> {
    let value: DataType?
}
