
import SwiftUI
import Essentials

struct KBoard: Codable {
    var columns: [KBTitle] = []
    var rows: [KBTitle] = []
    
    var cellCards: [String: [KBCardID]] = [:]
}

class KBoardDropTargets {
    static var shared: KBoardDropTargets = KBoardDropTargets()
    var targets: [UUID: CGRect] = [:]
    
    private init() {}
}

class KBoardVM: ObservableObject {
    let boardID: KBoardID
    var board: KBoard { boardID.document.content }
    
    @Published var cells: [KBCell] = []
    @Published var columns: [GridItem] = []
    
    init(boardID: KBoardID) {
        self.boardID = boardID
        
        rebuildCells()
    }
    
    func insert(row: String) {
        boardID.document.content.rows.append( KBTitle(title: row) )
        rebuildCells()
    }
    
    func insert(col: String) {
        boardID.document.content.columns.append( KBTitle(title: col) )
        rebuildCells()
    }
    
    func remove(rowIdx: Int) {
        boardID.document.content.rows.remove(at: rowIdx)
        rebuildCells()
    }
    
    func remove(colIdx: Int) {
        boardID.document.content.columns.remove(at: colIdx)
        rebuildCells()
    }
    
    func rename(colIdx: Int, to newTitle: String) {
        boardID.document.content.columns[colIdx].title = newTitle
        rebuildCells()
    }
    
    func rename(rowIdx: Int, to newTitle: String) {
        boardID.document.content.rows[rowIdx].title = newTitle
        rebuildCells()
    }
    
    private func rebuildCells() {
        var futureCells: [KBCell] = []
        
        for rowIdx in 0..<boardID.document.content.rows.count {
            for colIdx in 0..<boardID.document.content.columns.count {
                futureCells.append(KBCell(wPos: rowIdx, hPos: colIdx, cards: []) )
            }
        }
        
        self.columns = boardID.document.content.columns.inserting(KBTitle(title: ""), at: 0).map{ _ in GridItem(.flexible()) }
        
        cells = futureCells
    }
}
