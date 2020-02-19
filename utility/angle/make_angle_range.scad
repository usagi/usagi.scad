include <angle_step.scad>

/// 角度範囲を生成
/// @note 弧のポリゴン分割は OpenSCAD 内蔵の circle と同様に $fn, $fa, $fs から誘導されます。
function make_angle_range( radius, first, last ) = [ first : angle_step( radius, [ first : last ] ) : last ];
/// @note 弧のポリゴン分割は $fn のみから誘導されます。分割数を一定にしたい場合に使用します。
function make_angle_range_fn( first, last ) = [ first : angle_step_fn( [ first : last ] ) : last ];
/// @note 弧のポリゴン分割は $fa のみから誘導されます。分割角度を一定にしたい場合に使用します。
function make_angle_range_fa( first, last ) = [ first : $fa : last ];
/// @note 弧のポリゴン分割は $fs のみから誘導されます。表面の細分割品質を一定にしたい場合に使用します。
function make_angle_range_fs( rasius, first, last ) = [ first : angle_step_fs( radius, [ first : last ] ) : last ];
