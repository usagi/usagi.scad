include <Cherry_MX.scad>

reference_switch_parameters_Cherry_MX_Blue = 
  [ [ "Cherry MX Blue"
    , concat_without_duplication
      ( reference_switch_parameters_Cherry_MX_Red[ 0 ][ 1 ]
      , [ [ "stem_craw_extruding_map"
          , [ [ 3.20, 0.00 ]
            , [ 6.90, 1.00 ]
            ]
          ]

        , [ "stem_skirt_splitted", true ] // true: ステムのスカート部分がステム本体から分離されるよう造形します(いわゆるクリッキー＆音の大きな青軸っぽくする), false: 分離しない一体化した造形にします
        , [ "stem_skirt_color", [ [ 220, 1, 1 ] ] ]

        , [ "stem_color", to_RGB_from_HSL( [ 220, 1, 0.35 ] ) ]
        ]
      )
    ]
  ];
