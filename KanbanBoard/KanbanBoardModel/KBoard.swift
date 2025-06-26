
import SwiftUI

struct KBoard {
    var columns: [String] = []
    var rows: [String] = []
    
    var cells: [KBCell] = []
}

class KBoardVM: ObservableObject {
    @Published private(set) var board: KBoard
    
    @Published var columns: [GridItem] = [ ]
    
    init() {
        self.board = KBoard()
        self.board.cells = Array( 0..<(board.columns.count * board.rows.count) ).map{ _ in KBCell(cards: []) }
        self.columns = board.columns.map{ _ in GridItem(.flexible()) }
        print("")
    }
    
    func insert(row: String) {
        board.rows.append(row)
        
        let newRow = Array(0..<board.columns.count).map { _ in KBCell(cards: [], color: .yellow) }
        
        board.cells.append(contentsOf: newRow)
    }
    
    func insert(column: String) {
        var cellsNew = board.cells.splitBy(board.columns.count)
        
        self.board.columns.append(column)
        self.columns = self.board.columns.map{ _ in GridItem(.flexible()) }
        
        cellsNew.indices.forEach {
            cellsNew[$0].append(KBCell(cards: [], color: .blue))
        }
        
        board.cells = cellsNew.flatMap { $0 }
    }
}
