
import Foundation
import SwiftUI
import MoreSwiftUI

let cellSize: CGSize = CGSize(width: 100, height: 100)

struct KBCell: Codable {
    let boardID: KBoardID
    
    var wPos: Int
    var hPos: Int
    var id: String { "\(wPos)x\(hPos)" }
    
    var cards: [KBCardID] { self.boardID.documentCards.content[self.id] ?? [] }
    
    var color: Color { wPos % 2 == 0 ? .yellow : .blue }
}

extension KBCell: Identifiable, Hashable  {
    static func == (lhs: KBCell, rhs: KBCell) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(cards.map{ $0.id })
    }
    
    func asView() -> some View {
        return KBCellView(cell: self)
    }
}

struct KBCellView: View {
    let cell: KBCell
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ExecuteCode{ print("refreshed: \(cell.id) - cards: \(cell.cards.count)") }
                
                ForEach(cell.cards) {
                    Text( $0.id.uuidString.first(5) )
                        .foregroundStyle(.black.opacity(0.5))
                }
                
                Spacer(minLength: 5)
            }
            .frame(width: cellSize.width, height: cellSize.height)
            .background {
                VStack {
                    HStack {
                        Spacer()
                        Text("\(cell.id)")
                            .padding(5)
                    }
                    
                    Spacer()
                }
            }
            .background(cell.color.opacity(0.8) )
        }
        .frame(width: cellSize.width, height: cellSize.height)
        .cornerRadius(10)
        .shadow(radius: 2)
        .id(cell.id)
        .id(cell.cards)
    }
}
