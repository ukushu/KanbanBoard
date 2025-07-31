
import SwiftUI
import Essentials
import OrderedCollections

typealias OrderDict = OrderedDictionary

struct KBoard: Codable {
    var columns: OrderDict<UUID,String> = [:]
    var rows :   OrderDict<UUID,String> = [:]
}

class KBoardDropTargets {
    static var shared: KBoardDropTargets = KBoardDropTargets()
    var targets: [UUID: CGRect] = [:]
    
    private init() {}
}


extension KBoardID {
    func insert(row: String) {
        self.document.content.rows[UUID()] = row
    }
    
    func insert(col: String) {
        self.document.content.columns[UUID()] = col
    }
    
    func remove(rowId: UUID) {
        if let idx = self.document.content.rows.index(forKey: rowId) {
            self.document.content.rows.remove(at: idx)
        }
    }
    
    func remove(colId: UUID) {
        if let idx = self.document.content.columns.index(forKey: colId) {
            self.document.content.columns.remove(at: idx)
        }
    }
    
    func moveCol(from: Int, to: Int) {
        guard from != to else { return }
        self.document.content.columns.values.move(fromOffsets: IndexSet(integer: from), toOffset: to )
    }
    
    func moveRow(from: Int, to: Int) {
        guard from != to else { return }
        self.document.content.rows.values.move(fromOffsets: IndexSet(integer: from), toOffset: to )
    }
}
