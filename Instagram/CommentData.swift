import UIKit
import Firebase
import FirebaseDatabase


class CommentData: NSObject {
    var id: String?
    var username: String?
    var comment: String?
    var name: String?
    var date: Date?
    

    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        self.username = valueDictionary["name"] as? String
        
        self.comment = valueDictionary["comment"] as? String
        
        //投稿画像の撮影時間であって、投稿コメントの時間とはならない
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        }
    }

