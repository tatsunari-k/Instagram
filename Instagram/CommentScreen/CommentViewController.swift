import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {
    
    let SCREEN_SIZE = UIScreen.main.bounds.size
    var isOpen = false // キーボードが表示されているかの判定
    var height: CGFloat! // キーボードの高さ
    var commentText: String! = "" //テキストフィールド内テキスト
    
    //////手順
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentNavigationBar: UINavigationBar!
    @IBOutlet weak var textField: UITextField!
    
    //var commentText: String = textField.text //テキストフィールド内テキスト
    
    //投稿データの取得　この中にコメントデータの配列var comments: [CommentData] = []も格納されている
    //PostDataを配列でインスタンス化
    var postArray: [PostData] = []
    
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //PostData.Swiftの投稿データの数をセルの数として返す。
        //本来だと、コメントデータ数を返さないといけない。
        //うまく機能しない。。。なぜ？
        //return postArray.comments.count
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        return cell
    }
    
    //1　PostTableViewCell内のコメントボタンをタップ
    ////①　CommentViewController画面へ遷移
    //////書き込みコメントを上から順にキャプションの表示
    //////その下にコメントを表示していく
    //////最下段にコメントするテキストフィールドを表示
    //////投稿するボタンの作成
    //////テキストボードの上にテキストフィールドを表示する
    //////参考://h//ttps://qiita.com/kobaboy/items/d56086b92f84c586562d
    //////h//ttps://ameblo.jp/hayashidesuga/entry-11971210696.html
    
    ////②　HomeViewController画面へと戻る
    //////PostTableViewCell内のラベルにコメントを反映
    //////コメントを記入したユーザー情報と共に表示　このときの表示する数は一旦一つだけにしておく。andtableView上の一番最新のみとしよう
    
    // postDataに必要な情報を取得しておく
    //let time = Date.timeIntervalSinceReferenceDate
    //let name = Auth.auth().currentUser?.displayName
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        commentTableView.delegate = self
        commentTableView.dataSource = self

        // テーブルセルのタップを無効にする
        commentTableView.allowsSelection = false
        
        let commentnib = UINib(nibName: "CommentViewCell", bundle: nil)
        commentTableView.register(commentnib, forCellReuseIdentifier: "Cell")
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        //ここでUIKeyboardWillShowという名前の通知のイベントをオブザーバー登録をしている
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //ここでUIKeyboardWillHideという名前の通知のイベントをオブザーバー登録をしている
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
     
//        // ツールバーを作成
//        let toolBar: UIView = UIView()
//        toolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45)
//        toolBar.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
//
//        // テキストフィールドを作成
//        let barTextField: UITextField = UITextField()
//        barTextField.frame = CGRect(x: 5, y: 5, width: self.view.frame.width - 65, height: 35)
//        barTextField.placeholder = "コメント..."
//        barTextField.borderStyle = UITextBorderStyle.roundedRect
//
//        // ボタンを作成
//        let barButton: UIButton = UIButton(type: UIButtonType.system)
//        barButton.frame = CGRect(x: barTextField.frame.width + 10, y: 5, width: 50, height: 35)
//        barButton.setTitle("送信", for: UIControlState.normal)
//        barButton.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControlEvents.touchUpInside)
//
//        // アイテムをツールバーに追加
//        toolBar.addSubview(barTextField)
//        toolBar.addSubview(barButton)
    }
    
    // ボタンタップ時に実行するメソッド
    @objc func buttonEvent(_ sender: UIButton) {
        // 処理を書く
    }
    
    
    // 画面の描画ごとにテキストフィールドの高さを調整する
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isOpen {
            textField.frame.origin.y = SCREEN_SIZE.height - self.height - textField.frame.height
        }
    }
    
    //Viewをタップした時に起こる処理を描く関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //キーボードを閉じる処理
        view.endEditing(true)
    }
    
    
    //UIKeyboardWillShow通知を受けて、実行される関数
    @objc func keyboardWillShow(_ notification: NSNotification){
        
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height
        textField.frame.origin.y = SCREEN_SIZE.height - keyboardHeight - textField.frame.height
        
        // キーボードの高さを保存する
        self.height = keyboardHeight
        isOpen = true
    }

    
    //UIKeyboardWillShow通知を受けて、実行される関数
    @objc func keyboardWillHide(_ notification: NSNotification){
        textField.frame.origin.y = SCREEN_SIZE.height - textField.frame.height
        isOpen = false
    }
    
    ///@IBAction func handleCancelButton(_ sender: Any) {
    // 画面を閉じる
    //self.dismiss(animated: true, completion: nil)
    //}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
