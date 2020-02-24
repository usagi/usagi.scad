/// 角度を [ lowest .. highest ] [deg] へ正規化
/// @param is_closed_highet true の場合は [ lowest .. highest ) へ正規化し、 false の場合は [ lowest .. highest ] へ正規化する
function normalize_angle( angle, lowest = -360, highest = +360, is_closed_highest = false ) = 
  highest - lowest < 360
    ? echo( str( "normalize_angle: highest(", highest, ") - lowest(", lowest,") = ", highest - lowest, "は 360 [deg] 以上となる組み合わせで使用して下さい。" ) )
    : angle < lowest
        ? normalize_angle( angle + 360 )
        : angle > highest
          ? normalize_angle( angle - 360 )
          : ( is_closed_highest && angle == highest )
              ? angle - 360
              : angle
  ;
