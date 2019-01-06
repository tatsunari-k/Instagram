import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
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
        
        self.commentUserName.text = commentData.userName
        self.commentLabel.text = commentData.comment
        
        }
    }
