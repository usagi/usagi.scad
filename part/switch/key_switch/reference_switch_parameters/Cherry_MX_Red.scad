include <Cherry_MX.scad>
include <../../../../utility/color/HSL.scad>

reference_switch_parameters_Cherry_MX_Red = 
  [ // source: https://www.cherrymx.de/en/dev.html
    // source: https://www.keychatter.com/2018/08/16/unpacking-the-kailh-box-switch-debacle/
    // source に掲載のないパラメーターは Author による実測値に基づきます
    [ "Cherry MX Red"
    , concat
      ( reference_switch_parameters_Cherry_MX
      , [ 
        // 爪の出っ張り具合をクロスの乗るステージの高さを Z = 0, ステージ前面を Y = 0 として、
        // 任意の [ -Z 方向への深さ, その深さでの -Y 方向への押し出し長さ ] 群で設定します
        // ( 単純な爪部位ローカル -Z/-Y 平面の座標系での2Dの頂点リストです )
          [ "stem_craw_extruding_map"
          , [ [ 3.20, 0.40 ] // ステージから深さ 3.20 mm で 0.40 mm 押し出す(爪の出っ張りのはじまり)
            , [ 6.90, 1.00 ] // ステージから深さ 6.90 mm で 1.00 mm 押し出し(爪の先端)
            ]
          ]

        , [ "stem_skirt_splitted", false ] // true: ステムのスカート部分がステム本体から分離されるよう造形します(いわゆるクリッキー＆音の大きな青軸っぽくする), false: 分離しない一体化した造形にします
        , [ "stem_skirt_color", [ ] ] // ステムのスカート部分の色をRGB値または空で設定。空にした場合は stem_color が自動的に採用されます

        , [ "stem_color", to_RGB_from_HSL( [ 0, 1, 0.4 ] ) ] // ステムの色。空にした場合は color を適用せずに造形します
        ]
      )
    ]
  ];
