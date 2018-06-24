//
//  VIPER-Entity.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/06.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*
 
 Entity
     EntityはVIPERの中で、おそらく最もシンプルな要素です。
     異なるtypeのデータをカプセル化、そして通常はVIPERコンポーネントに囲われてペイロードとして使われます。
     一つ注意したいのは、Entity はデータアクセスレイヤーとは異なり、Interactorから処理すべきです。

 [iOS Project Architecture : Using VIPER [和訳]](https://qiita.com/YKEI_mrn/items/67735d8ebc9a83fffd29)より

 */

import Foundation

struct VIPEREntity {
    // ユーザー名
    let user: UserList
    // 残高
    let balance: Int
}
