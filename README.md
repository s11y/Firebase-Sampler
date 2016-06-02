# Firebase Sampler

## 概要
2016年5月からアップデートされたFirebaseで、Auth Database Push通知を実装しています。

### 開発環境
Xcode 7.3.1
OS X 10.11.5

## 仕様
### 画面構成
SignupViewControllerあるいは、LoginViewControllerが最初の画面となります。ログイン状態なら、そのままListViewControllerに遷移するようになっています。データの追加はListViewControllerの右上のプラスボタンからViewControllerに遷移することで、textfieldから文字をPOSTすることができます。

### Auth
EmailとPasswordでユーザー認証が可能になっています。

### Database
#### CREATE
ViewControllerクラスのcreate()という関数でtextfieldに打ち込んだ文字をユーザーのTokenと日時と一緒に送信しています。

DatabaseのDB設計としては、
ユーザーのTokenをIDとして、そこからViewControllerのcreate()関数で送られたデータをコレクションとして保存しています。

#### READ
ListViewControllerのread()関数で自身のPOSTしたデータのみを読み込んでいます。

それぞれをTableViewで表示しています。

現在、FIRDataEventTypeをChildAddedで読み込んでいるために、不具合が生じているので、今後修正する予定です

#### UPDATE
今後実装予定

#### DELETE
ListViewControllerに実装しているdelete関数をtableview(tableview:commitEditingStyle)の中で呼び出し、NSIndexPathを渡すことで、該当するデータをDatabaseから削除しています。


### Push通知
Firebaseのコンソールからプッシュ通知を送ることができます。また、未読のプッシュ通知の数はバッジで表示します。

未読かどうか、プッシュ通知の一覧をTableViewで表示する機能などは今後実装予定です。

## Pull Request
まだまだ理解ができていない部分が多いので、プルリクエスト大歓迎です。
プルリクエストお待ちしております。
