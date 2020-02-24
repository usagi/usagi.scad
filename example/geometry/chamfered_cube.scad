// ↓この example の本体機能用です
use <../../geometry/chamfered_cube.scad>
// ↓わかりやすく色付けする用です
use <../../utility/color/HSL.scad>

$fs = 0.1;
$fa = 1;
$fn = 16;

size = [ 2, 3, 4 ];

// 面取りなし = cube
color( to_RGB_from_HSL( [ 0, 1, 0.8 ] ) )
rotate( [ $t * 360, 0, 0 ] )
chamfered_cube( size );

// すべての面を 0.5C 30deg で面取り
// chamfering_parameters は「すべての面」＝「デフォルトの面取りパラメーター設定」です。
color( to_RGB_from_HSL( [ 30, 1, 0.8 ] ) )
translate( [ size[ 0 ] + 1, 0, 0 ] )
rotate( [ $t * 360 - 30, 0, 0 ] )
chamfered_cube
( size
, chamfering_parameters = [ 30, 0.5, "C" ]
);

// 上面の右/左/前/後の4面を 0.5C 45deg で面取り、
// 下面の右/左/前/後の4面を 0.5R で面取り
// (前面の右/左、背面の右/左はデフォルト未設定なので面取りなしになります)
color( to_RGB_from_HSL( [ 30 * 2, 1, 0.8 ] ) )
translate( [ ( size[ 0 ] + 1 ) * 2, 0, 0 ] )
rotate( [ $t * 360 - 30 * 2, 0, 0 ] )
chamfered_cube
( size
, top_chamfering_parameters    = [ 45, 0.2, "C" ]
, bottom_chamfering_parameters = [  0, 0.5, "R" ]
);

// 右面の上/下/前/後の4面を 0.3C 60deg で面取り、
// 左面の上/下/前/後の4面を 0.3R で面取り
// (上面の前/背、下面の前/背はデフォルト未設定なので面取りなしになります)
color( to_RGB_from_HSL( [ 30 * 3, 1, 0.8 ] ) )
translate( [ ( size[ 0 ] + 1 ) * 3, 0, 0 ] )
rotate( [ $t * 360 - 30 * 3, 0, 0 ] )
chamfered_cube
( size
, right_chamfering_parameters = [ 60, 0.3, "C" ]
, left_chamfering_parameters  = [  0, 0.3, "R" ]
);

// 右面の上/下/前/後の4面を 0.3C 60deg で面取り、
// 左面の上/下/前/後の4面を 0.3R で面取り
// (上面の前/背、下面の前/背はデフォルト未設定なので面取りなしになります)
color( to_RGB_from_HSL( [ 30 * 4, 1, 0.8 ] ) )
translate( [ ( size[ 0 ] + 1 ) * 4, 0, 0 ] )
rotate( [ $t * 360 - 30 * 4, 0, 0 ] )
chamfered_cube
( size
, top_right_chamfering_parameters     = [  5, 0.3, "C" ]
, top_left_chamfering_parameters      = [ 10, 0.3, "C" ]
, top_front_chamfering_parameters     = [ 15, 0.3, "C" ]
, top_back_chamfering_parameters      = [ 20, 0.3, "C" ]
, bottom_right_chamfering_parameters  = [ 25, 0.3, "C" ]
, bottom_left_chamfering_parameters   = [ 30, 0.3, "C" ]
, bottom_front_chamfering_parameters  = [ 35, 0.3, "C" ]
, bottom_back_chamfering_parameters   = [  0, 0.10, "R" ]
, front_right_chamfering_parameters   = [  0, 0.15, "R" ]
, front_left_chamfering_parameters    = [  0, 0.20, "R" ]
, back_right_chamfering_parameters    = [  0, 0.25, "R" ]
, back_left_chamfering_parameters     = [  0, 0.30, "R" ]
);
