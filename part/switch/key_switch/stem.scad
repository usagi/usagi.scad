include <../../../utility/vector/reverse.scad>

/// Cherry MX に近い形状のステムを造形します
/// @note 実際の Cherry 製のステムには側面のスカート部の下部には僅かに厚みの変化する高さがありますが、
///       スイッチとしての機能にはおそらくまったく関与しないか、むしろ悪い影響があるような気がするので
///       その部分は再現しません。
module key_switch_stem( data )
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
      , "stem_stage_chamfering_angle"
      , "stem_stage_chamfering_length"
      , "stem_skirt_height"
      , "stem_skirt_thickness"
      , "stem_rail_width"
      , "stem_rail_thickness"
      , "stem_rail_height"
      , "stem_skirt_notch_length"
      , "stem_craw_extruding_map"
      , "stem_craw_electric_contact_avoider"

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

      , "stem_cross_x_bar_inset_size"
      , "stem_cross_x_bar_inset_top_chamfering_parameters"
    ]
    , data == [ ] ? switch_reference_data_MX : data
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
  stem_stage_chamfering_angle         = data[ indices[ 12 ] ][ 1 ];
  stem_stage_chamfering_length        = data[ indices[ 13 ] ][ 1 ];
  stem_skirt_height                   = data[ indices[ 14 ] ][ 1 ];
  stem_skirt_thickness                = data[ indices[ 15 ] ][ 1 ];
  stem_rail_width                     = data[ indices[ 16 ] ][ 1 ];
  stem_rail_thickness                 = data[ indices[ 17 ] ][ 1 ];
  stem_rail_height                    = data[ indices[ 18 ] ][ 1 ];
  stem_skirt_notch_length             = data[ indices[ 19 ] ][ 1 ];
  stem_craw_extruding_map             = data[ indices[ 20 ] ][ 1 ];
  stem_craw_electric_contact_avoider  = data[ indices[ 21 ] ][ 1 ];
  stem_color                          = data[ indices[ 22 ] ][ 1 ];
  stem_skirt_color                    = data[ indices[ 23 ] ][ 1 ];

  stem_cross_x_bar_top_chamfering_parameters          = indices[ 24 ] != [ ] ? data[ indices[ 24 ] ][ 1 ] : [ ];
  stem_cross_x_bar_right_chamfering_parameters        = indices[ 25 ] != [ ] ? data[ indices[ 25 ] ][ 1 ] : [ ];
  stem_cross_x_bar_left_chamfering_parameters         = indices[ 26 ] != [ ] ? data[ indices[ 26 ] ][ 1 ] : [ ];
  stem_cross_x_bar_front_chamfering_parameters        = indices[ 27 ] != [ ] ? data[ indices[ 27 ] ][ 1 ] : [ ];
  stem_cross_x_bar_back_chamfering_parameters         = indices[ 28 ] != [ ] ? data[ indices[ 28 ] ][ 1 ] : [ ];
  stem_cross_x_bar_top_front_chamfering_parameters    = indices[ 29 ] != [ ] ? data[ indices[ 29 ] ][ 1 ] : [ ];
  stem_cross_x_bar_top_back_chamfering_parameters     = indices[ 30 ] != [ ] ? data[ indices[ 30 ] ][ 1 ] : [ ];
  stem_cross_x_bar_top_right_chamfering_parameters    = indices[ 31 ] != [ ] ? data[ indices[ 31 ] ][ 1 ] : [ ];
  stem_cross_x_bar_top_left_chamfering_parameters     = indices[ 32 ] != [ ] ? data[ indices[ 32 ] ][ 1 ] : [ ];
  stem_cross_x_bar_front_right_chamfering_parameters  = indices[ 33 ] != [ ] ? data[ indices[ 33 ] ][ 1 ] : [ ];
  stem_cross_x_bar_front_left_chamfering_parameters   = indices[ 34 ] != [ ] ? data[ indices[ 34 ] ][ 1 ] : [ ];
  stem_cross_x_bar_back_right_chamfering_parameters   = indices[ 35 ] != [ ] ? data[ indices[ 35 ] ][ 1 ] : [ ];
  stem_cross_x_bar_back_left_chamfering_parameters    = indices[ 36 ] != [ ] ? data[ indices[ 36 ] ][ 1 ] : [ ];
  
  stem_cross_y_bar_top_chamfering_parameters          = indices[ 37 ] != [ ] ? data[ indices[ 37 ] ][ 1 ] : [ ];
  stem_cross_y_bar_right_chamfering_parameters        = indices[ 38 ] != [ ] ? data[ indices[ 38 ] ][ 1 ] : [ ];
  stem_cross_y_bar_left_chamfering_parameters         = indices[ 39 ] != [ ] ? data[ indices[ 39 ] ][ 1 ] : [ ];
  stem_cross_y_bar_front_chamfering_parameters        = indices[ 40 ] != [ ] ? data[ indices[ 40 ] ][ 1 ] : [ ];
  stem_cross_y_bar_back_chamfering_parameters         = indices[ 41 ] != [ ] ? data[ indices[ 41 ] ][ 1 ] : [ ];
  stem_cross_y_bar_top_front_chamfering_parameters    = indices[ 42 ] != [ ] ? data[ indices[ 42 ] ][ 1 ] : [ ];
  stem_cross_y_bar_top_back_chamfering_parameters     = indices[ 43 ] != [ ] ? data[ indices[ 43 ] ][ 1 ] : [ ];
  stem_cross_y_bar_top_right_chamfering_parameters    = indices[ 44 ] != [ ] ? data[ indices[ 44 ] ][ 1 ] : [ ];
  stem_cross_y_bar_top_left_chamfering_parameters     = indices[ 45 ] != [ ] ? data[ indices[ 45 ] ][ 1 ] : [ ];
  stem_cross_y_bar_front_right_chamfering_parameters  = indices[ 46 ] != [ ] ? data[ indices[ 46 ] ][ 1 ] : [ ];
  stem_cross_y_bar_front_left_chamfering_parameters   = indices[ 47 ] != [ ] ? data[ indices[ 47 ] ][ 1 ] : [ ];
  stem_cross_y_bar_back_right_chamfering_parameters   = indices[ 48 ] != [ ] ? data[ indices[ 48 ] ][ 1 ] : [ ];
  stem_cross_y_bar_back_left_chamfering_parameters    = indices[ 49 ] != [ ] ? data[ indices[ 49 ] ][ 1 ] : [ ];

  stem_cross_y_notch_depth            = data[ indices[ 50 ] ][ 1 ];
  stem_cross_y_notch_z_position       = data[ indices[ 51 ] ][ 1 ];
  stem_cross_y_notch_chamfering_angle = data[ indices[ 52 ] ][ 1 ];
  stem_cross_y_notch_height           = data[ indices[ 53 ] ][ 1 ];

  stem_cross_x_bar_inset_size                       = data[ indices[ 54 ] ][ 1 ];
  stem_cross_x_bar_inset_top_chamfering_parameters  = data[ indices[ 55 ] ][ 1 ];

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
        difference()
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

          if ( stem_cross_x_bar_inset_size[ 1 ] > 0 )
          {
            translate( [ 0, -cxxy[ 1 ] / 2, 0 ] )
              _cross_x_inset();
            translate( [ 0, +cxxy[ 1 ] / 2, 0 ] )
              _cross_x_inset();
          }
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

  module _rail()
  {
    translate( [ 0, -stem_rail_width[ 0 ] / 2, -stem_skirt_height[ 0 ] ] )
    cube( [ stem_rail_thickness, stem_rail_width[ 0 ], stem_rail_height[ 0 ] ] );
    translate( [ 0, -stem_rail_width[ 1 ] / 2, -stem_skirt_height[ 0 ] + stem_rail_height[ 0 ] ] )
    cube( [ stem_rail_thickness, stem_rail_width[ 1 ], stem_rail_height[ 1 ] - stem_rail_height[ 0 ] ] );
  }

  module _rails()
  {
    // rail/right
    translate( [ stem_stage_size[ 0 ] / 2 - stem_skirt_thickness[ 0 ], 0, 0 ] )
      _rail();
    // rail/left
    translate( [ -( stem_stage_size[ 0 ] / 2 - stem_skirt_thickness[ 0 ] ) - stem_rail_thickness, 0, 0 ] )
      _rail();
  }

  module _side_skirt( avoid_electric_contact = true )
  {
    difference()
    {
      translate( [ 0, -stem_stage_size[ 1 ] / 2, 0 ] )
      rotate( [ 0, 90, 0 ] )
      rotate( [ 180, 0, 0 ] )
      linear_extrude( stem_skirt_thickness[ 0 ], center = true )
      polygon
      ( concat
        ( stem_craw_extruding_map
        , [ [ reverse( stem_craw_extruding_map )[ 0 ][ 0 ], -stem_stage_size[ 1 ] ]
          , [ stem_craw_extruding_map[ 0 ][ 0 ], -stem_stage_size[ 1 ] ]
          ]
        )
      );

      if ( avoid_electric_contact )
        translate( [ 0, -stem_stage_size[ 1 ] / 2, 0 ] )
        rotate( [ 0, 90, 0 ] )
        rotate( [ 180, 0, 0 ] )
        linear_extrude( stem_skirt_thickness[ 0 ] * 2, center = true )
        polygon( stem_craw_electric_contact_avoider );
    }
  }

  module _stage()
  {
    difference()
    {
      translate( [ -stem_stage_size[ 0 ] / 2, -stem_stage_size[ 1 ] / 2, -stem_stage_size[ 2 ] ] )
      //stem_stage_chamfering_angle
      chamfered_cube
      ( [ stem_stage_size[ 0 ], stem_stage_size[ 1 ], stem_stage_size[ 2 ] ]
      , top_chamfering_parameters = [ stem_stage_chamfering_angle, stem_stage_chamfering_length, "C" ]
      );
      translate( [ 0, 0, -stem_stage_size[ 2 ] - stem_stage_hole_height * 0.01 ] )
        cylinder( d = stem_stage_hole_diameter, h = stem_stage_hole_height * 1.01 );
    }
  }

  module _skirt()
  {
    // back
    translate( [ stem_skirt_notch_length / 2, stem_stage_size[ 1 ] / 2 - stem_skirt_thickness[ 1 ], -stem_skirt_height[ 1 ] ] )
    cube( [ ( stem_stage_size[ 0 ] - stem_skirt_notch_length ) / 2 , stem_skirt_thickness[ 1 ], stem_skirt_height[ 1 ]  - stem_stage_chamfering_length ] );
    translate( [ -( stem_skirt_notch_length / 2 ) - ( stem_stage_size[ 0 ] - stem_skirt_notch_length ) / 2, stem_stage_size[ 1 ] / 2 - stem_skirt_thickness[ 1 ], -stem_skirt_height[ 1 ] ] )
    cube( [ ( stem_stage_size[ 0 ] - stem_skirt_notch_length ) / 2 , stem_skirt_thickness[ 1 ], stem_skirt_height[ 1 ]  - stem_stage_chamfering_length ] );

    // side
    translate( [ +stem_stage_size[ 0 ] / 2 - stem_skirt_thickness[ 0 ] / 2, 0, 0 ] )
    _side_skirt();
    translate( [ -stem_stage_size[ 0 ] / 2 + stem_skirt_thickness[ 0 ] / 2, 0, 0 ] )
    _side_skirt( false );
  }
  
  module _shaft()
  {
    // shaft
    translate( [ 0, 0, -stem_bottom_shaft_height ] )
      shaft
      ( diameter = stem_bottom_shaft_diameter
      , length = stem_bottom_shaft_height
      , top_chamfering_angle = 0
      , top_chamfering_length = 0
      , bottom_chamfering_angle = stem_bottom_shaft_chamfering_angle
      , bottom_chamfering_length = stem_bottom_shaft_chamfering_length
      );
  }

  module _stem()
  {
    union()
    {
      _cross();
      _stage();
      _skirt();
      _rails();
      _shaft();
    }
  }

  if ( stem_color != [ ] )
    color( stem_color )
      _stem();
  else
    _stem();
}
