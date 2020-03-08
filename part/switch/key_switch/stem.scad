include <../../../utility/vector/reverse.scad>
include <../../../geometry/chamfered_cube.scad>
include <../../../geometry/chamfered_hole.scad>
include <../../../geometry/rounded_cube.scad>
include <../../../part/shaft.scad>

/// Cherry MX に近い形状のステムを造形します
/// @note 実際の Cherry 製のステムには側面のスカート部の下部には僅かに厚みの変化する高さがありますが、
///       スイッチとしての機能にはおそらくまったく関与しないか、むしろ悪い影響があるような気がするので
///       その部分は再現しません。
/// @param data 造形パラメーターの key-value リストです; example や reference_switch_parameters を参考に与えて下さい
/// @param enable_cap_connector true:クロス部分を造形します, false:しません
/// @param enable_stage true:ステージ部分を造形します, false:しません
/// @param enable_rails true:レール部分を造形します, false:しません
/// @param enable_shaft true:シャフト部分を造形します, false:しません
/// @param enable_skirt true:スカート部分を造形します, false:しません
module key_switch_stem
( data
, enable_cap_connector = true
, enable_stage = true
, enable_rails = true
, enable_shaft = true
, enable_skirt = true
)
{
  type_index = search( [ "type" ], data )[ 0 ];
  if ( type_index != [ ] )
  {
    type = data[ type_index ][ 1 ];
    if ( type == "MX" )
      _key_switch_stem_MX( data, enable_cap_connector, enable_stage, enable_rails, enable_shaft, enable_skirt );
    else if ( type == "Choc" )
      _key_switch_stem_Choc( data, enable_cap_connector, enable_stage, enable_rails, enable_shaft, enable_skirt );
    else
      echo( str( "key_switch_stem: 不明な type (", type, ") です。 MX または Choc の何れかにしか対応していません。" ) );
  }
}

module _key_switch_stem_Choc
( data
, enable_cap_connector = true
, enable_stage = true
, enable_rails = true
, enable_shaft = true
, enable_skirt = true
)
{
  indices = 
    search
    ( [ "top_hole_distance"
      , "top_hole_size"
      , "stage_hole_apertural_angle"
      , "stage_hole_apertural_length"
      , "stage_size"
      , "stage_r"
      , "shaft_size"
      , "bottom_hole_size"
      , "side_wing_size"
      , "front_rail_outer_size"
      , "front_rail_outer_thickness"
      , "front_rail_profile"
      , "back_craw_profile"
      , "back_craw_width"
      , "back_craw_position"
      , "stage_longitudinal_hole_width"
      , "stage_longitudinal_hole_position"
      , "stem_color"
      , "shaft_chamfering_parameters"
      ]
    , data
    );

  // data から必要なパラメーター群を取得
  top_hole_distance                 = data[ indices[  0 ] ][ 1 ];
  top_hole_size                     = data[ indices[  1 ] ][ 1 ];
  stage_hole_apertural_angle        = data[ indices[  2 ] ][ 1 ];
  stage_hole_apertural_length       = data[ indices[  3 ] ][ 1 ];
  stage_size                        = data[ indices[  4 ] ][ 1 ];
  stage_r                           = data[ indices[  5 ] ][ 1 ];
  shaft_size                        = data[ indices[  6 ] ][ 1 ];
  bottom_hole_size                  = data[ indices[  7 ] ][ 1 ];
  side_wing_size                    = data[ indices[  8 ] ][ 1 ];
  front_rail_outer_size             = data[ indices[  9 ] ][ 1 ];
  front_rail_outer_thickness        = data[ indices[ 10 ] ][ 1 ];
  front_rail_profile                = data[ indices[ 11 ] ][ 1 ];
  back_craw_profile                 = indices[ 12 ] != [] ? data[ indices[ 12 ] ][ 1 ] : [];
  back_craw_width                   = data[ indices[ 13 ] ][ 1 ];
  back_craw_position                = data[ indices[ 14 ] ][ 1 ];
  stage_longitudinal_hole_width     = data[ indices[ 15 ] ][ 1 ];
  stage_longitudinal_hole_position = data[ indices[ 16 ] ][ 1 ];
  stem_color                        = data[ indices[ 17 ] ][ 1 ];
  shaft_chamfering_parameters       = data[ indices[ 18 ] ][ 1 ];

  module _stage()
  {
    translate( [ 0, 0, -stage_size[ 2 ] ] )
      rounded_cube( stage_size, stage_r, center = [ true, true, false ] );
  }

  module _top_holes()
  {
    for ( x = [ +1, -1 ] )
      translate( [ x * top_hole_distance / 2, 0, 0 ] )
        chamfered_hole( top_hole_size, apertural_angle = stage_hole_apertural_angle, apertural_length = stage_hole_apertural_length, center = true );
  }

  module _front_rail()
  {
    difference()
    {
      front_rail_size = [ front_rail_outer_size[ 0 ] , front_rail_outer_size[ 1 ] + stage_r * 2, stage_size[ 2 ] ];
      translate( [ 0, -stage_size[ 1 ] / 2 - front_rail_outer_size[ 1 ], -stage_size[ 2 ] ] )
        rounded_cube( front_rail_size, stage_r, center = [ true, false, false ] );
      
      profile_first = front_rail_profile[ 0 ];
      profile_last  = front_rail_profile[ len( front_rail_profile ) - 1 ];

      vertices = 
        [ [ profile_first[ 0 ], -1 ]
        , for ( v = front_rail_profile )
            v
        , [ profile_last[ 0 ], -1 ]
        ];
      
      translate( [ 0, -stage_size[ 1 ] / 2 - front_rail_outer_size[ 1 ], 0 ] )
      // rotate( [ 0, 0, 90 ] )
         rotate( [ 0, 90, 0 ] )
      //     rotate( [ 90, 0, 0 ] )
            linear_extrude( front_rail_outer_size[ 0 ] - front_rail_outer_thickness * 2, center = true )
              polygon( vertices );
    }
  }

  module _side_rail()
  {
    dx = stage_r * 2;
    s = side_wing_size + [ dx, 0, 0 ];
    translate( [ -dx, 0, -stage_size[ 2 ] ] )
      rounded_cube( s, stage_r, center = [ false, true, false ] );
  }

  module _side_rails()
  {
    for ( x = [ +1, -1 ] )
      rotate( [ 0, 0, x > 0 ? 0 : 180 ] )
        translate( [ stage_size[ 0 ] / 2, 0, 0 ] )
          _side_rail();
  }

  module _stage_bottom_hole()
  {
    translate( [ 0, 0, -stage_size[ 2 ] ] )
      rotate( [ 180, 0, 0 ] )
        chamfered_hole( bottom_hole_size, hole_type = "cylinder", apertural_angle = stage_hole_apertural_angle, apertural_length = stage_hole_apertural_length, center = true );
  }

  module _shaft()
  {
    translate( [ 0, 0, -shaft_size[ 1 ] ] )
      shaft( shaft_size[ 0 ], shaft_size[ 1 ] - 1.0e-2, chamfering_parameters = shaft_chamfering_parameters );
  }

  module _back_craw()
  {
    if ( back_craw_profile != [ ] )
    {
      profile_first = back_craw_profile[ 0 ];
      profile_last  = back_craw_profile[ len( back_craw_profile ) - 1 ];
      
      vertices = 
        [ [ profile_first[ 0 ], -1 ]
        , for ( v = back_craw_profile )
            v
        , [ profile_last[ 0 ], -1 ]
        ];
      
      translate( [ back_craw_position, stage_size[ 1 ] / 2, 0 ] )
        rotate( [ 0, 90, 0 ] )
          linear_extrude( back_craw_width )
            polygon( vertices );
    }
  }

  module _stage_longitudinal_hole()
  {
    vertices = 
      [ [ +0.5 * stage_longitudinal_hole_width, 0                         ]
      , [ +1.5 * stage_longitudinal_hole_width, +stage_size[ 1 ]          ]
      , [ +1.5 * stage_longitudinal_hole_width, +stage_size[ 1 ] + 1.0e-2 ]
      , [ -1.5 * stage_longitudinal_hole_width, +stage_size[ 1 ] + 1.0e-2 ]
      , [ -1.5 * stage_longitudinal_hole_width, +stage_size[ 1 ]          ]
      , [ -0.5 * stage_longitudinal_hole_width, 0                         ]
      , [ -1.5 * stage_longitudinal_hole_width, -stage_size[ 1 ]          ]
      , [ -1.5 * stage_longitudinal_hole_width, -stage_size[ 1 ] - 1.0e-2 ]
      , [ +1.5 * stage_longitudinal_hole_width, -stage_size[ 1 ] - 1.0e-2 ]
      , [ +1.5 * stage_longitudinal_hole_width, -stage_size[ 1 ]          ]
      ];

    rotate( [ 0, 90, 0 ] )
      linear_extrude( stage_longitudinal_hole_width, center = true )
        polygon( vertices );
  }

  module _stage_longitudinal_holes()
  {
    if ( stage_longitudinal_hole_position != [ ] )
      for ( x = [ +1, -1 ] )
        rotate( [ 0, 0, x > 0 ? 0 : 180 ] )
          translate( [ stage_longitudinal_hole_position[ 0 ], 0, stage_longitudinal_hole_position[ 1 ] ] )
            _stage_longitudinal_hole();
  }

  color( stem_color )
  union()
  {
    // stage
    if ( enable_stage )
      difference()
      {
        union()
        {
          _stage();
          _front_rail();
          _back_craw();
        }

        if ( enable_cap_connector )
          _top_holes();
        
        _stage_bottom_hole();

        _stage_longitudinal_holes();
      }
    
    // side rails
    if ( enable_rails )
      _side_rails();
    
    // shaft
    if ( enable_shaft )
      _shaft();
  }
}

