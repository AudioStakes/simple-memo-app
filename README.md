# simple-memo-app

## ローカルでアプリケーションを起動する手順

1. gem をインストール

    ```
    $ bundle install
    ```

2. 初期データを投入した CSV ファイルを作成

    ```
    $ bundle exec ruby prepare.rb
    ```

3. アプリケーションを起動

    ```
    $ bundle exec ruby app.rb
    ```

4. ブラウザからアプリケーションにアクセス

    http://localhost:4567
