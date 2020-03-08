include <../../../../part/switch/key_switch/stem.scad>
include <../../../../part/switch/key_switch/make_switch_parameters.scad>

//$t = 0;
$fs = 0.1;
$fa = 5;

// Choc Red Linear を造形
translate( [ -15, 0, -4 * cos( $t * 360 + 60 ) ] )
key_switch_stem( make_switch_parameters( "Kailh Choc Red" ) );

// Choc Red Linear を造形
translate( [ -30, 0, -4 * cos( $t * 360 + 30 ) ] )
rotate( [ 0, -$t * 360, 0 ] )
key_switch_stem( make_switch_parameters( "Kailh Choc Brown" ) );

// Cherry MX Red を造形
translate( [ 0, 0, -4 * cos( $t * 360 + 90 ) ] )
key_switch_stem( make_switch_parameters( "Cherry MX Red" ) );

// Cherry MX Brown を造形
translate( [ 15, 0, -4 * cos( $t * 360 + 120 ) ] )
rotate( [ 0, -$t * 360, 0 ] )
key_switch_stem( make_switch_parameters( "Cherry MX Brown" ) );

// Cherry MX Blue を造形
translate( [ 30, 0, -4 * cos( $t * 360 + 150 ) ] )
rotate( [ 0, 0, $t * 360 ] )
key_switch_stem( make_switch_parameters( "Cherry MX Blue" ) );

// Cherry MX Speed Silver を造形
translate( [ 30, 12, -4 * cos( $t * 360 + 180 ) ] )
rotate( [ 0, $t * 360, 0 ] )
key_switch_stem( make_switch_parameters( "Cherry MX Speed Silver" ) );

// Invyr UHMWPE Linear を造形
translate( [ 15, 12, -4 * cos( $t * 360 + 210 ) ] )
rotate( [ $t * 360, 0, 0 ] )
key_switch_stem( make_switch_parameters( "Invyr UHMWPE Linear" ) );

// Cherry MX Red をベースに一部の設定をお好みカスタマイズして…(つづく)
my_switch_parameters = make_switch_parameters
( base_name = "Cherry MX Red"
, custom_parameters =
  [ [ "stem_color", to_RGB_from_HSL( [ 330, 1, 0.90 ] ) ]
  , [ "stem_craw_extruding_map"
    , [ [ 3.20, 0.40 ] // ツメ部分の [ ステージZからの深さ(-Z), ステージ前面からの出っ張り長さ(-Y) ] を並べると
      , [ 4.00, 0.60 ] // お手軽にオレオレ応答性ステムをモデリングできます
      , [ 4.50, 0.90 ]
      , [ 4.90, 0.80 ]
      , [ 5.30, 0.80 ]
      , [ 5.70, 1.00 ]
      , [ 6.10, 0.90 ]
      , [ 6.50, 1.00 ]
      , [ 6.90, 1.00 ] // 下端は [ 6.90, 1.00 ] で〆るのが Cherry MX 互換ステムのオススメ。
      ]
    ]
  ]
);

// (つづいて)カスタムしたパラメーターで造形
translate( [ 0, 12, -4 * cos( $t * 360 + 240 ) ] )
rotate( [ 0, 0, 0 ] )
key_switch_stem( my_switch_parameters );
