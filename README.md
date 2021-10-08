# Sinatra_memo_app
Sinatraを使用した簡単なメモアプリです。
 
# Installation
アプリのインストール方法
```bash
git clone https://github.com/taigatomita/Sinatra_memo_app.git # ファイルをローカル環境に複製します
cd Sinatra_memo_app.git # アプリが保存してあるディレクトリに移動します
bundle install # 必要なGemfileをインストールします
```
postgresqlは各自の環境に合った方法でインストールしてください。
[ダウンロード \| 日本PostgreSQLユーザ会](https://www.postgresql.jp/index.php/download)
 
# Usage
`memo_app`という名前のデータベースを作成し、下記のsql文を記入してください。
```bash
CREATE TABLE memos (
id SERIAL,
title TEXT,
content TEXT,
PRIMARY KEY (id));
``` 
データベースを起動した後、ターミナルにて下記のコマンドを入力してください。
```bash
bundle exec ruby myapp.rb # ローカル環境でアプリを立ち上げます
http://localhost:4567  # こちらにブラウザでアクセスすれば利用可能です
```
 