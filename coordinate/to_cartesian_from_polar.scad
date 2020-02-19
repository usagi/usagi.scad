/// カルテシアン座標をポーラー座標から取得
/// @param radius 半径
/// @param angle 角度
/// @note angle=0のときX軸方向に一致、Y軸回転、右ねじ
function to_cartesian_from_polar( radius, angle ) = [ cos( angle ) * radius, -sin( angle ) * radius ];
