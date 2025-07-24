
import SwiftUI
import Essentials

struct KBoardView: View {
    let projID: ProjID
    @ObservedObject var model : KBoardVM
    
    init(projID: ProjID) {
        self.projID = projID
        model = projID.boardsDocument.content.values.first!.viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
//                Text("Cols: \(model.columns.count); Cells in col: \(model.board.cells.count / max(model.columns.count, 1) )")
                
                Button("+ row") {
                    model.insert(row: "hello1")
                }
                
                Button("+ col") {
                    model.insert(column: "hello")
                }
                
                Spacer()
            }
            
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                LazyVGrid(columns: model.columns, spacing: 7) {
                    Color.clickableAlpha
                        .frame(width: 100)
                    
                    ForEach(Array(model.board.columns.enumerated()), id: \.offset) { idx, text in
                        Text(text)
                            .frame(width: 100)
                            .contextMenu {
                                Button("delete") {
                                    model.remove(colIdx: idx)
                                }
                            }
                    }
                    
                    let rows = model.cells.chunked(by: model.columns.count - 1)
                    
                    ForEach(Array(model.board.rows.enumerated()), id: \.offset) { idx, text in
                        Text(text)
                            .contextMenu {
                                Button("delete") {
                                    model.remove(rowIdx: idx)
                                }
                            }
                        
                        if rows.count > 0 {
                            ForEach(rows[idx] ) { cell in
                                cell.asView()
                            }
                        }
                    }
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    KBoardView(projID: .sampleProject)
}
