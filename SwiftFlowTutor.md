1) створюємо структуру проекту:
MyApp.swift
[ ] Entities
    [ ] Storage
        ProjID.storage.swift
        KBoardID.storage.swift
        // інші стореджи
    KBoardID.swift
[ ] Scenes
    MainView.swift
    

2) Імплементим наші сторейдж файли по прикладу:

```
import Foundation
import Essentials
import SwiftUI
import OrderedCollections

typealias ProjID = Flow.ProjectID

extension Flow.ProjectID {
    var boardsListDocument : Flow.Document<[UUID]> {
        storage.lazyInit { projID, pool in
            Flow.Document(jsonURL: projID.boardsListUrl, defaultContent: [], errors: pool)
        }
    }
    
    func storage(boardID: KBoardID) -> Flow.Storage<KBoardID> {
        storage.lazyInit(name: boardID.id.uuidString) { _, pool in
            Flow.Storage<KBoardID>(id: boardID, pool: pool)
        }
    }
}

extension Flow.ProjectID {
    var boardsListUrl : URL   { self.url.appendingPathComponent("KanbanBoardList.txt") }
    var usersListUrl  : URL   { self.url.appendingPathComponent("KanbanBoardUsersList.txt") }
}
```

* ВьюМоделей створювати не бажанао - в нас замість них SwiftFlow
* ProjID являється кореневим об'єктом який може зберігати інші об'єкти - наприклад KBoardID
* Дочірні asdfID не повинні наслідуватися від Codable. І повинні всередині зсилатися на батьківський asdfID об'єкт.
```
struct KBoardID : Hashable, Identifiable {
    public let projID: Flow.ProjectID
    private(set) var id : UUID
    
    init(projID: Flow.ProjectID, uuid: UUID = UUID()) {
        self.projID = projID
        self.id = uuid
    }
}
```

3) Для рефрешів у вьюсі повинен бути підключений обсерведОбджект Flow.Document - для роботи рефрешів.

```
struct KBoardView: View {
    let kBoardID: KBoardID
    @ObservedObject var document : Flow.Document<KBoard>
    
    init(kBoardID: KBoardID) {
        self.kBoardID = kBoardID
        self.document = kBoardID.document
    }
}
```

4) Якщо потрібна анімація - ми можемо повісити анімацію на конкретний елемент прив'язавшись до конкретного поля через value:

```
ColumnsListView()
    .animation(.default, value: kBoardID.document.content.columns)
```
