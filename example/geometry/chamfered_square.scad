// ↓この example の本体機能用です
use <../../geometry/chamfered_square.scad>
// ↓わかりやすく色付けする用です
use <../../utility/color/HSL.scad>

$fs = 0.1;
$fa = 1;
$fn = 16;

// 面取りなし = square
color( to_RGB_from_HSL( [ 0, 1, 0.8 ] ) )
chamfered_square( [ 1, 2 ] );

// 0.2C 45[deg] 面取り
color( to_RGB_from_HSL( [ 30, 1, 0.8 ] ) )
translate( [ 2, 0, 0 ] )
chamfered_square( [ 1, 2 ], 45, 0.2 );

// 0.5R 面取り
color( to_RGB_from_HSL( [ 60, 1, 0.8 ] ) )
translate( [ 4, 0, 0 ] )
chamfered_square( [ 1, 2 ], chamfering_length = 0.5, chamfering_type = "R" );

// 内側(-X側)と外側(+X)側で異なるパラメーターで面取り
color( to_RGB_from_HSL( [ 90, 1, 0.8 ] ) )
translate( [ 6, 0, 0 ] )
chamfered_square
( [ 1, 2 ]
, inner_chamfering_angle = 60, inner_chamfering_length = 0.2, inner_chamfering_type = "C"
                              , outer_chamfering_length = 0.3, outer_chamfering_type = "R"
);

// 4つの角それぞれに異なるパラメーターで面取り
color( to_RGB_from_HSL( [ 120, 1, 0.8 ] ) )
translate( [ 8, 0, 0 ] )
chamfered_square
( [ 1, 2 ]
, inner_top_chamfering_angle    = 45, inner_top_chamfering_length    = 0.2, inner_top_chamfering_type    = "C"
                                    , outer_top_chamfering_length    = 0.6, outer_top_chamfering_type    = "R"
, inner_bottom_chamfering_angle = 80, inner_bottom_chamfering_length = 0.1, inner_bottom_chamfering_type = "C"
                                    , outer_bottom_chamfering_length = 0.3, outer_bottom_chamfering_type = "R"
);
