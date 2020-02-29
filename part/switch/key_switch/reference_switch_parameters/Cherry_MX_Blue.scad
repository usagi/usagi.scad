include <Cherry_MX_Red.scad>
include <../../../../utility/vector/concat_without_duplication.scad>

reference_switch_parameters_Cherry_MX_Blue = 
  [ [ "Cherry MX Blue"
    , concat_without_duplication
      ( reference_switch_parameters_Cherry_MX_Red[ 0 ][ 1 ]
      , [ [ "stem_craw_extruding_map"
          , [ [ 3.20, 0.40 ]
            , [ 4.00, 0.85 ]
            , [ 5.00, 0.75 ]
            , [ 6.90, 0.90 ]
            ]
          ]
        
        , [ "stem_stage_top_chamfering_parameters" , [ 30, 0.5, "C" ] ]
        , [ "stage_additional_antena", [ 0.65, 0.65, 45 ] ]
        , [ "stage_additional_corner_craw", [ 0.65, 0.10, 0.60 ] ]

        , [ "stem_skirt_height", [ 6.40, 0.00, 5.00 ] ]
        
        , [ "stem_skirt_splitter", [ 1.60, 2.80 ] ]
        
        , [ "stem_rail_width", [ 2.2, 0.0 ] ]
        , [ "stem_rail_height", [ 5.20, 0.0 ] ]

        , [ "stem_bottom_shaft_height",  [ 9.00, 0.80 ] ]

        , [ "stem_color", to_RGB_from_HSL( [ 220, 1, 0.35 ] ) ]
        , [ "stem_skirt_color", to_RGB_from_HSL( [ 0, 1, 1 ] ) ]

        , [ "stem_cross_y_notch_depth", +0.20 ]
        ]
      )
    ]
  ];
