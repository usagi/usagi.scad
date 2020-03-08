include <Kailh_Choc.scad>
include <../../../../utility/color/HSL.scad>

reference_switch_parameters_Kailh_Choc_Brown = 
  [ // おおよそ実物の計測とデータシートから作成
    [ "Kailh Choc Brown"
    , concat
      ( reference_switch_parameters_Kailh_Choc
      , [ [ "front_rail_profile" // Cherry MX の stem_craw_extruding_map と同様 [ [ ステージ丈夫からの深さ(-Z), 前面レールの前面部からの深さ(+Y) ], ... ]
          , [ [ 0.70, 0.75 ]
            , [ 1.96, 0.75 ]
            , [ 3.30, 0.32 ]
            , [ 4.22, 0.32 ]
            , [ 4.72, 0.24 ]
            ]
          ]
        , [ "stem_color", to_RGB_from_HSL( [ 0, 0.56, 0.11 ] ) ]
        ]
      )
    ]
  ];
