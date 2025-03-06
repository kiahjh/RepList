import ComposableArchitecture
import Foundation
import Testing

@testable import IOSApp

@MainActor
struct RepertoireListTests {
  @Test func collapsableSections() async {
    let store = TestStore(
      initialState: RepertoireList.State(
        pieces: []
      )
    ) {
      RepertoireList()
    }

    // they should all start out expanded
    #expect(store.state.listSectionCollapsedState.learning == false)
    #expect(store.state.listSectionCollapsedState.next == false)
    #expect(store.state.listSectionCollapsedState.needsWork == false)
    #expect(store.state.listSectionCollapsedState.learned == false)

    // tapping on a section heading shoudl collapse it
    await store.send(.sectionHeadingTapped(.next)) {
      $0.$listSectionCollapsedState.withLock { $0.next = true }
    }
    await store.send(.sectionHeadingTapped(.needsWork)) {
      $0.$listSectionCollapsedState.withLock { $0.needsWork = true }
    }
  }

  @Test func search() async {
    let store = TestStore(
      initialState: RepertoireList.State(
        pieces: Piece.list
      )
    ) {
      RepertoireList()
    }

    // searching something should change the `searchText`
    await store.send(.binding(.set(\.searchText, "bHeAG"))) {
      $0.searchText = "bHeAG"
    }
  }
  
  @Test func loadPieces() async {
    @Shared(.sessionToken) var sessionToken = "test-token"
    let store = TestStore(
      initialState: RepertoireList.State(
        pieces: []
      )
    ) {
      RepertoireList()
    } withDependencies: {
      $0.uuid = .constant(UUID(uuidString: "00000000-0000-0000-0000-000000000000")!)
      $0.date = .constant(Date(timeIntervalSince1970: 0))
    }
    
    #expect(store.state.pieces.isEmpty)
    #expect(store.state.isLoading == false)
    
    await store.send(.viewAppeared)
    await store.receive(\.loadPieces) {
      $0.isLoading = true
    }
    await store.receive(\.piecesLoaded) {
      $0.isLoading = false
      $0.pieces = Piece.list
    }
  }
}
