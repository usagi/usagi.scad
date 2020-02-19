/// 角度を [ 0 .. 360 ] [deg] へ正規化
function normalize_angle( angle ) = 
  angle < 0
    ? normalize_angle( angle + 360 )
    : angle > 360
      ? normalize_angle( angle - 360 )
      : angle
  ;
