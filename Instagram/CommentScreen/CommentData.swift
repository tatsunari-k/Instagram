import UIKit
import Firebase
import FirebaseDatabase


class CommentData: NSObject {
    var id: String?
    var userName: String?
    var comment: String?
    var date: Date?
    
////init関数：イニシャライザと呼ばれる初期化関数。因数として初期化する変数を作成しておき、
////インスタンス化して呼び出しをかける際に、初期化した変数へ代入処理するなどして利用する
    
    init(snapshot: DataSnapshot) {
        let valueDictionary = snapshot.value as! [String: Any]
        self.comment = valueDictionary["comment"] as? String
        self.userName = valueDictionary["name"] as? String
    }
    
    init(comment: String, userName: String) {
        self.comment = comment
        self.userName = userName
    }
}

extension CommentData {
    static func convertDic(comments: [CommentData]) -> [String: [String: String]] {
        var dic: [String: [String: String]] = [:]
        
        for index in 0 ... (comments.count - 1) {
            let data = comments[index]
            let commentDic = ["comment":data.comment!, "name": data.userName!]
            dic.updateValue(commentDic, forKey: "\(index)")
        }
        return dic
    }
}
    
    
//    init(snapshot: DataSnapshot, myId: String) {
//        self.id = snapshot.key
//        let valueDictionary = snapshot.value as! [String: Any]
//        self.username = valueDictionary["name"] as? String
//        self.comment = valueDictionary["comment"] as? String
//        //投稿画像の撮影時間であって、投稿コメントの時間とはならない
//        let time = valueDictionary["time"] as? String
//        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
//
//        }
//    }

