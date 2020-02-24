include <generate_arc_vertices.scad>
include <../utility/vector/translate_vector.scad>

/// 2Dの面取りされた長方形を size から造形
/// @param size OpenSCAD 内蔵 size に準じる
/// @param chamfering_angle 面取り角度 ( chamfering_type が "C" の場合に有効 )
/// @param chamfering_length 面取り長さ ( chamfering_type が "C" の場合はY軸方向の食い込み長さ、 "R" の場合は半径 )
/// @param chamfering_type 面取りタイプ "C":平面, "R":円
/// @note chamfering_{angle|length|type}_{inner|outer} パラメーターは
///         inner: X が内寄り側の上下
///         outer: X が外寄り側の上下
///       で個別に面取りパラメーターを設定したい場合に使用します。
///       chamfering_{angle|length|type}_{inner|outer}_{top|bottom} パラメーターは
///       4つの角それぞれで異なる面取りパラメーターを設定したい場合に使用します。
module chamfered_square
( size
// --- optional detail level-2 ( highest )
, chamfering_angle  = 0
, chamfering_length = 0
, chamfering_type   = "C"
// --- optional for detail level-1
, inner_chamfering_angle = [ ]
, outer_chamfering_angle = [ ]

, inner_chamfering_length  = [ ]
, outer_chamfering_length  = [ ]

, inner_chamfering_type  = [ ]
, outer_chamfering_type  = [ ]

// --- optional for detail level-0 ( lowest )
, inner_bottom_chamfering_angle = [ ]
, inner_top_chamfering_angle    = [ ]
, outer_bottom_chamfering_angle = [ ]
, outer_top_chamfering_angle    = [ ]

, inner_bottom_chamfering_length  = [ ]
, inner_top_chamfering_length     = [ ]
, outer_bottom_chamfering_length  = [ ]
, outer_top_chamfering_length     = [ ]

, inner_bottom_chamfering_type  = [ ]
, inner_top_chamfering_type     = [ ]
, outer_bottom_chamfering_type  = [ ]
, outer_top_chamfering_type     = [ ]
)
{
  let
  ( size = len( size ) == 2 ? size : [ size, size ]
  // to LOD-1 via LOD-2
  , inner_chamfering_angle  = inner_chamfering_angle  != [ ] ? inner_chamfering_angle  : chamfering_angle
  , outer_chamfering_angle  = outer_chamfering_angle  != [ ] ? outer_chamfering_angle  : chamfering_angle
  , inner_chamfering_length = inner_chamfering_length != [ ] ? inner_chamfering_length : chamfering_length
  , outer_chamfering_length = outer_chamfering_length != [ ] ? outer_chamfering_length : chamfering_length
  , inner_chamfering_type   = inner_chamfering_type   != [ ] ? inner_chamfering_type   : chamfering_type
  , outer_chamfering_type   = outer_chamfering_type   != [ ] ? outer_chamfering_type   : chamfering_type
  // to LOD-0 via LOD-1
  , inner_bottom_chamfering_angle   = inner_bottom_chamfering_angle   != [ ] ? inner_bottom_chamfering_angle  : inner_chamfering_angle
  , inner_top_chamfering_angle      = inner_top_chamfering_angle      != [ ] ? inner_top_chamfering_angle     : inner_chamfering_angle
  , outer_bottom_chamfering_angle   = outer_bottom_chamfering_angle   != [ ] ? outer_bottom_chamfering_angle  : outer_chamfering_angle
  , outer_top_chamfering_angle      = outer_top_chamfering_angle      != [ ] ? outer_top_chamfering_angle     : outer_chamfering_angle
  , inner_bottom_chamfering_length  = inner_bottom_chamfering_length  != [ ] ? inner_bottom_chamfering_length : inner_chamfering_length
  , inner_top_chamfering_length     = inner_top_chamfering_length     != [ ] ? inner_top_chamfering_length    : inner_chamfering_length
  , outer_bottom_chamfering_length  = outer_bottom_chamfering_length  != [ ] ? outer_bottom_chamfering_length : outer_chamfering_length
  , outer_top_chamfering_length     = outer_top_chamfering_length     != [ ] ? outer_top_chamfering_length    : outer_chamfering_length
  , inner_bottom_chamfering_type    = inner_bottom_chamfering_type    != [ ] ? inner_bottom_chamfering_type   : inner_chamfering_type
  , inner_top_chamfering_type       = inner_top_chamfering_type       != [ ] ? inner_top_chamfering_type      : inner_chamfering_type
  , outer_bottom_chamfering_type    = outer_bottom_chamfering_type    != [ ] ? outer_bottom_chamfering_type   : outer_chamfering_type
  , outer_top_chamfering_type       = outer_top_chamfering_type       != [ ] ? outer_top_chamfering_type      : outer_chamfering_type
  )
  {
    inner_bottom_chamfering_length_x = inner_bottom_chamfering_length * tan( inner_bottom_chamfering_angle );
    inner_top_chamfering_length_x    = inner_top_chamfering_length    * tan( inner_top_chamfering_angle    );
    outer_bottom_chamfering_length_x = outer_bottom_chamfering_length * tan( outer_bottom_chamfering_angle );
    outer_top_chamfering_length_x    = outer_top_chamfering_length    * tan( outer_top_chamfering_angle    );

    vertices_outer_bottom = 
      outer_bottom_chamfering_type == "R"
        ? translate_vector
          ( [ size[ 0 ] - outer_bottom_chamfering_length, outer_bottom_chamfering_length ]
          , generate_arc_vertices( outer_bottom_chamfering_length,   0,  90 )
          )
        : outer_bottom_chamfering_type == "C"
            ? [ [ size[ 0 ]                                   , outer_bottom_chamfering_length ]
              , [ size[ 0 ] - outer_bottom_chamfering_length_x, 0                              ]
              ]
            : [ [ size[ 0 ], 0 ]
              ]
      ;
    

    vertices_inner_bottom =
      inner_bottom_chamfering_type == "R"
        ? translate_vector
          ( [ inner_bottom_chamfering_length, inner_bottom_chamfering_length ]
          , generate_arc_vertices( inner_bottom_chamfering_length,  90, 180 )
          )
        : inner_bottom_chamfering_type == "C"
            ? [ [ inner_bottom_chamfering_length_x, 0                              ]
              , [ 0                               , inner_bottom_chamfering_length ]
              ]
            : [ [ 0, 0 ]
              ]
      ;
    
    vertices_inner_top = 
      inner_top_chamfering_type == "R"
        ? translate_vector
          ( [ inner_top_chamfering_length, size[ 1 ] - inner_top_chamfering_length ]
          , generate_arc_vertices( outer_top_chamfering_length, 180, 270 )
          )
        : inner_top_chamfering_type == "C"
            ? [ [ 0                            , size[ 1 ] - inner_top_chamfering_length ]
              , [ inner_top_chamfering_length_x, size[ 1 ]                               ]
              ]
            : [ [ 0, size[ 1 ] ]
              ]
      ;

    vertices_outer_top = 
      outer_top_chamfering_type == "R"
        ? translate_vector
          ( [ size[ 0 ] - outer_top_chamfering_length, size[ 1 ] - outer_top_chamfering_length ]
          , generate_arc_vertices( outer_top_chamfering_length, 270, 360 )
          )
        : outer_top_chamfering_type == "C"
            ? [ [ size[ 0 ] - outer_top_chamfering_length_x, size[ 1 ]                               ]
              , [ size[ 0 ]                                , size[ 1 ] - outer_top_chamfering_length ]
              ]
            : [ [ size[ 0 ], size[ 1 ] ]
              ]
      ;

    vertices = concat( vertices_outer_bottom, vertices_inner_bottom, vertices_inner_top, vertices_outer_top );

    polygon( vertices );
  }
}
