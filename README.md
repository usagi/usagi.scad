# usagi.scad

わたしが欲しい気がした JIS/ISO 規格に形だけでも互換性の高いボルト類やナットの造形が可能な OpenSCAD のライブラリーです。
…でしたが、総合ライブラリー化してきました。

<table>
<tr>
<td width="24%"><img float="left" alt="example-image-0" src="sample_screenshot.png"/>
<td width="24%"><img float="left" alt="example-image-1" src="https://i.imgur.com/A1qZMsb.png"/>
<td width="24%"><img float="left" alt="example-image-2" src="https://i.imgur.com/S2RtmBF.png"/>
<td width="24%"><img float="left" alt="example-image-3" src="https://i.imgur.com/JeeL3zn.png"/>
<tr>
<td><img float="left" alt="example-image-4" src="https://i.imgur.com/Rn2zTj2.png"/>
<td><img float="left" alt="example-image-5" src="https://i.imgur.com/pSZbsJ3.png"/>
<td><img float="left" alt="example-image-6" src="https://i.imgur.com/MmXjsTc.png"/>
<td><img float="left" alt="example-image-7" src="https://i.imgur.com/3eO2KXM.png"/>
<tr>
<td><img float="left" alt="example-image-4" src="https://i.imgur.com/IIJcfj5.png"/>
<td><img float="left" alt="example-image-5" src="https://i.imgur.com/yXQ4KcP.png"/>
<td>&nbsp;
<td><&nbsp;
</table>

## Motivation

1. 作ってみたかった( OpenSCAD も JIS/ISO 規格も初心者なので修行も兼ねて )
2. JIS 規格に形だけでもそれなりに準拠したボルトやナットを造形できる OpenSCAD の便利のよさそうな OSS ライブラリーを見つけられなかった

## Feature

