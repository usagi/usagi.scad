use <../../../part/switch/cherry_mx.scad>
use <../../../utility/color/HSL.scad>

$fs = 0.1;
$fa = 5;

// この example は実装途中です。現在はステムの造形のみ対応しています。

color( to_RGB_from_HSL( [ 0, 1, 0.9 ] ) )
translate( [ 0, 0, -4 * cos( $t * 360 + 90 ) ] )
cherry_mx_switch();

color( to_RGB_from_HSL( [ 0, 0.75, 0.5 ] ) )
translate( [ 13, 0, -4 * cos( $t * 360 + 120 ) ] )
rotate( [ 0, 0, $t * 360 ] )
cherry_mx_switch();

color( to_RGB_from_HSL( [15, 0.75, 0.25 ] ) )
translate( [ 26, 0, -4 * cos( $t * 360 + 150 ) ] )
rotate( [ $t * 360, 0, 0 ] )
cherry_mx_switch();
