include <../geometry/generate_arc_vertices.scad>

/// T型シャフト用サポートブロックを造形
/// @param shaft_diameter           シャフトの直径 [mm]
/// @param shaft_bottom_height      シャフトの中心より下側の高さ [mm]
/// @param shaft_upper_height       シャフトの中心より上側の高さ [mm]
/// @param block_length             ブロックの長さ [mm]; シャフトと同じ軸方向
/// @param slit_length              シャフト固定用のスリットの長さ [mm]
/// @param slit_hole_diameter       シャフト固定用のスリットを通す穴の直径 [mm]; ネジを通す場合は呼び径と一致させるとクリアランスが無くなるので注意
/// @param top_width                立ち上がり部分の幅 [mm]; シャフトと90[deg]で交わる平面側の軸方向
/// @param bottom_width             土台部分の幅 [mm]; シャフトと90[deg]で交わる平面側の軸方向
/// @param bottom height            土台部分の高さ [mm]
/// @param bottom_hole_diameter     土台部分の穴の直径 [mm]; ネジを通す場合は呼び径と一致させるとクリアランスが無くなるので注意
/// @param bottom_hole_position     土台部分の穴
/// @param bottom_center_clearance  土台部分中央下部に設けるクリアランスの高さ [mm]
/// @example // 三好キカイの P3-600 パイジョン(登録商標4278951:1999) に似たような物体を造形する例
///   $fa = 0.01;
///   $fs = 0.01;
///   shaft_support_block_T
///   ( 3
///   , 5
///   , 5
///   , 5
///   , 0.2
///   , 2.1
///   , 5
///   , 14
///   , 2.5
///   , 2.1
///   , 5
///   , 0.5
///   );
module shaft_support_block_T
( shaft_diameter
, shaft_bottom_height
, shaft_upper_height
, block_length
, slit_length
, slit_hole_diameter
, top_width
, bottom_width
, bottom_height
, bottom_hole_diameter
, bottom_hole_position
, bottom_center_clearance = 0
)
{
  hsd = shaft_diameter / 2;

  htw = top_width / 2;
  hbw = bottom_width / 2;
  hbh = bottom_height / 2;

  hsw = slit_length / 2;

  difference()
  {
    bottom_center_vertices =
      bottom_center_clearance > 0
        ? [ [ -hsd - bottom_center_clearance, -shaft_bottom_height ]
          , [ -hsd                          , -shaft_bottom_height + bottom_center_clearance ]
          , [ +hsd                          , -shaft_bottom_height + bottom_center_clearance ]
          , [ +hsd + bottom_center_clearance, -shaft_bottom_height ]
          ]
        : [ ]
      ;
    
    reversed_half_arc_angle = asin( hsw / hsd );
    arc_angle_first = -90 + reversed_half_arc_angle;
    arc_angle_last  = 270 - reversed_half_arc_angle;
    arc_vertices = generate_arc_vertices( hsd, arc_angle_first, arc_angle_last );

    base_vertives = 
      concat
      ( [ [ -hbw, -shaft_bottom_height ] ]
      , bottom_center_vertices
      , [ [ +hbw, -shaft_bottom_height ]
        , [ +hbw, -shaft_bottom_height + hbh ]
        , [ +htw, -shaft_bottom_height + hbh ]
        , [ +htw, shaft_upper_height ]
        , [ +hsw, shaft_upper_height ]
        ]
      , arc_vertices
      , [ [ -hsw, shaft_upper_height ]
        , [ -htw, shaft_upper_height ]
        , [ -htw, -shaft_bottom_height + hbh ]
        , [ -hbw, -shaft_bottom_height + hbh ]
        ]
      );

    translate( [ 0, block_length, 0 ] )
      rotate( [ 90, 0, 0 ] )
        linear_extrude( block_length )
          polygon( base_vertives );

    translate( [ -bottom_hole_position, block_length / 2, -shaft_bottom_height -bottom_height * 0.01 ] )
      cylinder( d = bottom_hole_diameter, h = bottom_height * 2 );

    translate( [ +bottom_hole_position, block_length / 2, -shaft_bottom_height -bottom_height * 0.01 ] )
      cylinder( d = bottom_hole_diameter, h = bottom_height * 2 );
    
    translate( [ -top_width / 2 * 1.01, block_length /2, hsd + ( shaft_upper_height - hsd ) / 2 ] )
      rotate( [ 0, 90,0 ] )
        cylinder( d = slit_hole_diameter, h = top_width * 2 );
  }
}
