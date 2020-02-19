include <generate_arc_vertices.scad>

/// 弧を造形
/// @param radius 弧の半径
/// @param angle_first 
/// @note 弧のポリゴン分割は OpenSCAD 内蔵の circle と同様に $fn, $fa, $fs から誘導されます。
module arc( radius, first, last )
{
  polygon( generate_arc_vertices( radius, first, last ) );
}

/// 弧を造形
/// @param radius 弧の半径
/// @param angle_first 
/// @note 弧のポリゴン分割は OpenSCAD 内蔵の circle と同様に $fn, $fa, $fs から誘導されます。
module arc_fn( radius, first, last )
{
  polygon( generate_arc_vertices_fn( radius, first, last ) );
}

/// 弧を造形
/// @param radius 弧の半径
/// @param angle_first 
/// @note 弧のポリゴン分割は OpenSCAD 内蔵の circle と同様に $fn, $fa, $fs から誘導されます。
module arc_fa( radius, first, last )
{
  polygon( generate_arc_vertices_fa( radius, first, last ) );
}

/// 弧を造形
/// @param radius 弧の半径
/// @param angle_first 
/// @note 弧のポリゴン分割は OpenSCAD 内蔵の circle と同様に $fn, $fa, $fs から誘導されます。
module arc_fs( radius, first, last )
{
  polygon( generate_arc_vertices_fs( radius, first, last ) );
}
