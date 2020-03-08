include <Kailh_Choc_Red.scad>
include <../../../../utility/vector/concat_without_duplication.scad>

reference_switch_parameters_Kailh_Choc_White = 
  [ // おおよそ実物の計測とデータシートから作成
    [ "Kailh Choc White"
    , concat_without_duplication
      ( reference_switch_parameters_Kailh_Choc_Red[ 0 ][ 1 ]
      , [ [ "front_rail_profile" // Cherry MX の stem_craw_extruding_map と同様 [ [ ステージ上部からの深さ(-Z), 前面レールの前面部からの深さ(+Y) ], ... ]
          , [ [ 0.70, 0.70 ]
            , [ 4.72, 0.34 ]
            ]
          ]
        , [ "back_craw_profile" // Choc 系のクリッキー用の背面の凸 [ [ ステージ上部からの深さ(-Z), 背面からの突き出し長さ(-Y) ], ... ]
          , [ [ 2.10, 0.00 ]
            , [ 3.60, 1.20 ]
            , [ 4.00, 1.50 ]
            , [ 4.00, 1.50 ]
            , [ 4.45, 1.50 ]
            , [ 4.72, 0.00 ]
            ]
          ]
        , [ "stem_color", [ 1, 1, 1 ] ] // ステムの色。空にした場合は color を適用せずに造形します
        , [ "stage_longitudinal_hole_position", [ ] ] // 穴を開けない
        ]
      )
    ]
  ];
