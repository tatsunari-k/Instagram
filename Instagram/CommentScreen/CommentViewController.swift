import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {
    
    let SCREEN_SIZE = UIScreen.main.bounds.size
    var isOpen = false // キーボードが表示されているかの判定
    var isClose = false
    var keyboardHight: CGFloat! // キーボードの高さ
    var commentTextFieldString: String! = "" // コメント文字列保存用の変数
    //投稿データの取得　この中にコメントデータの配列var comments: [CommentData] = []も格納されている
    var postData : PostData! = nil   //PostDataを配列でインスタンス化
    var observing = false   // DatabaseのobserveEventの登録状態を表す
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentNavigationBar: UINavigationBar!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentSendButton: UIButton!
    
    
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
        // 送信ボタン押下時のアクション
    @IBAction func commentSendButtonAction(_ sender: Any) {
        print("DEBUG_PRINT: commentSendButtonをタップ")
        if commentTextField.text == "" {
            SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
            return
        }
        
        // TextFieldから文字を取得
        //commentTextFieldString = commentTextField.text!
        //↑newComment部分のcommentTextField.text!に相当
        // TextFieldの中身をクリア
        commentTextField.text = ""
        
        isOpen = false
        isClose = true
        
        // postDataに必要な情報を取得しておく
        //let time = Date.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        
        // 新しいコメントをcomments配列に追加
        let newComment = CommentData.init(comment: commentTextField.text!, userName: name!)
        postData.comments.append(newComment)
        
        // commentsをFirebaseに保存する
        let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
        let comments = ["comments": CommentData.convertDic(comments: postData.comments)]
        postRef.updateChildValues(comments)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        //キーボードを閉じる処理
        self.view.endEditing(true)
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////tableView内のセル数をカウントし、セル数を認識させる。
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postData == nil {
            return 0
        }
        print("DEBUG_PRINT: .commentViewCellの数をカウント\(postData.comments.count)")
        return postData.comments.count
    }
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////tableView内のセルを取得し、データの設定を行う。
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let commentData = postData?.comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentTableViewCell
        cell.setCommentData(commentData!)
        return cell
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self

        // テーブルセルのタップを無効にする
        commentTableView.allowsSelection = false
        
        //カスタムセルをtableviewに登録している。
        let commentnib = UINib(nibName: "CommentViewCell", bundle: nil)
        commentTableView.register(commentnib, forCellReuseIdentifier: "CommentCell")
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        //ここでUIKeyboardWillShowという名前の通知のイベントをオブザーバー登録をしている
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //ここでUIKeyboardWillHideという名前の通知のイベントをオブザーバー登録をしている
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    // 画面の描画ごとにテキストフィールドの高さを調整する
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isOpen {
            print("DEBUG_PRINT: isOpen")
            commentTextField.frame.origin.y = SCREEN_SIZE.height - self.keyboardHight - commentTextField.frame.height
            commentSendButton.frame.origin.y = SCREEN_SIZE.height - self.keyboardHight - commentSendButton.frame.height
        }
        if isClose {
            print("DEBUG_PRINT: isClose")
            commentTextField.frame.origin.y = SCREEN_SIZE.height - commentTextField.frame.height
            commentSendButton.frame.origin.y = SCREEN_SIZE.height - commentSendButton.frame.height
            print("DEBUG_PRINT: \(commentSendButton.frame.origin.y)")
        }
    }
    
    //Viewをタップした時に起こる処理を描く関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("DEBUG_PRINT: Viewをタップした際にUITextFieldを閉じる")
        //キーボードを閉じる処理
        self.view.endEditing(true)
    }
    
    //UIKeyboardWillShow通知を受けて、実行される関数
    @objc func keyboardWillShow(_ notification: NSNotification){
        print("DEBUG_PRINT: keyboardWillShow")
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height
        commentTextField.frame.origin.y = SCREEN_SIZE.height - keyboardHeight - commentTextField.frame.height
        commentSendButton.frame.origin.y = SCREEN_SIZE.height - keyboardHeight - commentSendButton.frame.height
        
        // キーボードの高さを保存する
        self.keyboardHight = keyboardHeight
        isOpen = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
