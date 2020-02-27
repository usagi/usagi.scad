include <Cherry_MX.scad>

reference_switch_parameters_Cherry_MX_Speed_Silver = 
  [ [ "Cherry MX Speed Silver"
    , concat_without_duplication
      ( reference_switch_parameters_Cherry_MX_Red[ 0 ][ 1 ]
      , [ [ "stem_craw_extruding_map"
          , [ [ 3.20, 0.00 ]
            , [ 6.90, 1.00 ]
            ]
          ]
        
        , [ "stem_skirt_bottom_specialization_left"
          , [ [ 6.40, +0.40 ]
            , [ 6.40, -0.80 ]
            , [ 7.50, -1.00 ]
            , [ 7.50, -1.60 ]
            , [ 7.10, -1.80 ]
            , [ 7.10, -3.30 ]
            , [ 7.50, -3.40 ]
            , [ 7.50, -4.10 ]
            , [ 5.75, -4.50 ]
            , [ 5.75, -5.35 ]
            ]
          ]
        
        , [ "stem_skirt_bottom_specialization_right"
          , [ [ 6.00, +0.30 ]
            , [ 6.00, -0.70 ]
            , [ 7.50, -1.00 ]
            , [ 7.50, -1.60 ]
            , [ 7.10, -1.80 ]
            , [ 7.10, -3.30 ]
            , [ 7.50, -3.40 ]
            , [ 7.50, -4.10 ]
            , [ 5.75, -4.50 ]
            , [ 5.75, -5.35 ]
            ]
          ]

        , [ "stem_craw_tip_width", 0.45 ]

        , [ "stem_skirt_splitted", false ] // true: ステムのスカート部分がステム本体から分離されるよう造形します(いわゆるクリッキー＆音の大きな青軸っぽくする), false: 分離しない一体化した造形にします
        , [ "stem_skirt_color", [ ] ] // ステムのスカート部分の色をRGB値または空で設定。空にした場合は stem_color が自動的に採用されます

        , [ "stem_color", to_RGB_from_HSL( [ 0, 0, 0.64 ] ) ] // ステムの色。空にした場合は color を適用せずに造形します
        ]
      )
    ]
  ];
