
import SwiftUI
import Essentials

struct KBoard: Codable {
    var columns: [KBTitle] = []
    var rows: [KBTitle] = []
}

class KBoardDropTargets {
    static var shared: KBoardDropTargets = KBoardDropTargets()
    var targets: [UUID: CGRect] = [:]
    
    private init() {}
}

class KBoardVM: ObservableObject {
    let boardID: KBoardID
    var board: KBoard { boardID.flowBoard.content }
    
    @Published var cells: [KBCell] = []
    @Published var columns: [GridItem] = []
    
    init(boardID: KBoardID) {
        self.boardID = boardID
        
        refreshCells()
    }
    
    func insert(row: String) {
        boardID.flowBoard.content.rows.append( KBTitle(title: row) )
        refreshCells()
    }
    
    func insert(col: String) {
        boardID.flowBoard.content.columns.append( KBTitle(title: col) )
        refreshCells()
    }
    
    func remove(rowId: UUID) {
        if let idx = boardID.flowBoard.content.rows.firstIndex(where: { $0.id == rowId }) {
            boardID.flowBoard.content.rows.remove(at: idx)
        }
        refreshCells()
    }
    
    func remove(colId: UUID) {
        if let idx = boardID.flowBoard.content.columns.firstIndex(where: { $0.id == colId }) {
            boardID.flowBoard.content.columns.remove(at: idx)
        }
        refreshCells()
    }
    
    func rename(colIdx: Int, to newTitle: String) {
        boardID.flowBoard.content.columns[colIdx].title = newTitle
        refreshCells()
    }
    
    func rename(rowIdx: Int, to newTitle: String) {
        boardID.flowBoard.content.rows[rowIdx].title = newTitle
        refreshCells()
    }
    
    private func refreshCells() {
        var futureCells: [KBCell] = []
        
        for rowIdx in 0..<boardID.flowBoard.content.rows.count {
            for colIdx in 0..<boardID.flowBoard.content.columns.count {
                futureCells.append(KBCell(boardID: boardID, wPos: rowIdx, hPos: colIdx) )
            }
        }
        
        self.columns = boardID.flowBoard.content.columns.inserting(KBTitle(title: ""), at: 0).map{ _ in GridItem(.flexible()) }
        
        cells = futureCells
    }
    
    func moveCol(from: Int, to: Int) {
        boardID.flowBoard.content.columns.move(fromOffsets: IndexSet(integer: from), toOffset: to )
        refreshCells()
    }
    
    func moveRow(from: Int, to: Int) {
        boardID.flowBoard.content.rows.move(fromOffsets: IndexSet(integer: from), toOffset: to )
        refreshCells()
    }
}
