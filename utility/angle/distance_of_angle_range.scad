include <normalize_angle.scad>

/// 角度範囲の距離 [deg] を取得
/// @note 角度は正規化される
function distance_of_angle_range( range = [ 0 : 360 ] ) = normalize_angle( range[ 2 ] ) - normalize_angle( range[ 0 ] );
