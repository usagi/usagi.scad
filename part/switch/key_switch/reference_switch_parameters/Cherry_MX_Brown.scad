include <Cherry_MX.scad>
include <../../../../utility/color/HSL.scad>

reference_switch_parameters_Cherry_MX_Brown = 
  [ [ "Cherry MX Brown"
    , concat
      ( reference_switch_parameters_Cherry_MX
      , [ [ "stem_craw_extruding_map"
          , [ [ 3.20, 0.40 ]
            , [ 4.00, 0.85 ]
            , [ 5.00, 0.75 ]
            , [ 6.90, 0.90 ]
            ]
          ]

        , [ "stem_skirt_splitted", false ]
        , [ "stem_skirt_color", [ ] ]

        , [ "stem_color", to_RGB_from_HSL( [ 0, 0.56, 0.11 ] ) ] // ステムの色。空にした場合は color を適用せずに造形します
        ]
      )
    ]
  ];
