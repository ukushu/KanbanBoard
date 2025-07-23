import SwiftUI

struct KBCardDraggableView: View {
    let kBoardID: KBoardID
    
    let card: KBCard
    let fieldFrame: CGRect
    
    @State private var offset: CGSize = .zero
    var dragLocation: GestureState<CGPoint>
    @GestureState var isDragging = false
    
    var body: some View {
        KBCardView(card: card)
            .opacity(isDragging ? 0.8 : 1)
            .offset(offset + dragLocation.wrappedValue.asCGSize())
            .gesture(
                DragGesture()
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .updating(dragLocation) { value, state, _ in
                        let loc = value.location
//                        let globalLoc: CGPoint = value.location(in: CoordinateSpace.named("globalArea"))
                        state = loc
                    }
                    .onEnded { value in
                        let finalPosition = offset + value.translation
                        let cardSize = CGSize(width: 150, height: 150)
                        let cardFrame = CGRect(origin: CGPoint(x: finalPosition.width,
                                                               y: finalPosition.height),
                                               size: cardSize)
                        
//                        let cardFrame = CGRect(origin: dragLocation.wrappedValue, size: CGSize(width: 10, height: 10))
                        
                        let tmp = KBoardDropTargets.shared.targets
                        
                        if let matched = KBoardDropTargets.shared.targets.first(where: { $0.value.intersects(cardFrame) })
                        {
                            offset = CGSize(width: matched.value.origin.x, height: matched.value.origin.y)
                            
                        } else {
                            offset = finalPosition
                        }
                    }
            )
            .coordinateSpace(name: "globalArea")
//            .gesture(
//                DragGesture()
//                    .updating($dragOffset) { value, state, _ in
//                        state = value.translation
//                    }
//                    .onEnded { value in
//                        let finalPosition = offset + value.translation
//                        let cardSize = CGSize(width: 150, height: 150) // approximate
//                        let cardFrame = CGRect(origin: CGPoint(x: finalPosition.width,
//                                                               y: finalPosition.height),
//                                               size: cardSize)
//                        
//                        // Примагнічування, якщо перетинається з FieldView
//                        if fieldFrame.intersects(cardFrame) {
//                            // Snap to top-left corner of FieldView
//                            offset = CGSize(width: fieldFrame.origin.x, height: fieldFrame.origin.y)
//                        } else {
//                            offset = finalPosition
//                        }
//                    }
//            )
    }
}

struct KBCardView: View {
    let card: KBCard
    
    var isBlocked: Bool {
        card.color == .orange
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Issue ID: \(card.issueName)")
                        .font(.caption)
                        .bold()
                    
                    if isBlocked {
                        Text("Blocked by: GH-11") // Замінити на динамічне джерело
                            .font(.caption2)
                            .bold()
                    }
                    
                    Text(card.issueName)
                        .font(.title3)
                        .bold()
                }
                
                Spacer()
                
                // Assigned user avatars
                if !card.users.isEmpty {
                    VStack(alignment: .trailing, spacing: 4) {
                        ForEach(card.users) { user in
//                            Image(uiImage: user.avatarImage) // Прийдеться додати поле avatarImage у KBUser
//                                .resizable()
//                                .frame(width: 40, height: 40)
//                                .clipShape(Circle())
                        }
                    }
                }
            }
            
            // Markdown comments
            if !card.descr.isEmpty {
                Text(card.descr)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(6)
            }
            
            Spacer()
            
            // Dates
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(formatDate(card.dateCreation))
                        .font(.caption2)
                    
                    if let end = card.dateEnd {
                        let remaining = daysBetween(from: Date(), to: end)
                        Text(formatDate(end))
                            .font(.caption2)
                            .foregroundColor(remaining < 0 ? .red : .black)
                            .bold(remaining < 0)
                        
                        Text(card.daysLeft)
                            .font(.caption2)
                            .foregroundColor(remaining < 0 ? .red : .gray)
                            .bold(remaining < 0)
                    }
                }
                
                Spacer()
                
                // Tags
                if !card.tags.isEmpty {
                    Text(card.tags)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight:200)
        .background(card.color)
        .cornerRadius(12)
        .shadow(radius: 3)
        .foregroundStyle(Color.black)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func daysBetween(from: Date, to: Date) -> Int {
        Calendar.current.dateComponents([.day], from: from, to: to).day ?? 0
    }
}

// Dummy Tooltip
struct Tooltip: View {
    let text: String
    
    var body: some View {
        EmptyView()
        // Можна реалізувати з popover або contextMenu за потреби
    }
}

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}

extension CGPoint {
    func asCGSize() -> CGSize {
        return CGSize(width: self.x, height: self.y)
    }
}
