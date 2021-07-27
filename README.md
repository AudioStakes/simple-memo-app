# simple-memo-app

## ローカルでアプリケーションを起動する手順

1. gem をインストール

    ```
    $ bundle install
    ```

2. PostgreSQL をダウンロード＆インストール

    https://www.postgresql.org/download/

3. データベース simple_memo_app_development を作成

    ※ 必要に応じて `$USER` を任意のユーザー名に置き換える

    ```
    $ createdb -O $USER simple_memo_app_development
    ```

4. テーブルを作成して初期データを投入

    ```
    $ bundle exec ruby prepare.rb
    ```

5. アプリケーションを起動

    ```
    $ bundle exec ruby app.rb
    ```

6. ブラウザからアプリケーションにアクセス

    http://localhost:4567