- part/ 部品ライブラリー
    - screw.scad JIS規格ねじ ( 次節も参照 )
    - bearing.scad ベアリング
    - pipie.scad パイプ
    - shaft.scad シャフト
    - shaft_support_block_T.scad シャフトサポートブロックT型
    - switch/ スイッチ
        - key_switch.scad キースイッチ ( 現在はステムの造形のみ対応済み #1 )
            - stem.scad ステム
- geometry/ 形状ライブラリー
    - arc.scad 弧を造形
    - chamfered_square.scad 4つの角ごとのC面取り/R面取りに対応した面取り長方形を造形
    - chamfered_cube.scad 12の角ごとのC面取り/R面取りに対応した面取り立方体を造形
    - generate_arc_vertices.scad 弧の頂点群を生成
- utility
    - vector/ vectorライブラリー
        - multiply_vector.scad 1次/2次の vector と scalar の積(†1)
        - pop_vector_block.scad 末尾から順序を変えずに部分要素群を取得
        - pop_vector.scad 末尾からの逆順にした部分要素群を取得
        - reverse.scad 並び順を逆順にした vector を取得
        - shift_vector.scad 先頭からの部分要素群を取得
        - slice_vector.scad 部分要素群を取得
        - translate_vector.scad 座標リストを格納する2次のvectorの座標を平行移動(†1)
        - mirror.scad 2D頂点群からなる vector についてX軸またはY軸の鏡像を成す頂点群または元の頂点群に鏡像部位を追加した頂点群を取得
        - max_element_of.scad 任意次元の頂点群からなる vector について特定の次元の最大値を取得
        - min_element_of.scad 任意次元の頂点群からなる vector について特定の次元の最小値を取得
    - number/ 数値ライブラリー
        - count_integer_part_digits.scad 整数部分の桁を取得
        - round_number_to_significant_figures.scad 有効数字で丸めた値を取得
        - split_number_to_integer_and_fraction.scad 整数部分と小数部分を分離して取得
        - clamp.scad 値を値域の範囲内へ丸める
    - text/ 文字列ライブラリー
        - substring/ 部分文字列
            - substring_left.scad 左端から一定文字数を取得
            - substring_length.scad 部分文字列を始点位置と文字数から取得
            - substring_range.scad 部分文字列を始点位置と末尾位置から取得
            - substring_right.scad 右端から一定文字数を取得
        - number_to_string_with_digit.scad 桁を指定して数値を文字列化
    - color/ 色ライブラリー
        - HSL.scad HSL色空間を扱う
    - angle/ 角度ライブラリー
        - angle_step.scad 角度範囲のステップ角を生成
        - distance_of_angle_range.scad 角度範囲の距離 (deg)
        - make_angle_range.scad 角度範囲を生成
        - normalize_angle.scad 角度を正規化

(†1): ここでの用語と意図

- 1次のvector:=[1,2,3]
- 2次のvector:=[[1,2],[3,4],[5,6]]
- 3次のvector:=[[[1,-1],[2,-2]],[[3,-3],[4,-4]],[[5,-5],[6,-6]]]

### JIS規格ねじライブラリー部 ( part/screw.scad )

1. JIS/ISO 規格を元にした造形の「メートルねじ」の「ボルト」類を生成できます
   1. JIS B 1176 六角穴付きボルト
   2. JIS B 1177 六角穴付き止めねじ
   3. JIS B 1180 六角ボルト
      1. 2014本体規格
      2. 2014附属書JA
2. JIS/ISO 規格を元にした造形の「メートルねじ」の「ナット」を生成できます
   1. JIS B 1181:2014 以降の本体規格
      1. スタイル1
      2. スタイル2
      3. C
      4. 低
      - 面取り 両面/片面/なし オプション対応
      - ワッシャーフェイス なし/あり オプション対応
   2. JIS B 1181:2004 までの附属書規格
      1. 六角/1種
      2. 六角/2種
      3. 六角/3種
      4. 六角/4種
      5. 小型六角/1種
      6. 小型六角/2種
      7. 小型六角/3種
      8. 小型六角/4種
3. JIS/ISO 規格を元にした造形の「メートルねじ」の「ワッシャー」類を生成できます
   1. JIS B 1256:2008 本体規格
      1. 小形
      2. 並形/部品等級A
      3. 並形/部品等級C
      4. 並形面取り
      5. 大形/部品等級A
      6. 大形/部品等級C
      7. 特大形
   2. JIS B 1256:2008 附属書規格
      1. 角座金/小形角
      2. 角座金/大形角
4. 「JIS/ISO 規格の螺子に対応」する「スペーサー」類を生成できます
   1. 上部/下部それぞれ凸螺子付き/凹螺子付き/螺子なし/ただの穴(螺子山なし谷底隙間相当のクリアランスあり)に対応
      1. スペーサー、足、連結を造形できます
   2. 胴体は外径指定できる丸、二面幅指定できる六角、その他の四角、八角などお好みの任意角に対応
5. その他
   1. 規格外の設定値を与えるとわりと優しく丁寧なECHOでどのパラメーターが規格外か注意を表示したり適当な候補を表示したりしてくれます

### Tester

- [test/3d-printer.scad](test/3d-printer.scad)
  - 3Dプリンターの精度をJIS/ISO規格の螺子やナットを使って簡単にテストできるテスター

## Usage

1. `include <usagi.scad>`
2. [example/part/screw.scad](example/part/screw.scad) を眺めたり、必要なら [usagi.scad](usagi.scad) のソースコードコメントやソースコード本体を読んで使い方を察してお使い下さい。

Note: 将来的にライブラリーをヘッダーとAPIドキュメンテーション的な部分と実装詳細的な部分や機能単位に分割するカモしれません。気が向いたら。

## Screenshots

https://imgur.com/a/e6oNACb に置きました。

## Contribution

Issue / PR 歓迎です。 fork しっぱなしもご自由にどうぞ。

- 誤りを発見した場合
  -  -> Issues へご報告下さい or PR を頂ければ幸いです
     -  優しく、明瞭に、意図や正誤を確認するために必要な参照すべき何かしらを十分にご提示頂ければ幸いです
     -  Issues は日本語または English で頂ければ幸いです
- 新機能や改良を思いついた場合
  -  -> fork して実装してみてうまくいったら PR を頂けると嬉しいです
     -  merge に至った場合は原作者の独断と偏見により判断し、 Authors または Contributors へ表記追加いたします

対応が遅かったり、気づいていなさそうな時はメンションでpingあるいはアクティブそうに見えるSNSで呼んでみてください。(即応や確実な対応は保証できませんが悪しからずご理解頂ければ幸いです)

Note: この repos ではリポジトリーの軽量を維持したいため .STL 化したデータは格納しないつもりです。とはいえ、高分解能で扱いレンダリングしようとすると OpenSCAD は重いので、このライブラリーを元に .STL 化したデータは気が向いたらそのうちどこか、あるいは release の .zip 添付機能など使い提供するかもしれません。

## License

[MIT](LICENCE)

## Author

- Name: Usagi Ito
- Website: USAGI.NETWORK <https://usagi.network>

## Special Thanks

usagi.scad は↓のライブラリーを fork して作り始めました。OpenSCADでの基礎的な螺子生成のアイデアと実装例としてとても助かりました。ありがとうございます。

- Poor_mans_openscad_screw_library
    - Source: <https://www.thingiverse.com/thing:8796>
    - License: Public Domain

usagi.scad は↓の YouTube で OpenSCAD における基礎的な歯車生成のアイデアと実装例を学びました。ありがとうございます。

- OpenScad (урок №6 GEAR (ШЕСТЕРНЯ №2))
  - YouTube <https://www.youtube.com/watch?v=AOqM_Bkg9fY>

## References

このライブラリーの作成にあたり、↓を参照しました。ISO/JIS規格の引用や解説をはじめかっこいい螺子をモデリングするためにたいへん役立ちました。ありがとうございます。

1. ネジ
   1. URK 宇都宮螺子株式会社 よく分かる規格ねじ <https://www.urk.co.jp/contents/contents.html>
   2. KONOE 株式会社コノエ ねじの資料 <http://www.konoe.co.jp/reference/menu01.html>
   3. kikakuri.com B 0205-4 : 2001 (ISO 724 : 1993) <https://kikakurui.com/b0/B0205-4-2001-01.html>
   4. NBK ISO General Purpose Metric Screw Threads <https://www.nbk1560.com/~/media/PDF/en/technical/012_ISO%20General%20Purpose%20Metric%20Screw%20Threads.ashx>
   5. 締結.jp ねじの技術資料 1 ねじの基本（基準寸法） <http://teiketsu.jp/user_data/packages/default/hp_pdf/technology_01.pdf>
   6. MekatoroNet 一般用メートルねじ：基準寸法 <http://www.mekatoro.net/digianaecatalog/sugat-sougou/book/sugat-sougou-P1568.pdf>
   7. 池田金属工業株式会社 一般規格品一覧 <http://www.ikekin.co.jp/contents/catalog/standard/index.html>
   8. 島根大学　総合理工学部　機械・電気電子工学科　機械設計研究室 機械設計製図 （第六回目） <http://www.ecs.shimane-u.ac.jp/~shutingli/MDDNo6.pdf>
   9.  サンワ・アイ 2014年 JIS規格移行問題 六角ナット どこが変わる？ <http://www.sanwa-i.co.jp/labo/report/j5.html>
   10. kikakuri.com B 1181：2014 <https://kikakurui.com/b1/B1181-2014-01.html>
   11. 日本ねじ商工連盟 六角ボルト・ナット 附属書品から本体規格品への切り替えガイド <http://www.fij.or.jp/jis-guide/>
   12. 岡總株式会社 ISO規格 ISO 8.8 ISO 10.9 強力六角ボルト <http://www.okaso.co.jp/docs/business/product/product_iso.php>
   13. GlobalFastener.com <http://www.globalfastener.com/>
   14. KEYCHATTER Unpacking The Kailh Box Switch Debacle <https://www.keychatter.com/2018/08/16/unpacking-the-kailh-box-switch-debacle/>
2.  面取り
    1. Misuri 【面取り加工】代表的なc面取りなどの方法や種類をVA・VE事例を交えて紹介! <https://mitsu-ri.net/articles/chamfer-corner-cut>
3.  OpenSCAD & misc.
    1. アニメーション
       1. PRUSAPRINTERS BLOG How to animate models in OpenSCAD <https://blog.prusaprinters.org/how-to-animate-models-in-openscad/>
       2. Hammad M Using ffmpeg to convert a set of images into a video <https://hamelot.io/visualization/using-ffmpeg-to-convert-a-set-of-images-into-a-video/>

### JIS 規格

JISC データベース検索 JIS検索 <https://www.jisc.go.jp/app/jis/general/GnrJISSearch.html>

- 部品
  - JIS B 1176 = 六角穴付きボルト; Hexagon Socket Head Cap Screws
  - JIS B 1177 = 六角穴付き止めねじ; Hexagon Socket Set Screws
  - JIS B 1180 = 六角ボルト; Hexagon Head Screw Bolt
  - JIS B 1181 = 六角ナット; Hexagon Nut
  - JIS B 1256 = 平座金 (ワッシャー); Plain Washer
- 工具
  - JIS B 4648 = 六角棒スパナー (六角凹を回すスパナー)
  - JIS B 4630 = スパナー (コの字で凸二面幅を捉えて回すスパナー)
- 製図
  - JIS B 0001 = 機械製図
