/// 角度範囲の距離 [deg] を取得
/// @param normalize true: +/-何れの回転方向でも1回転分以内に正規化, false: 多回転する場合もそのまま
function distance_of_angle_range( range = [ 0 : 360 ], normalize = true ) = 
  let
  ( d = range[ 2 ] - range[ 0 ]
  )
    normalize
      ? ( d % 360 )
      : d
  ;
