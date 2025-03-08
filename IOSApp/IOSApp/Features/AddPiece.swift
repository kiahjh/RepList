import ComposableArchitecture
import SwiftUI

@Reducer
struct AddPiece: Equatable {
  @ObservableState
  struct State: Equatable {
    var focusedField: Field? = .search
    var piece: Piece
    var searchQuery: String = ""
    
    enum Field: String, Hashable {
      case search
    }
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      }
    }
  }
}

struct AddPieceView: View {
  @Bindable var store: StoreOf<AddPiece>
  @FocusState var focusedField: AddPiece.State.Field?
  @State private var raisedInput: Bool = false

  var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        ScrollView {
          VStack {
            ForEach(Piece.list) { piece in
              PieceView(title: piece.title, composer: piece.composer)
                .shadow(color: .b600.opacity(0.2), radius: 10, x: 0, y: 10)
            }
            VStack {
              Text("Don't see the piece you're looking for?")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.b700.opacity(0.8))
              BigButton("Create a new piece", color: .primary) {}
            }
            .padding(.top, 20)
          }
          .padding(.bottom, 160)
          .padding(.horizontal, 20)
        }
        Spacer()
      }
      Rectangle()
        .fill(Gradient(stops: [
          .init(color: .clear, location: 0),
          .init(color: .b200.opacity(0.8), location: 0.5),
          .init(color: .b200, location: 0.9),
          .init(color: .b200, location: 1),
        ]))
        .frame(height: 200)
        .allowsHitTesting(false)
      TextField("Search for a piece...", text: self.$store.searchQuery)
        .focused(self.$focusedField, equals: .search)
        .font(.system(size: 20))
        .padding()
        .background(.white)
        .cornerRadius(20)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .strokeBorder(.b900.opacity(0.2), lineWidth: 0.5)
        )
        .shadow(color: .b600.opacity(self.raisedInput ? 0.3 : 0), radius: 10, x: 0, y: 10)
        .padding(self.raisedInput ? 12 : 20)
        .offset(y: self.raisedInput ? -10 : 0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Gradient(colors: [.b50, .b200]))
    .overlay(Divider().opacity(self.raisedInput ? 1 : 0), alignment: .bottom)
    .onChange(of: self.focusedField, initial: false) { _, newValue in
      withAnimation(.bouncy(duration: 0.4, extraBounce: 0.4)) {
        self.raisedInput = newValue == .search
      }
    }
    .bind($store.focusedField, to: $focusedField)
    .navigationTitle("Add piece")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    AddPieceView(
      store: Store(
        initialState: AddPiece.State(piece: Piece.example())
      ) {
        AddPiece()
      }
    )
  }
}
