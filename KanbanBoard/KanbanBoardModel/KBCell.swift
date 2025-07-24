
import Foundation
import SwiftUI

let cellSize: CGSize = CGSize(width: 100, height: 100)

struct KBCell: Codable {
    var wPos: Int
    var hPos: Int
    var id: String { "\(wPos)x\(hPos)" }
    
    var cards: [KBCardID]
    var color: Color { wPos % 2 == 0 ? .yellow : .blue }
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
        GeometryReader { geo in
            VStack {
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
    }
}


