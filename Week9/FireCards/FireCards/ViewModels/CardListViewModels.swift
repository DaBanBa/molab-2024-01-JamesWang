// 1
import Combine

// 2
class CardListViewModel: ObservableObject {
  // 3
  @Published var cardRepository = CardRepository()
  @Published var cardViewModels: [CardViewModel] = []
  // 2
  private var cancellables: Set<AnyCancellable> = []
  init() {
    // 1
    cardRepository.$cards.map { cards in
      cards.map(CardViewModel.init)
    }
    // 2
    .assign(to: \.cardViewModels, on: self)
    // 3
    .store(in: &cancellables)
  }

  // 4
  func add(_ card: Card) {
    cardRepository.add(card)
  }
}
