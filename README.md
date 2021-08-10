# Kenkou

## Overview
- Ruby on Rails(APIモード)を使用して実装しました。テストはRSpecで書きました。
- ER図はdocs/table.drawio.pngです。
- git flowでブランチを切り、github issuesやprojectsを活用してタスク管理をしました。
- github: https://github.com/Hiroto-Nagashima/kenkou

## Setup
```
$ git clone https://github.com/Hiroto-Nagashima/Kenkou.git
$ cd kenkou
$ docker-compose build
$ docker-compose run app bundle i
$ docker-compose run app rails db:create
$ docker-compose run app rails db:migrate
$ docker-compose run app rails db:seed
$ docker-compose up

```

## Usage
- http://localhost:3000/api/v1/users/1~5 でjsonが返ります。
  - seedで5人のユーザーを初期値として投入しています。
- ユーザーの作成、ユーザー名の更新、ユーザーの削除機能も実装しました。
```
$ docker-compose up　-d
$ curl -XPOST -H "Content-Type: application/json" -d '{"name":"hoge"}' http://localhost:3000/api/v1/users  //ユーザ作成
$ curl -XPUT -H "Content-Type: application/json" -d '{"name":"huga"}' http://localhost:3000/api/v1/users/1  //ユーザ名更新
$ curl -XDELETE -H "Content-Type: application/json" http://localhost:3000/api/v1/users/1  //ユーザ削除

```

## Unit Test
- モデルとAPIのテストを実装しました。
- 以下のコマンドで実行できます
```
$ docker-compose run app rspec
```
