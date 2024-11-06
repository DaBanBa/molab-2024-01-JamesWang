// 1
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

// 2
class CardRepository: ObservableObject {
  // 3
  
  // 1
  var userId = ""
  // 2
  private let authenticationService = AuthenticationService()
  // 3
  private var cancellables: Set<AnyCancellable> = []

  private let path: String = "cards"
  // 4
  private let store = Firestore.firestore()

  // 5
  // 1
  @Published var cards: [Card] = []

  // 2
  init() {
    // 1
    authenticationService.$user
      .compactMap { user in
        user?.uid
      }
      .assign(to: \.userId, on: self)
      .store(in: &cancellables)

    // 2
    authenticationService.$user
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        // 3
        self?.get()
      }
      .store(in: &cancellables)
  }


  func remove(_ card: Card) {
    // 1
    guard let cardId = card.id else { return }

    // 2
    store.collection(path).document(cardId).delete { error in
      if let error = error {
        print("Unable to remove card: \(error.localizedDescription)")
      }
    }
  }

  func get() {
    // 3
    store.collection(path)
      .whereField("userId", isEqualTo: userId)
      .addSnapshotListener { querySnapshot, error in
        // 4
        if let error = error {
          print("Error getting cards: \(error.localizedDescription)")
          return
        }

        // 5
        self.cards = querySnapshot?.documents.compactMap { document in
          // 6
          try? document.data(as: Card.self)
        } ?? []
      }
  }
  
  func update(_ card: Card) {
    // 1
    guard let cardId = card.id else { return }

    // 2
    do {
      // 3
      try store.collection(path).document(cardId).setData(from: card)
    } catch {
      fatalError("Unable to update card: \(error.localizedDescription).")
    }
  }


  func add(_ card: Card) {
    do {
      var newCard = card
      newCard.userId = userId
      _ = try store.collection(path).addDocument(from: newCard)
    } catch {
      fatalError("Unable to add card: \(error.localizedDescription).")
    }
  }

}
