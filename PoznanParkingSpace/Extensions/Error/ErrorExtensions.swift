import Foundation

extension DecodingError {
  public var errorDescription: String? {
    switch self {
    case .dataCorrupted(let context):
      return NSLocalizedString(context.debugDescription, comment: "")
    case .keyNotFound(_, let context):
      return NSLocalizedString("\(context.debugDescription)", comment: "")
    case .typeMismatch(_, let context):
      return NSLocalizedString("\(context.debugDescription)", comment: "")
    case .valueNotFound(_, let context):
      return NSLocalizedString("\(context.debugDescription)", comment: "")
    }
  }
}

enum JSONDecodingError: Error, LocalizedError {
  case unknownError

  public var errorDescription: String? {
    switch self {
    case .unknownError:
      return NSLocalizedString("Unknown Error occured", comment: "")
    }
  }
}
