# usagi.scad

わたしが欲しい気がした JIS/ISO 規格に形だけでも互換性の高いボルト類やナットの造形が可能な OpenSCAD のライブラリーです。

![sample_screenshot.png](sample_screenshot.png)

## Motivation

1. 作ってみたかった( OpenSCAD も JIS/ISO 規格も初心者なので修行も兼ねて )
2. JIS 規格に形だけでもそれなりに準拠したボルトやナットを造形できる OpenSCAD の便利のよさそうな OSS ライブラリーを見つけられなかった

## Feature

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
2. [example.scad](example.scad) を眺めたり、必要なら [usagi.scad](usagi.scad) のソースコードコメントやソースコード本体を読んで使い方を察してお使い下さい。

Note: 将来的にライブラリーをヘッダーとAPIドキュメンテーション的な部分と実装詳細的な部分や機能単位に分割するカモしれません。気が向いたら。

## Screenshots

https://imgur.com/a/e6oNACb

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

Usagi Ito

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

1. URK 宇都宮螺子株式会社 よく分かる規格ねじ <https://www.urk.co.jp/contents/contents.html>
2. KONOE 株式会社コノエ ねじの資料 <http://www.konoe.co.jp/reference/menu01.html>
3. kikakuri.com B 0205-4 : 2001 (ISO 724 : 1993) <https://kikakurui.com/b0/B0205-4-2001-01.html>
4. NBK ISO General Purpose Metric Screw Threads <https://www.nbk1560.com/~/media/PDF/en/technical/012_ISO%20General%20Purpose%20Metric%20Screw%20Threads.ashx>
5. 締結.jp ねじの技術資料 1 ねじの基本（基準寸法） <http://teiketsu.jp/user_data/packages/default/hp_pdf/technology_01.pdf>
6. MekatoroNet 一般用メートルねじ：基準寸法 <http://www.mekatoro.net/digianaecatalog/sugat-sougou/book/sugat-sougou-P1568.pdf>
7. 池田金属工業株式会社 一般規格品一覧 <http://www.ikekin.co.jp/contents/catalog/standard/index.html>
8. 島根大学　総合理工学部　機械・電気電子工学科　機械設計研究室 機械設計製図 （第六回目） <http://www.ecs.shimane-u.ac.jp/~shutingli/MDDNo6.pdf>
9. サンワ・アイ 2014年 JIS規格移行問題 六角ナット どこが変わる？ <http://www.sanwa-i.co.jp/labo/report/j5.html>
10. kikakuri.com B 1181：2014 <https://kikakurui.com/b1/B1181-2014-01.html>
11. 日本ねじ商工連盟 六角ボルト・ナット 附属書品から本体規格品への切り替えガイド <http://www.fij.or.jp/jis-guide/>
12. 岡總株式会社 ISO規格 ISO 8.8 ISO 10.9 強力六角ボルト <http://www.okaso.co.jp/docs/business/product/product_iso.php>
13. GlobalFastener.com <http://www.globalfastener.com/>
14. JISC データベース検索 JIS検索 <https://www.jisc.go.jp/app/jis/general/GnrJISSearch.html>
15. KEYCHATTER Unpacking The Kailh Box Switch Debacle <https://www.keychatter.com/2018/08/16/unpacking-the-kailh-box-switch-debacle/>

### Notes

- 部品
  - JIS B 1176 = 六角穴付きボルト; Hexagon Socket Head Cap Screws
  - JIS B 1177 = 六角穴付き止めねじ; Hexagon Socket Set Screws
  - JIS B 1180 = 六角ボルト; Hexagon Head Screw Bolt
  - JIS B 1181 = 六角ナット; Hexagon Nut
  - JIS B 1256 = 平座金 (ワッシャー); Plain Washer
- 工具
  - JIS B 4648 = 六角棒スパナー (六角凹を回すスパナー)
  - JIS B 4630 = スパナー (コの字で凸二面幅を捉えて回すスパナー)