module _key_switch_stem_MX
( data
, enable_cap_connector = true
, enable_stage = true
, enable_rails = true
, enable_shaft = true
, enable_skirt = true
)
{
  // data から必要なパラメーター群の index 群を取得
  indices = 
    search
    ( [ "stem_cross_x_bar"
      , "stem_cross_y_bar"
      , "stem_cross_z"
      , "housing_bottom_outer_size"
      , "housing_height"
      , "stem_stage_size"
      , "stem_stage_hole_diameter"
      , "stem_stage_hole_height"
      , "stem_bottom_shaft_diameter"
      , "stem_bottom_shaft_height"
      , "stem_bottom_shaft_chamfering_angle"
      , "stem_bottom_shaft_chamfering_length"
      , "stem_stage_top_chamfering_parameters"
      , "stem_stage_side_chamfering_parameters"
      , "stem_skirt_height"
      , "stem_skirt_thickness"
      , "stem_rail_width"
      , "stem_rail_thickness"
      , "stem_rail_height"
      , "stem_skirt_notch_length"
      , "stem_craw_extruding_map"

      , "stem_color"
      , "stem_skirt_color"

      , "stem_cross_x_bar_top_chamfering_parameters"
      , "stem_cross_x_bar_right_chamfering_parameters"
      , "stem_cross_x_bar_left_chamfering_parameters"
      , "stem_cross_x_bar_front_chamfering_parameters"
      , "stem_cross_x_bar_back_chamfering_parameters"
      , "stem_cross_x_bar_top_front_chamfering_parameters"
      , "stem_cross_x_bar_top_back_chamfering_parameters"
      , "stem_cross_x_bar_top_right_chamfering_parameters"
      , "stem_cross_x_bar_top_left_chamfering_parameters"
      , "stem_cross_x_bar_front_right_chamfering_parameters"
      , "stem_cross_x_bar_front_left_chamfering_parameters"
      , "stem_cross_x_bar_back_right_chamfering_parameters"
      , "stem_cross_x_bar_back_left_chamfering_parameters"

      , "stem_cross_y_bar_top_chamfering_parameters"
      , "stem_cross_y_bar_right_chamfering_parameters"
      , "stem_cross_y_bar_left_chamfering_parameters"
      , "stem_cross_y_bar_front_chamfering_parameters"
      , "stem_cross_y_bar_back_chamfering_parameters"
      , "stem_cross_y_bar_top_front_chamfering_parameters"
      , "stem_cross_y_bar_top_back_chamfering_parameters"
      , "stem_cross_y_bar_top_right_chamfering_parameters"
      , "stem_cross_y_bar_top_left_chamfering_parameters"
      , "stem_cross_y_bar_front_right_chamfering_parameters"
      , "stem_cross_y_bar_front_left_chamfering_parameters"
      , "stem_cross_y_bar_back_right_chamfering_parameters"
      , "stem_cross_y_bar_back_left_chamfering_parameters"

      , "stem_cross_y_notch_depth"
      , "stem_cross_y_notch_z_position"
      , "stem_cross_y_notch_chamfering_angle"
      , "stem_cross_y_notch_height"

      , "stem_cross_x_bar_extruding"
      , "stem_cross_x_bar_extruding_chamfering_parameters"

      , "stem_cross_x_bar_inset_width"

      , "stem_craw_tip_width"
      , "stem_craw_electric_contact_clearance"

      , "stem_rail_chamfering_parameters"

      , "stem_skirt_side_shrinking"
      , "stem_skirt_bottom_specialization_left"
      , "stem_skirt_bottom_specialization_right"

      , "stem_skirt_splitter"
      , "splitted_part_enabling"
      , "stem_skirt_splitted_holes"
      , "stem_skirt_splitted_craw_width"
      , "stem_skirt_splitted_craw_thickness"
      , "stem_skirt_splitted_craw_arm_positions"

      , "stage_additional_antena"
      , "stage_additional_corner_craw"
      ]
    , data
    );

  // data から必要なパラメーター群を取得
  cxxy                                = data[ indices[  0 ] ][ 1 ];
  cyxy                                = data[ indices[  1 ] ][ 1 ];
  cz                                  = data[ indices[  2 ] ][ 1 ];
  housing_bottom_outer_size           = data[ indices[  3 ] ][ 1 ];
  housing_height                      = data[ indices[  4 ] ][ 1 ];
  stem_stage_size                     = data[ indices[  5 ] ][ 1 ];
  stem_stage_hole_diameter            = data[ indices[  6 ] ][ 1 ];
  stem_stage_hole_height              = data[ indices[  7 ] ][ 1 ];
  stem_bottom_shaft_diameter          = data[ indices[  8 ] ][ 1 ];
  stem_bottom_shaft_height            = data[ indices[  9 ] ][ 1 ];
  stem_bottom_shaft_chamfering_angle  = data[ indices[ 10 ] ][ 1 ];
  stem_bottom_shaft_chamfering_length = data[ indices[ 11 ] ][ 1 ];
  stem_stage_top_chamfering_parameters  = data[ indices[ 12 ] ][ 1 ];
  stem_stage_side_chamfering_parameters = data[ indices[ 13 ] ][ 1 ];
  stem_skirt_height                   = data[ indices[ 14 ] ][ 1 ];
  stem_skirt_thickness                = data[ indices[ 15 ] ][ 1 ];
  stem_rail_width                     = data[ indices[ 16 ] ][ 1 ];
  stem_rail_thickness                 = data[ indices[ 17 ] ][ 1 ];
  stem_rail_height                    = data[ indices[ 18 ] ][ 1 ];
  stem_skirt_notch_length             = data[ indices[ 19 ] ][ 1 ];
  stem_craw_extruding_map             = data[ indices[ 20 ] ][ 1 ];
  stem_color                          = indices[ 21 ] != [ ] ? data[ indices[ 21 ] ][ 1 ] : [ ];
  stem_skirt_color                    = indices[ 22 ] != [ ] ? data[ indices[ 22 ] ][ 1 ] : stem_color;

  stem_cross_x_bar_top_chamfering_parameters          = indices[ 23 ] != [ ] ? data[ indices[ 23 ] ][ 1 ] : [ ];
  stem_cross_x_bar_right_chamfering_parameters        = indices[ 24 ] != [ ] ? data[ indices[ 24 ] ][ 1 ] : [ ];
  stem_cross_x_bar_left_chamfering_parameters         = indices[ 25 ] != [ ] ? data[ indices[ 25 ] ][ 1 ] : [ ];
  stem_cross_x_bar_front_chamfering_parameters        = indices[ 26 ] != [ ] ? data[ indices[ 26 ] ][ 1 ] : [ ];
  stem_cross_x_bar_back_chamfering_parameters         = indices[ 27 ] != [ ] ? data[ indices[ 27 ] ][ 1 ] : [ ];
  stem_cross_x_bar_top_front_chamfering_parameters    = indices[ 28 ] != [ ] ? data[ indices[ 28 ] ][ 1 ] : [ ];
  stem_cross_x_bar_top_back_chamfering_parameters     = indices[ 29 ] != [ ] ? data[ indices[ 29 ] ][ 1 ] : [ ];
  stem_cross_x_bar_top_right_chamfering_parameters    = indices[ 30 ] != [ ] ? data[ indices[ 30 ] ][ 1 ] : [ ];
  stem_cross_x_bar_top_left_chamfering_parameters     = indices[ 31 ] != [ ] ? data[ indices[ 31 ] ][ 1 ] : [ ];
  stem_cross_x_bar_front_right_chamfering_parameters  = indices[ 32 ] != [ ] ? data[ indices[ 32 ] ][ 1 ] : [ ];
  stem_cross_x_bar_front_left_chamfering_parameters   = indices[ 33 ] != [ ] ? data[ indices[ 33 ] ][ 1 ] : [ ];
  stem_cross_x_bar_back_right_chamfering_parameters   = indices[ 34 ] != [ ] ? data[ indices[ 34 ] ][ 1 ] : [ ];
  stem_cross_x_bar_back_left_chamfering_parameters    = indices[ 35 ] != [ ] ? data[ indices[ 35 ] ][ 1 ] : [ ];
  
  stem_cross_y_bar_top_chamfering_parameters          = indices[ 36 ] != [ ] ? data[ indices[ 36 ] ][ 1 ] : [ ];
  stem_cross_y_bar_right_chamfering_parameters        = indices[ 37 ] != [ ] ? data[ indices[ 37 ] ][ 1 ] : [ ];
  stem_cross_y_bar_left_chamfering_parameters         = indices[ 38 ] != [ ] ? data[ indices[ 38 ] ][ 1 ] : [ ];
  stem_cross_y_bar_front_chamfering_parameters        = indices[ 39 ] != [ ] ? data[ indices[ 39 ] ][ 1 ] : [ ];
  stem_cross_y_bar_back_chamfering_parameters         = indices[ 40 ] != [ ] ? data[ indices[ 40 ] ][ 1 ] : [ ];
  stem_cross_y_bar_top_front_chamfering_parameters    = indices[ 41 ] != [ ] ? data[ indices[ 41 ] ][ 1 ] : [ ];
  stem_cross_y_bar_top_back_chamfering_parameters     = indices[ 42 ] != [ ] ? data[ indices[ 42 ] ][ 1 ] : [ ];
  stem_cross_y_bar_top_right_chamfering_parameters    = indices[ 43 ] != [ ] ? data[ indices[ 43 ] ][ 1 ] : [ ];
  stem_cross_y_bar_top_left_chamfering_parameters     = indices[ 44 ] != [ ] ? data[ indices[ 44 ] ][ 1 ] : [ ];
  stem_cross_y_bar_front_right_chamfering_parameters  = indices[ 45 ] != [ ] ? data[ indices[ 45 ] ][ 1 ] : [ ];
  stem_cross_y_bar_front_left_chamfering_parameters   = indices[ 46 ] != [ ] ? data[ indices[ 46 ] ][ 1 ] : [ ];
  stem_cross_y_bar_back_right_chamfering_parameters   = indices[ 47 ] != [ ] ? data[ indices[ 47 ] ][ 1 ] : [ ];
  stem_cross_y_bar_back_left_chamfering_parameters    = indices[ 48 ] != [ ] ? data[ indices[ 48 ] ][ 1 ] : [ ];

  stem_cross_y_notch_depth            = data[ indices[ 49 ] ][ 1 ];
  stem_cross_y_notch_z_position       = data[ indices[ 50 ] ][ 1 ];
  stem_cross_y_notch_chamfering_angle = data[ indices[ 51 ] ][ 1 ];
  stem_cross_y_notch_height           = data[ indices[ 52 ] ][ 1 ];

  stem_cross_x_bar_extruding                            = data[ indices[ 53 ] ][ 1 ];
  stem_cross_x_bar_extruding_chamfering_parameters  = data[ indices[ 54 ] ][ 1 ];

  stem_cross_x_bar_inset_width                            = data[ indices[ 55 ] ][ 1 ];

  stem_craw_tip_width                  = data[ indices[ 56 ] ][ 1 ];
  stem_craw_electric_contact_clearance = data[ indices[ 57 ] ][ 1 ];

  stem_rail_chamfering_parameters = data[ indices[ 58 ] ][ 1 ];

  stem_skirt_side_shrinking = data[ indices[ 59 ] ][ 1 ];
  stem_skirt_bottom_specialization_left = data[ indices[ 60 ] ][ 1 ];
  stem_skirt_bottom_specialization_right = data[ indices[ 61 ] ][ 1 ];

  stem_skirt_splitter = data[ indices[ 62 ] ][ 1 ];
  splitted_part_enabling = data[ indices[ 63 ] ][ 1 ];
  stem_skirt_splitted_holes          = data[ indices[ 64 ] ][ 1 ];
  stem_skirt_splitted_craw_width     = data[ indices[ 65 ] ][ 1 ];
  stem_skirt_splitted_craw_thickness = data[ indices[ 66 ] ][ 1 ];
  stem_skirt_splitted_craw_arm_positions = data[ indices[ 67 ] ][ 1 ];

  stage_additional_antena       = data[ indices[ 68 ] ][ 1 ];
  stage_additional_corner_craw  = data[ indices[ 69 ] ][ 1 ];

  // 原点で作成した後でハウジングに収まる位置へ移動するための移動量
  translation = 
    [ housing_bottom_outer_size[ 0 ] / 2
    , housing_bottom_outer_size[ 1 ] / 2
    , housing_height
    ];

  module _cross_x_inset()
  {
    rotate( [ 90, 0, 0 ] )
    linear_extrude( stem_cross_x_bar_inset_size[ 1 ], center = true )
    chamfered_square
    ( [ stem_cross_x_bar_inset_size[ 0 ], stem_cross_x_bar_inset_size[ 2 ] ]
    , center = [ true, false ]
    , inner_top_chamfering_parameters = stem_cross_x_bar_inset_top_chamfering_parameters
    , outer_top_chamfering_parameters = stem_cross_x_bar_inset_top_chamfering_parameters
    );
  }
  
  module _cross()
  {
    difference()
    {
      union()
      {
        chamfered_cube
        ( size = [ cxxy[ 0 ], cxxy[ 1 ], cz ]
        , center = [ true, true, false ]
        , top_chamfering_parameters         = stem_cross_x_bar_top_chamfering_parameters
        , right_chamfering_parameters       = stem_cross_x_bar_right_chamfering_parameters
        , left_chamfering_parameters        = stem_cross_x_bar_left_chamfering_parameters
        , front_chamfering_parameters       = stem_cross_x_bar_front_chamfering_parameters
        , back_chamfering_parameters        = stem_cross_x_bar_back_chamfering_parameters
        , top_front_chamfering_parameters   = stem_cross_x_bar_top_front_chamfering_parameters
        , top_back_chamfering_parameters    = stem_cross_x_bar_top_back_chamfering_parameters
        , top_right_chamfering_parameters   = stem_cross_x_bar_top_right_chamfering_parameters
        , top_left_chamfering_parameters    = stem_cross_x_bar_top_left_chamfering_parameters
        , front_right_chamfering_parameters = stem_cross_x_bar_front_right_chamfering_parameters
        , front_left_chamfering_parameters  = stem_cross_x_bar_front_left_chamfering_parameters
        , back_right_chamfering_parameters  = stem_cross_x_bar_back_right_chamfering_parameters
        , back_left_chamfering_parameters   = stem_cross_x_bar_back_left_chamfering_parameters
        );

        difference()
        {
          chamfered_cube
          ( size = stem_cross_x_bar_extruding
          , center = [ true, true, false ]
          , top_chamfering_parameters         = stem_cross_x_bar_extruding_chamfering_parameters
          , front_right_chamfering_parameters = stem_cross_x_bar_extruding_chamfering_parameters
          , front_left_chamfering_parameters  = stem_cross_x_bar_extruding_chamfering_parameters
          , back_right_chamfering_parameters  = stem_cross_x_bar_extruding_chamfering_parameters
          , back_left_chamfering_parameters   = stem_cross_x_bar_extruding_chamfering_parameters
          );

          chamfered_cube
          ( size = [ stem_cross_x_bar_extruding[ 0 ] - stem_cross_x_bar_inset_width, stem_cross_x_bar_extruding[ 1 ] * 2, stem_cross_x_bar_extruding[ 2 ] - stem_cross_x_bar_inset_width/2 ]
          , center = [ true, true, false ]
          , top_chamfering_parameters         = stem_cross_x_bar_extruding_chamfering_parameters
          , front_right_chamfering_parameters = stem_cross_x_bar_extruding_chamfering_parameters
          , front_left_chamfering_parameters  = stem_cross_x_bar_extruding_chamfering_parameters
          , back_right_chamfering_parameters  = stem_cross_x_bar_extruding_chamfering_parameters
          , back_left_chamfering_parameters   = stem_cross_x_bar_extruding_chamfering_parameters
          );
        }

        chamfered_cube
        ( size = [ cyxy[ 0 ], cyxy[ 1 ], cz ]
        , center = [ true, true, false ]
        , top_chamfering_parameters         = stem_cross_y_bar_top_chamfering_parameters
        , right_chamfering_parameters       = stem_cross_y_bar_right_chamfering_parameters
        , left_chamfering_parameters        = stem_cross_y_bar_left_chamfering_parameters
        , front_chamfering_parameters       = stem_cross_y_bar_front_chamfering_parameters
        , back_chamfering_parameters        = stem_cross_y_bar_back_chamfering_parameters
        , top_front_chamfering_parameters   = stem_cross_y_bar_top_front_chamfering_parameters
        , top_back_chamfering_parameters    = stem_cross_y_bar_top_back_chamfering_parameters
        , top_right_chamfering_parameters   = stem_cross_y_bar_top_right_chamfering_parameters
        , top_left_chamfering_parameters    = stem_cross_y_bar_top_left_chamfering_parameters
        , front_right_chamfering_parameters = stem_cross_y_bar_front_right_chamfering_parameters
        , front_left_chamfering_parameters  = stem_cross_y_bar_front_left_chamfering_parameters
        , back_right_chamfering_parameters  = stem_cross_y_bar_back_right_chamfering_parameters
        , back_left_chamfering_parameters   = stem_cross_y_bar_back_left_chamfering_parameters
        );
      }

      if ( stem_cross_y_notch_depth != 0 )
      {
        translate( [ 0, cyxy[ 1 ] / 2 * ( stem_cross_y_notch_depth > 0 ? -1 : +1 ), stem_cross_y_notch_z_position ] )
        rotate( [  0,  0, 90 ] )
        rotate( [ 90,  0,  0 ] )
        linear_extrude( stem_stage_size[ 0 ], center = true )
        chamfered_square
        ( [ stem_cross_y_notch_depth * 2, stem_cross_y_notch_height ]
        , center = true
        , outer_chamfering_parameters = 
          [ ( stem_cross_y_notch_depth > 0 ? +1 : -1 ) * stem_cross_y_notch_chamfering_angle
          , ( stem_cross_y_notch_depth > 0 ? +1 : -1 ) * stem_cross_y_notch_depth
          , "C"
          ]
        );
      }
    }
  }

  module _rail( splitting_mode = 0 )
  {
    let
    ( // スカート分離とその状況での色分けとOpenSCADの仕様からここでパラメーターを p へ
      // [ 0:太下端Z, 1:細下端Z, 2:太高さZ, 3:細高さZ, 4:all-面取り, 5:top-面取り, 6:bottom-面取り ] で整理する事にしました。
      // 意図の読みやすい変数名を採用するかわりに複数の変数の let に2段三項演算子が
      // 並ぶよりは可読性も保守性もマシだろうと Author は実装当時に考えたのでした。
      p = 
        splitting_mode > 0
          ? [ -stem_skirt_splitter[ 0 ]
            , -stem_skirt_height[ 0 ] + stem_rail_height[ 0 ] - stem_rail_chamfering_parameters[ 1 ]
            , stem_rail_height[ 0 ] - ( stem_skirt_height[ 0 ] - stem_skirt_splitter[ 0 ] )
            , stem_rail_height[ 1 ] - stem_rail_height[ 0 ] + stem_rail_chamfering_parameters[ 1 ]
            , stem_rail_chamfering_parameters
            , stem_rail_chamfering_parameters
            , [ 0, 0, "C" ]
            ]
      : splitting_mode < 0
          ? [ -stem_skirt_height[ 0 ]
            , -stem_skirt_height[ 0 ] + stem_rail_height[ 0 ] - stem_rail_chamfering_parameters[ 1 ]
            , stem_skirt_height[ 0 ] - stem_skirt_splitter[ 1 ]
            , stem_rail_height[ 1 ] - stem_rail_height[ 0 ] + stem_rail_chamfering_parameters[ 1 ]
            , stem_rail_chamfering_parameters
            , [ 0, 0, "C" ]
            , stem_rail_chamfering_parameters
            ]
            // ↓:default
          : [ -stem_skirt_height[ 0 ]
            , -stem_skirt_height[ 0 ] + stem_rail_height[ 0 ] - stem_rail_chamfering_parameters[ 1 ]
            , stem_rail_height[ 0 ]
            , stem_rail_height[ 1 ] - stem_rail_height[ 0 ] + stem_rail_chamfering_parameters[ 1 ]
            , stem_rail_chamfering_parameters
            , stem_rail_chamfering_parameters
            , stem_rail_chamfering_parameters
            ]
    )
      union()
      {
        // 太い方
        translate( [ 0, 0, p[0] ] )
        chamfered_cube
        ( [ stem_rail_thickness, stem_rail_width[ 0 ], p[ 2 ] ]
        , chamfering_parameters = p[ 4 ]
        , top_chamfering_parameters = p[ 5 ]
        , bottom_chamfering_parameters = p [ 6 ]
        , center = [ true, true, false ]
        );
        // 細い方
        if ( stem_rail_width[ 1 ] > 0 )
        {
          translate( [ 0, 0, p[1] ] )
          chamfered_cube
          ( [ stem_rail_thickness, stem_rail_width[ 1 ], p[ 3 ] ]
          , chamfering_parameters = p[ 4 ]
          , top_chamfering_parameters = p[ 5 ]
          , bottom_chamfering_parameters = [ 0, 0, "C" ]
          , center = [ true, true, false ]
          );
        }
      }
  }

  module _rails( splitting_mode = 0 )
  {
    // rail/right
    translate( [ +stem_stage_size[ 0 ] / 2, 0, 0 ] )
    _rail( splitting_mode );
    // rail/left
    translate( [ -stem_stage_size[ 0 ] / 2, 0, 0 ] )
    _rail( splitting_mode );
  }

  module _side_skirt( avoid_electric_contact = true )
  {
    r = reverse( stem_craw_extruding_map );
    rp = r[ 1 ];
    r0 = r[ 0 ];
    drz = r0[ 0 ] - rp[ 0 ];
    dry = r0[ 1 ] - rp[ 1 ];
    dr = dry / drz;
    r1 = r0 - [ 0.00, stem_craw_tip_width ];
    r2z = stem_craw_electric_contact_clearance[ 0 ];
    r2y1r = r1[ 1 ] - dr * ( r1[ 0 ] - r2z );
    r2y1l = r1[ 1 ] - dr * ( r1[ 0 ] - stem_skirt_height[ 0 ] );
    r2y2 = -stem_craw_electric_contact_clearance[ 2 ] - dry / tan( 60 );
    r2v = 
      concat
      ( avoid_electric_contact
          ? [ [ r2z, max( r2y1r, +stem_craw_electric_contact_clearance[ 1 ] ) ]
            , [ stem_craw_electric_contact_clearance[ 0 ], -stem_craw_electric_contact_clearance[ 2 ] ]
            , [ stem_skirt_height[ 0 ], r2y2 ]
            ]
          : [ [ stem_skirt_height[ 0 ], r2y1l ] ]
      , [ [ stem_skirt_height[ 0 ], -stem_stage_size[ 1 ] + stem_stage_side_chamfering_parameters[ 1 ] ] ]
      );
    // back-bottom
    r3 = [ stem_skirt_height[ 0 ], -stem_stage_size[ 1 ] + stem_stage_side_chamfering_parameters[ 1 ] ];
    // back-bottom
    r4 = [ stem_craw_extruding_map[ 0 ][ 0 ], -stem_stage_size[ 1 ] + stem_stage_side_chamfering_parameters[ 1 ] ];
    // back-top
    r5 = [ stem_stage_size[ 2 ], r4[ 1 ] ];
    // front-top
    r6 = [ stem_craw_extruding_map[ 0 ][ 0 ], -stem_stage_side_chamfering_parameters[ 1 ] ];
    
    front_vertices  = concat( [ [ stem_craw_extruding_map[ 0 ][ 0 ], 0 ] ], stem_craw_extruding_map );
    bottom_vertices = 
        concat
        ( [ r1 ]
        , avoid_electric_contact
            ? ( stem_skirt_bottom_specialization_right != [ ]  ? stem_skirt_bottom_specialization_right : r2v )
            : ( stem_skirt_bottom_specialization_left  != [ ]  ? stem_skirt_bottom_specialization_left  : r2v )
        , [ r4, r5, r6 ]
        )
      ;

    vertices =concat( front_vertices, bottom_vertices );

    translate( [ 0, -stem_stage_size[ 1 ] / 2, 0 ] )
    rotate( [ 0, 90, 0 ] )
    rotate( [ 180, 0, 0 ] )
    linear_extrude( stem_skirt_thickness[ 0 ], center = true )
    polygon( vertices );
  }

  // @param splitting_mode 0:全体, >0:分離パターンの上だけ, <0:分離パターンの下だけ
  module _stage( splitting_mode = 0 )
  {
    // この汚いやり方は _rail の同様の箇所のコメントを参照
    // [ 0:translate/z, 1:chamfered_cube/z, 2:chamfered_cube/top_chamfering_parameters ]
    p = 
      splitting_mode > 0
        ? [ -stem_skirt_splitter[ 0 ], stem_skirt_splitter[ 0 ], stem_stage_top_chamfering_parameters ]
    : splitting_mode < 0
        ? [ -stem_stage_size[ 2 ], stem_stage_size[ 2 ] - stem_skirt_splitter[ 1 ], [ 0, 0, "C" ] ]
    // default
        : [ -stem_stage_size[ 2 ], stem_stage_size[ 2 ], stem_stage_top_chamfering_parameters ]
      ;
    
    difference()
    {
      translate( [ -stem_stage_size[ 0 ] / 2, -stem_stage_size[ 1 ] / 2, p[ 0 ] ] )
      chamfered_cube
      ( [ stem_stage_size[ 0 ], stem_stage_size[ 1 ], p[ 1 ] ]
      , top_chamfering_parameters = p[ 2 ]
      , front_right_chamfering_parameters = stem_stage_side_chamfering_parameters
      , front_left_chamfering_parameters = stem_stage_side_chamfering_parameters
      , back_right_chamfering_parameters = stem_stage_side_chamfering_parameters
      , back_left_chamfering_parameters = stem_stage_side_chamfering_parameters
      );

      if ( splitting_mode < 0 )
      {
        translate( [ 0, 0, -stem_stage_size[ 2 ] -1.0e-1 ] )
        linear_extrude( stem_stage_size[ 2 ] - stem_skirt_splitter[ 1 ] + 2.0e-1 )
          polygon
          ( concat
            ( generate_arc_vertices( stem_stage_hole_diameter / 2,  35, 145 )
            , generate_arc_vertices( stem_stage_hole_diameter / 2, 215, 325 )
            )
          );
      }
      else
        translate( [ 0, 0, p[ 0 ] - 1.0e-2 ] )
          cylinder( d = stem_stage_hole_diameter, h = stem_stage_size[ 2 ] - stem_stage_hole_height + 2.0e-2 );
    }

    if ( splitting_mode >= 0 )
    {
      if ( stage_additional_antena != [ ] )
        difference()
        {
          translate( [ stem_stage_size[ 0 ] / 2 - stage_additional_antena[ 0 ] / 2, 0, -stem_stage_top_chamfering_parameters[ 1 ] ] )
            cylinder( d = stage_additional_antena[ 0 ], h = stage_additional_antena[ 1 ] + stem_stage_top_chamfering_parameters[ 1 ] );
          translate( [ stem_stage_size[ 0 ] / 2 - stage_additional_antena[ 0 ] / 2, -stage_additional_antena[ 0 ] / 2, stage_additional_antena[ 1 ] ] )
            rotate( [ 0, 90 - stage_additional_antena[ 2 ], 0 ] )
              cube( [ stage_additional_antena[ 0 ] * 2, stage_additional_antena[ 0 ], stage_additional_antena[ 0 ] ] );
        }
      
      if ( stage_additional_corner_craw != [ ] )
        for ( y = [ +1, -1 ] )
          for ( x = [ +1, -1 ] )
            translate
            ( [ x * ( stem_stage_size[ 0 ] / 2 - stage_additional_corner_craw[ 0 ] / 2 )
              , y * ( stem_stage_size[ 1 ] / 2 + stage_additional_corner_craw[ 1 ] / 2 - stem_stage_top_chamfering_parameters[ 1 ] / 2 )
              , stage_additional_corner_craw[ 2 ] / 2 - stem_skirt_splitter[ 0 ]
              ]
            )
              cube
              ( stage_additional_corner_craw + [ 0, stem_stage_top_chamfering_parameters[ 1 ], 0 ]
              , center = true
              );
    }
  }

  module _skirt( splitting_mode = 0 )
  {
    if ( splitting_mode <= 0 )
    intersection()
    {
      union()
      {
        // back
        if ( stem_skirt_height[ 1 ] > 0 )
        {
          translate( [ stem_skirt_notch_length / 2, stem_stage_size[ 1 ] / 2 - stem_skirt_thickness[ 1 ], -stem_skirt_height[ 1 ] ] )
          chamfered_cube
          ( [ ( stem_stage_size[ 0 ] - stem_skirt_notch_length ) / 2 , stem_skirt_thickness[ 1 ], stem_skirt_height[ 1 ]  - stem_stage_top_chamfering_parameters[ 1 ] ]
          , back_right_chamfering_parameters = stem_stage_side_chamfering_parameters
          );
          translate( [ -( stem_skirt_notch_length / 2 ) - ( stem_stage_size[ 0 ] - stem_skirt_notch_length ) / 2, stem_stage_size[ 1 ] / 2 - stem_skirt_thickness[ 1 ], -stem_skirt_height[ 1 ] ] )
          chamfered_cube
          ( [ ( stem_stage_size[ 0 ] - stem_skirt_notch_length ) / 2 , stem_skirt_thickness[ 1 ], stem_skirt_height[ 1 ]  - stem_stage_top_chamfering_parameters[ 1 ] ]
          , back_left_chamfering_parameters = stem_stage_side_chamfering_parameters
          );
        }

        // side
        translate( [ +stem_stage_size[ 0 ] / 2 - stem_skirt_thickness[ 0 ] / 2, 0, 0 ] )
        _side_skirt();
        translate( [ -stem_stage_size[ 0 ] / 2 + stem_skirt_thickness[ 0 ] / 2, 0, 0 ] )
        _side_skirt( false );
      }

      if ( stem_skirt_side_shrinking )
        union()
        {
          front_margin = 2;
          diff_tickness = stem_skirt_thickness[ 0 ] - stem_skirt_thickness[ 2 ];
          diff_height = stem_bottom_shaft_height[ 0 ] - stem_skirt_height[ 2 ];
          translate( [ -stem_stage_size[ 0 ] / 2 + diff_tickness, -stem_stage_size[ 1 ] / 2 - front_margin, -stem_bottom_shaft_height[ 0 ] ] )
          cube
          ( [ stem_stage_size[ 0 ] - diff_tickness * 2
            , stem_stage_size[ 1 ] + front_margin
            , diff_height
            ]
          );
          
          translate( [ -stem_stage_size[ 0 ] / 2, -stem_stage_size[ 1 ] / 2 - front_margin, -stem_bottom_shaft_height[ 0 ] + diff_height ] )
          cube
          ( [ stem_stage_size[ 0 ]
            , stem_stage_size[ 1 ] + front_margin
            , stem_bottom_shaft_height[ 0 ] - diff_height - ( stem_skirt_splitter != [ ] ? stem_skirt_splitter[ 1 ] : 0 )
            ]
          );
          
        }
    }

  }
  
  module _shaft()
  {
    // shaft
    union()
    {
      translate( [ 0, 0, -stem_bottom_shaft_height[ 0 ] ] )
        shaft
        ( diameter = stem_bottom_shaft_diameter
        , length = stem_bottom_shaft_height[ 0 ]
        , top_chamfering_angle = 0
        , top_chamfering_length = 0
        , bottom_chamfering_angle = stem_bottom_shaft_chamfering_angle
        , bottom_chamfering_length = stem_bottom_shaft_chamfering_length
        );
      
      if ( stem_bottom_shaft_height[ 1 ] > 0 )
        translate( [ 0, 0, -stem_bottom_shaft_height[ 0 ] - stem_bottom_shaft_height[ 1 ] ] )
          cylinder
          ( r = stem_bottom_shaft_diameter / 2 - tan( stem_bottom_shaft_chamfering_angle ) * stem_bottom_shaft_chamfering_length
          , h = stem_bottom_shaft_height[ 1 ]
          );
    }
  }

  module _stage_skirt_rails( splitting_mode = 0 )
  {
    union()
    {
      if ( enable_stage )
        _stage( splitting_mode );
      if ( enable_skirt )
      _skirt( splitting_mode );
      if ( enable_rails )
        _rails( splitting_mode );
    }
  }

  module _stem_splitted_body()
  {
    _stage_skirt_rails( +1 );

    if ( enable_shaft )
      _shaft();
    if ( enable_cap_connector )
      _cross();

    difference()
    {
      z1 = ( stem_skirt_splitted_craw_width[ 0 ] / 2 - stem_skirt_splitted_craw_width[ 1 ] / 2 ) / tan( 45 );
      
      for ( s = [ +1, -1 ] )
      {
        rotate( [ 0, 0, s > 0 ? 0 : 180 ] )
        {
          translate
          ( [ stem_skirt_splitted_craw_arm_positions[ 0 ]
            , 0
            , -stem_skirt_splitter[ 0 ] - stem_skirt_splitted_craw_arm_positions[ 1 ] / 2
            ]
          )
            chamfered_cube
            ( [ stem_skirt_splitted_craw_thickness
              , stem_skirt_splitted_craw_width[ 0 ]
              , stem_skirt_splitted_craw_arm_positions[ 1 ] / 2
              ]
            , bottom_front_chamfering_parameters = [ 45, z1, "C" ]
            , bottom_back_chamfering_parameters  = [ 45, z1, "C" ]
            , center = [ true, true, false ]
            );

          translate
          ( [ stem_skirt_splitted_craw_arm_positions[ 0 ]
            , 0
            , -stem_skirt_splitter[ 0 ] - stem_skirt_splitted_craw_arm_positions[ 1 ]
            ]
          )
            chamfered_cube
            ( [ stem_skirt_splitted_craw_thickness
              , stem_skirt_splitted_craw_width[ 1 ]
              , stem_skirt_splitted_craw_arm_positions[ 1 ] / 2
              ]
            , bottom_left_chamfering_parameters = [ 0, stem_skirt_splitted_craw_thickness / 2, "R" ]
            , center = [ true, true, false ]
            );
          
          translate
          ( [ stem_skirt_splitted_craw_arm_positions[ 0 ] + stem_skirt_splitted_craw_thickness / 2
            , 0
            , -stem_skirt_splitter[ 0 ] - stem_skirt_splitted_craw_arm_positions[ 1 ]
            ]
          )
            chamfered_cube
            ( [ stem_skirt_splitted_craw_arm_positions[ 2 ] - ( stem_skirt_splitted_craw_arm_positions[ 0 ] + stem_skirt_splitted_craw_thickness / 2 )
              , stem_skirt_splitted_craw_width[ 1 ]
              , stem_skirt_splitted_craw_thickness
              ]
            , center = [ false, true, false ]
            );
          
          translate
          ( [ stem_skirt_splitted_craw_arm_positions[ 2 ]
            , 0
            , -stem_skirt_splitter[ 0 ] - stem_skirt_splitted_craw_arm_positions[ 1 ]
            ]
          )
            chamfered_cube
            ( [ stem_skirt_splitted_craw_arm_positions[ 3 ] - stem_skirt_splitted_craw_arm_positions[ 2 ]
              , stem_skirt_splitted_craw_width[ 2 ]
              , stem_skirt_splitted_craw_thickness
              ]
            , center = [ false, true, false ]
            , bottom_right_chamfering_parameters = [ 30, ( stem_skirt_splitted_craw_width[ 2 ] - stem_skirt_splitted_craw_thickness ), "C" ]
            );
        }
      }

      translate( [ 0, 0, -stem_skirt_splitter[ 0 ] - stem_skirt_splitted_craw_arm_positions[ 1 ] ] )
        cylinder( d = stem_stage_hole_diameter, h = stem_skirt_splitted_craw_arm_positions[ 1 ] * 2 + 2.0e-2, center = true );        
    }
  }

  module _stem_splitted_skirt()
  {
    difference()
    {
      _stage_skirt_rails( -1 );

      // 単純な竪穴を下から上へ掘る(上に hole[2] だけ厚みを残す)
      z0 = stem_bottom_shaft_height[ 0 ] - stem_stage_size[ 2 ];
      dz = stem_stage_size[ 2 ] - stem_skirt_splitter[ 1 ];
      for ( hole = stem_skirt_splitted_holes )
        translate( [ -hole[ 0 ] / 2, -hole[ 1 ] / 2, -stem_bottom_shaft_height[ 0 ] ] )
          cube
          ( [ hole[ 0 ]
            , hole[ 1 ]
            , z0 + ( hole[ 2 ] <= 0 ? 1 : ( dz - hole[ 2 ] ) )
            ]
          );
      // 正面から見て菱形を作り両脇のレール上部から内側へのベベルを生成
      translate( [ 0, 0, -stem_skirt_splitter[ 1 ] ] )
      scale( [ 1, 1, 15 / 45 ] )
      rotate( [ 0, 45, 0 ] )
      cube( [ sqrt( 2 ) * stem_stage_size[ 0 ] / 2, stem_skirt_splitted_holes[ 1 ][ 1 ], sqrt( 2 ) * stem_stage_size[ 0 ] / 2 ], center = true );
      // レール上部の彫り込み
      translate( [ stem_stage_size[ 0 ] / 2 + stem_rail_thickness / 2, 0, -stem_skirt_splitter[ 1 ] - stem_rail_chamfering_parameters[ 1 ] ] )
      chamfered_cube
      ( [ stem_rail_thickness - stem_rail_chamfering_parameters[ 1 ] * 2
        , stem_rail_width[ 0 ] - stem_rail_chamfering_parameters[ 1 ] * 2
        , stem_rail_chamfering_parameters[ 1 ] * 2
        ]
      , chamfering_parameters = stem_rail_chamfering_parameters
      , center = [ true, true, false ]
      );
      translate( [ -( stem_stage_size[ 0 ] / 2 + stem_rail_thickness / 2 ), 0, -stem_skirt_splitter[ 1 ] - stem_rail_chamfering_parameters[ 1 ] ] )
      chamfered_cube
      ( [ stem_rail_thickness - stem_rail_chamfering_parameters[ 1 ] * 2
        , stem_rail_width[ 0 ] - stem_rail_chamfering_parameters[ 1 ] * 2
        , stem_rail_chamfering_parameters[ 1 ] * 2
        ]
      , chamfering_parameters = stem_rail_chamfering_parameters
      , center = [ true, true, false ]
      );
    }
  }

  module _stem()
  {
    if ( stem_skirt_splitter == [ ] )
      // スカート分離しないぱたーん
      color( stem_color )
      {
        _stage_skirt_rails();
        if ( enable_shaft )
          _shaft();
        if ( enable_cap_connector )
          _cross();
      }
    else
    { // スカート分離型ぱたーん
      if ( splitted_part_enabling[ 0 ] )
        color( stem_color )
          _stem_splitted_body();
      if ( splitted_part_enabling[ 1 ] )
        color( stem_skirt_color )
          _stem_splitted_skirt();
    }
  }

  _stem();
}
