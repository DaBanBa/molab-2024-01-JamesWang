// 1
import Combine

// 2
class CardListViewModel: ObservableObject {
  // 3
  @Published var cardRepository = CardRepository()

  // 4
  func add(_ card: Card) {
    cardRepository.add(card)
  }
}
