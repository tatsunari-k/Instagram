import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentUserName: UILabel!
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////セル内に各データを格納
    func setCommentData(_ commentData: CommentData) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: commentData.date!)
        self.commentUserName.text = commentData.userName
        self.commentDate.text = dateString
        self.commentLabel.text = commentData.comment
        
        }
    }
