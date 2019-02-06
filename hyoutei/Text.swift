//
//  text.swift
//  hyoutei
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 hamasugartanaka. All rights reserved.
//

import Foundation

enum text: String {
    
    case userCreate = "会員登録"
    case login = "ログイン"
    case identifier = "ユーザー名"
    case password = "パスワード"
    case countJadge = "IDとパスワードは半角英数字５文字以上２０文字以内に設定してください"
    case noUser = "ユーザーが存在しません"
    case difPassword = "パスワードが違います"
    case doubleUser = "このIDはすでに使われています"
    case schoolTopLabel = "大学名を選択"
    case placeHolder = "受けた授業やコメントを記入"
    case post = "投稿"
    case limit = ""
    case evaluate = "教授を１０点満点で評価してください"
    case collegePlaceHolder = "教授の名前を記入"
    case finishPost = "投稿が完了しました"
    case close = "閉じる"
    case margin = "空白があります"
    case marginMessage = "教授名とテキストを入力してください"
    case limitOver = "文字数制限オーバー"
    case limitOverMessage = "300文字以内で入力してください"
    case monthLimit = "投稿数が制限を超えています"
    case monthLimitMessage = "1ヶ月に投稿できるのは３００件までです"
    case doubleComment = "追加できません"
    case doubleCommentMessage = "この教授はすでに掲示板内に追加されています"
}

