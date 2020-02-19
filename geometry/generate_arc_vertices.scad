include <../utility/angle/make_angle_range.scad>
include <../coordinate/to_cartesian_from_polar.scad>

/// 弧の頂点群を生成
/// @param radius 弧の半径
/// @param angle_first 
/// @note 弧のポリゴン分割は OpenSCAD 内蔵の circle と同様に $fn, $fa, $fs から誘導されます。
function generate_arc_vertices( radius, angle_first, angle_last ) =
  generate_arc_vertices_range
  ( radius
  , make_angle_range( radius, angle_first, angle_last )
  );

/// 弧の頂点群を生成
/// @param radius 弧の半径
/// @param angle_first 
/// @note 弧のポリゴン分割は $fn のみから誘導されます。分割数を一定にしたい場合に使用します。
function generate_arc_vertices_fn( radius, angle_first, angle_last ) =
  generate_arc_vertices_range
  ( radius
  , make_angle_range_fn( angle_first, angle_last )
  );

/// 弧の頂点群を生成
/// @param radius 弧の半径
/// @param angle_first 
/// @note 弧のポリゴン分割は $fa のみから誘導されます。分割角度を一定にしたい場合に使用します。
function generate_arc_vertices_fa( radius, angle_first, angle_last ) =
  generate_arc_vertices_range
  ( radius
  , make_angle_range_fa( angle_first, angle_last )
  );

/// 弧の頂点群を生成
/// @param radius 弧の半径
/// @param angle_first 
/// @note 弧のポリゴン分割は $fs のみから誘導されます。表面の細分割品質を一定にしたい場合に使用します。
function generate_arc_vertices_fs( radius, angle_first, angle_last ) =
  generate_arc_vertices_range
  ( radius
  , make_angle_range_fs( radius, angle_first, angle_last )
  );

/// 弧の頂点群を生成
/// @param radius 弧の半径
/// @param range 弧の角度範囲(Y軸回転, 0 [deg] = X軸方向, +向き=右ねじ回転方向)
///                [ first : step : last ]
///                step に $fn, $fa, $fs から誘導される値を使用したい場合は generage_arc_vertices 関数を使用して下さい。
// --- 再帰構築用内部使用パラメーター(ユーザーは明示的に扱う必要の無いパラメーターです) ---
/// @param internal_angle 再帰構築用内部角度値
/// @param internal_buffer 再帰構築用内部バッファー
function generate_arc_vertices_range( radius, angle_range, internal_angle = [ ], internal_buffer = [ ] ) =
  let( internal_angle = internal_angle == [ ] ? angle_range[ 0 ] : internal_angle )
    internal_angle > angle_range[ 2 ]
      ? concat( internal_buffer, [ to_cartesian_from_polar( radius, angle_range[ 2 ] ) ] )
      : generate_arc_vertices_range
        ( radius
        , angle_range
        , internal_angle + angle_range[ 1 ]
        , concat( internal_buffer, [ to_cartesian_from_polar( radius, internal_angle ) ] )
        )
  ;
