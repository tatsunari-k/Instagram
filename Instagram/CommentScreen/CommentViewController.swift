import UIKit

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //}
    
    //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //}

    //////手順
    @IBOutlet weak var commentTableView: UITableView!
    
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

        // Do any additional setup after loading the view.
    }
    
    
    ///@IBAction func handleCancelButton(_ sender: Any) {
    // 画面を閉じる
    //self.dismiss(animated: true, completion: nil)
    //}
    ///
    ///
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
