import UIKit

class CommentViewCell: UITableViewCell {

    @IBOutlet weak var commentlabel: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentUserName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }    
}
