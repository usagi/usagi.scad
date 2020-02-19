include <pipe.scad>

/// ベアリングを造形
/// @param inner_diameter 内径 [mm]
/// @param outer_diameter 外径 [mm]
/// @param length 内輪と外輪の軸方向の長さ [mm]
/// @param inner_ring_thickness 内輪の厚さ [mm]
/// @param outer_ring_thickness 外輪の厚さ [mm]
/// @param chamfering_radius 内輪と外輪のR面取り半径 [mm]
/// @param number_of_ball ボールの数 [#]
/// @param shield シールドの有無 true: あり, false: なし
/// @note このモジュールは構造を模した表現用です。サンプル、表示用、観賞用としてお使い下さい。
///       仮に3Dプリントしてボール部へ潤滑油を注油しても、もおそらく機械的にはベアリングとして機能しません。
module bearing
( inner_diameter
, outer_diameter
, length
, inner_ring_thickness = 0
, outer_ring_thickness = 0
, chamfering_radius = 0
, number_of_ball = 9
, shield = false
)
{
  let
  ( total_thickness = ( outer_diameter - inner_diameter ) / 2
  , inner_ring_thickness = inner_ring_thickness > 0 ? inner_ring_thickness : total_thickness * 0.20
  , outer_ring_thickness = outer_ring_thickness > 0 ? outer_ring_thickness : total_thickness * 0.20
  )
  {
    // 内輪
    pipe( inner_diameter, inner_diameter + inner_ring_thickness * 2, length, chamfering_type = "R", chamfering_length = chamfering_radius );
    // 外輪
    pipe( outer_diameter - outer_ring_thickness * 2, outer_diameter, length, chamfering_type = "R", chamfering_length = chamfering_radius );

    outer_inner_radius = outer_diameter / 2 - outer_ring_thickness;
    inner_outer_radius = inner_diameter / 2 + inner_ring_thickness;
    ball_orbital_radius = ( outer_inner_radius + inner_outer_radius ) / 2;
    ball_diameter= outer_inner_radius - inner_outer_radius;
    
    // ボール
    for( n = [ 0 : number_of_ball ] )
      translate( [ ball_orbital_radius * cos( 360 * n / number_of_ball ), ball_orbital_radius * sin( 360 * n / number_of_ball ), length / 2 ] )
        sphere( d = ball_diameter * 0.99 ); // 回る必要があるので一応それっぽく見えるよう注油を前提に僅かに小さく造形

    retainer_ratio = 0.70;

    // リテイナー
    translate( [ 0, 0, length / 2 ] )
      {
        rotate_extrude()
          translate( [ inner_outer_radius + ball_diameter * ( 1 - retainer_ratio ) * 0.5, 0 ] )
            chamfered_square( [ ball_diameter * retainer_ratio, ball_diameter * 0.20 ], chamfering_angle = 45, chamfering_length = ball_diameter * 0.01 );
        difference()
        {
          intersection()
          {
            union()
              for( n = [ 0 : number_of_ball ] )
                translate( [ ball_orbital_radius * cos( 360 * n / number_of_ball ), ball_orbital_radius * sin( 360 * n / number_of_ball ), 0 ] )
                  sphere( d = ball_diameter * 1.35 );
            
            rotate_extrude()
              translate( [ inner_outer_radius + ball_diameter * ( 1 - retainer_ratio ) * 0.5, -length / 2 ] )
                chamfered_square( [ ball_diameter * retainer_ratio, length ], chamfering_angle = 45, chamfering_length = ball_diameter * 0.01 );
          }

          for( n = [ 0 : number_of_ball ] )
            translate( [ ball_orbital_radius * cos( 360 * n / number_of_ball ), ball_orbital_radius * sin( 360 * n / number_of_ball ), 0 ] )
              sphere( d = ball_diameter * 1.1 );
        }
      }

    // シールド
    if ( shield )
    {
      translate( [ 0, 0, chamfering_radius ] )
        rotate_extrude()
          translate( [ inner_outer_radius, 0 ] )
            chamfered_square( [ ball_diameter, ball_diameter * 0.05 ], chamfering_angle = 45, chamfering_length = ball_diameter * 0.01 );
      translate( [ 0, 0, length - chamfering_radius - ball_diameter * 0.05 ] )
        rotate_extrude()
          translate( [ inner_outer_radius, 0 ] )
            chamfered_square( [ ball_diameter, ball_diameter * 0.05 ], chamfering_angle = 45, chamfering_length = ball_diameter * 0.01 );
    }
  }
}