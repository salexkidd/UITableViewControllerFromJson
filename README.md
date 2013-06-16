UITableViewControllerFromJson
=====================================
JSONファイルで指定するだけで簡単にUITableViewの構造や動きとか作れます ( '-')ﾉ

主にできること
--------------------
+ jsonファイルでセルグループ、セル内容を作成可能
+ next_view 指定による Push View の自動化
+ push_action 指定による cellをプッシュされた場合のアクション割り当て
+ text_edit 指定による、 cell内部へのUITextField の埋め込み + コールバックアクションによる処理


使い方
---------------------
+ UITableViewControllerFromJson.* を自分のプロジェクトへ
+ 適当に UITableViewController の子クラスを作成
+ その子クラスのinitWithCoder に利用したいjsonファイル名を記述

    ```
    - (id)initWithCoder:(NSCoder *)aDecoder {
        self = [super initWithCoder:aDecoder];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"first_table_view" ofType:@"json"];
        NSData *json = [NSData dataWithContentsOfFile:path];
        self.tableWithGroupData = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
        return self;
    }
    ```
+ IB もしくは Storyboard画面で、コレを利用したいUITableViewController の クラスに、作成した子クラスを指定
+ jsonファイルを記述する
+ Run!!


JSONの定義
---------------------
+ 基本的な書き方
    ```
[
  {"category_label": "Push Button",
   "row_data": [
     {"cell_type": "push_action",
      "label": "This is test button!",
      "push_action": "showAlert:"
     }
   ]
  },

  {"category_label": "Push View",
   "row_data": [
     {"cell_type": "next_view",
      "label": "test1_vc",
      "accessory_type": "DisclosureIndicator",
      "next_view": {
         "storyboard_name": "MainStoryboard",
         "storyboard_id": "test1_vc"
      }
     },
     {"cell_type": "next_view",
      "label": "test1_vc",
      "accessory_type": "DisclosureIndicator",
      "next_view": {
         "storyboard_name": "MainStoryboard",
         "storyboard_id": "test2_vc"
      }
     }
   ]
  },

  {"category_label": "Editable Cell",
   "row_data": [
     {"cell_type": "text_edit",
      "edit_change_action": "changeText:",
      "edit_done_action": "doneText:"
     }
   ]
  }
]
    ```

+ category_label は 表示したいグループカテゴリのラベルを指定してください
+ row_data グループに並ぶcellを格納する配列です
+ accessory_type は、cellの accessoryType の指定になります。
    基本的には
    + DisclosureIndicator
    + DisclosureButton
    に対応しています。
+ cell_type には以下が指定可能です
    "next_view" (次のVCへの遷移)
    "push_action" (cellをタップ)
    "text_edit" (UITextFieldをcell中に埋めたもの)


cell_type に "next_view" を指定した場合
--------------------------------------------------
push対象になるView Controller を 指定してください
    ```
    "next_view": {
      "storyboard_name": "MainStoryboard",
      "storyboard_id": "test1_vc"
    }
    ```

+ storyboard_name は、push したい ViewControllerを含むStoryboardを指定してください
+ storyboard_id は storybaord の画面で割り振ったstory_board_id を記述してください


cell_type に "next_view" を指定した場合
-------------------------------------------
+ label を定義してcellのラベルを指定してください（しなくてもいいけど何もないcellになります)
+ push_action には 押された場合に呼び出されるセレクタ名を指定してください(最後の":"を忘れずに！)
+ 作成した子クラスに以下呼び出されるべき関数(メッセージ？）を指定してください
    push_actionに"pushedAction:" を指定した場合の例(引数にはcellのindexPathが必ず渡されます)

    ```
    - (void)pushedAction:(NSIndexPath *)indexPath {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ahhhhg!!!"
                                                        message:@"You pushed me!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    ```

cell_type に "text_edit を指定した場合
-----------------------------------------
記述中....


作った経緯
-----------------
+ 2013年にもなってUITableViewをGUIでなくコードでチマチマ定義するとかもういやだわジョージ
+ ファイル読み込ませて自動生成させたい。僕はwebエンジニアなのでJSONちゃんで！
+ 「すでに同様のものを誰かが作っているかもしれないが、作りたかった。今では後悔している」などと申しており...
+ 季節がそうさせた。なお、すでに間に合わん模様


ライセンス
===============
v1.0 についてはビールウェアとします。ただし、購入したビールは自分で飲んでね。（そんなに好きじゃないので）


