import Foundation

enum NetworkManagerResultType<T> {
  case success(T)
  case failure(error: Error)
}
