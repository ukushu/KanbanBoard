
import SwiftUI

struct KBoard: Codable {
    var columns: [String] = []
    var rows: [String] = []
    
    var cells: [KBCell] = []
}

class KBoardVM: ObservableObject {
    let boardID: KBoardID
    var board: KBoard { boardID.document.content }
    
    @Published var columns: [GridItem]
    
    init(boardID: KBoardID) {
        self.boardID = boardID
        self.columns = boardID.document.content.columns.map{ _ in GridItem(.flexible()) }
    }
    
    func insert(row: String) {
        boardID.document.content.rows.append(row)
        
        let newRow = Array(0..<board.columns.count).map { _ in KBCell(cards: [], color: .yellow) }
        
        boardID.document.content.cells.append(contentsOf: newRow)
        
        self.columns = boardID.document.content.columns.map{ _ in GridItem(.flexible()) }
    }
    
    func insert(column: String) {
        var cellsNew = board.cells.splitBy(board.columns.count)
        
        boardID.document.content.columns.append(column)
        self.columns = self.board.columns.map{ _ in GridItem(.flexible()) }
        
        cellsNew.indices.forEach {
            cellsNew[$0].append(KBCell(cards: [], color: .blue))
        }
        
        boardID.document.content.cells = cellsNew.flatMap { $0 }
    }
}
