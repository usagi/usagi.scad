include <Kailh_Choc.scad>
include <../../../../utility/color/HSL.scad>

reference_switch_parameters_Kailh_Choc_Red = 
  [ // おおよそ実物の計測とデータシートから作成
    [ "Kailh Choc Red"
    , concat
      ( reference_switch_parameters_Kailh_Choc
      , [ [ "front_rail_profile" // Cherry MX の stem_craw_extruding_map と同様 [ [ -Z0, -Y0 ], ... ]
          , [ [ 0.70, 0.80 ]
            , [ 4.72, 0.20 ]
            ]
          ]
        , [ "stem_color", to_RGB_from_HSL( [ 0, 1, 0.4 ] ) ] // ステムの色。空にした場合は color を適用せずに造形します
        ]
      )
    ]
  ];
