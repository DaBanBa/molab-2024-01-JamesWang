// 1
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

// 2
class CardRepository: ObservableObject {
  // 3
  private let path: String = "cards"
  // 4
  private let store = Firestore.firestore()

  // 5
  func add(_ card: Card) {
    do {
      // 6
      _ = try store.collection(path).addDocument(from: card)
    } catch {
      fatalError("Unable to add card: \(error.localizedDescription).")
    }
  }
}
