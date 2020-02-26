include <../../../part/switch/key_switch.scad>

$fs = 0.1;
$fa = 5;

// この example と key_switch 系モジュールは実装途中です。
// 現在はステムの造形にのみ対応しています。
// https://github.com/usagi/usagi.scad/issues/1

// Cherry MX Red を造形
translate( [ 0, 0, -4 * cos( $t * 360 + 90 ) ] )
key_switch_stem( make_switch_parameters( "Cherry MX Red" ) );

// Cherry MX Brown を造形
translate( [ 12, 0, -4 * cos( $t * 360 + 120 ) ] )
key_switch_stem( make_switch_parameters( "Cherry MX Brown" ) );

//*
// Cherry MX Red をベースに一部の設定をお好みカスタマイズして…(つづく)
my_switch_parameters = make_switch_parameters
( base_name = "Cherry MX Red"
, custom_parameters =
  [ [ "stem_color", to_RGB_from_HSL( [ 30, 0.75, 0.90 ] ) ]
  , [ "stem_craw_extruding_map"
    , [ [ 3.20, 0.40 ]
      , [ 4.00, 0.60 ]
      , [ 4.50, 0.90 ]
      , [ 4.90, 0.80 ]
      , [ 5.30, 0.80 ]
      , [ 5.70, 1.00 ]
      , [ 6.10, 0.90 ]
      , [ 6.50, 1.00 ]
      , [ 6.90, 1.00 ]
      ]
    ]
  ]
);

// (つづいて)カスタムしたパラメーターで造形
translate( [ 24, 0, -4 * cos( $t * 360 + 150 ) ] )
key_switch_stem( my_switch_parameters );
//*/
