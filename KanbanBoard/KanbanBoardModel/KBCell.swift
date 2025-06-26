
import Foundation
import SwiftUI

let cellSize: CGSize = CGSize(width: 100, height: 100)

struct KBCell {
    var id: UUID = UUID()
    
    var maxItems: Int = 4
    var cards: [KBCardID]
    var color: Color = .gray
    //[.red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .black, .white].randomElement()!
}

extension KBCell: Identifiable, Hashable  {
    static func == (lhs: KBCell, rhs: KBCell) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(cards)
    }
    
    func asView() -> some View {
        KBCellView(cell: self)
    }
}

struct KBCellView: View {
    let cell: KBCell
    
    var body: some View {
        VStack {
            Spacer(minLength: 5)
        }
        .frame(width: cellSize.width, height: cellSize.height)
        .background {
            VStack {
                HStack {
                    Spacer()
                    Text("\(cell.maxItems)")
                        .padding(5)
                }
                
                Spacer()
            }
        }
        .background(cell.color)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
