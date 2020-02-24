// usagi.scad のえぐざんぷるです。
// --------------------------------
// ↓使いたい .scad から usagi.scad を読み込みましょう
include <../usagi.scad>
// --------------------------------

// このえぐざんぷるのちょっとした設定です。 OpenSCAD GUI 右側 Parameters で操作できて便利になります。
CROSS_SECTION = true; // 断面図を作るおまけの仕掛け
RESOLUTION = 0.20;    // note: プレビューでの編集中は適当な粗めの分解能を設定するとOpenSCADでの重さが軽減され楽になります。

COLORS = [ [ 1.00, 0.70, 0.73 ], [ 1.00, 0.87, 0.73 ], [ 1.00, 1.00, 0.80], [ 0.87, 1.00, 0.73 ] ]; // 色付け

MAKE_EXAMPLE_BOLT    = true; // えぐざんぷる/ボルトを造形
MAKE_EXAMPLE_NUT     = true; // えぐざんぷる/ナットを造形
MAKE_EXAMPLE_WASHER  = true; // えぐざんぷる/ワッシャーを造形
MAKE_EXAMPLE_SPACER  = true; // えぐざんぷる/スペーサーを造形

difference() // <- CROSS_SECTION 用の仕掛け
{
  union() // <- CROSS_SECTION 用の仕掛け
  {
    // --------------------------------
    // ↓ M3 の「六角穴付きボルト」を生成
    //
    if ( MAKE_EXAMPLE_BOLT )
      color( COLORS[ 0 ] )
        screw( diameter = 3, length = 8, type = 100, resolution = RESOLUTION );
    // 
    // より詳しい使い方は usagi.scad のはじめの方にある screw モジュールの定義とその上に書いた doxy 風のドキュメンテーションをどうぞ。
    // --------------------------------

    // --------------------------------
    // ↓ M3 の「ナット」を生成
    //
    if ( MAKE_EXAMPLE_NUT )
      color( COLORS[ 1 ] )
        translate( [ 0, 0, 4 ] ) // ボルトに挿した絵にするため少し上げる
          rotate( [ 180, 0, 0 ] )  // ボルトに挿した絵にするためひっくり返す
            nut( diameter = 3, style = 1, has_washer_face = true, resolution = RESOLUTION );
    //
    // より詳しい使い方は usagi.scad のはじめの方にある nut モジュールの定義とその上に書いた doxy 風のドキュメンテーションをどうぞ。
    // --------------------------------

    // --------------------------------
    // ↓ M3 の「ワッシャー」を生成
    //
    if ( MAKE_EXAMPLE_WASHER )
      color( COLORS[ 2 ] )
        translate( [ 0, 0, 6 ] ) // ボルトに挿した絵にするため少し上げる
          washer( diameter = 3, type = 0, resolution = RESOLUTION );
    //
    // より詳しい使い方は usagi.scad のはじめの方にある washer モジュールの定義とその上に書いた doxy 風のドキュメンテーションをどうぞ。
    // --------------------------------

    // --------------------------------
    // ↓ M3 の「スペーサー」を生成
    //
    if ( MAKE_EXAMPLE_SPACER )
      color( COLORS[ 3 ] )
      {
        // 上凹螺子M3 2mm/下凸螺子M3 2mm/胴六角スペーサー
        translate( [ 8, 8, 0 ] )
          spacer( diameter = 3, body_length = 4, top_screw_length = -2, bottom_screw_length = 2, resolution = RESOLUTION );
        // 上凸螺子M3 2mm/下凸螺子M3 2mm/胴六角スペーサー
        translate( [ 8, 0, 0 ] )
          spacer( diameter = 3, body_length = 4, top_screw_length =  2, bottom_screw_length = 2, resolution = RESOLUTION );
        // 上凹螺子M3 1.2mm/下凹螺子M3 1.2mm/胴六角スペーサー
        translate( [ 0, -8, 0 ] )
          spacer( diameter = 3, body_length = 4, top_screw_length = -1.2, bottom_screw_length = -1.2, resolution = RESOLUTION );
        // 上凹螺子M1.6 2mm/下平底/胴立方体足
        translate( [ 0, 8, 0 ] )
          spacer( 1.6, 4, -2, body_outer_diameter = 4 * sqrt( 2 ), body_round_resolution = 4 );
        // 貫通穴M2 3mm/胴外径⌀4mm丸スペーサー
        translate( [ -8, 0, 0 ] )
          spacer( 2, 3, -3, body_outer_diameter = 4, top_screw_pitch = -1 );
      }
    //
    // より詳しい使い方は usagi.scad のはじめの方にある spacer モジュールの定義とその上に書いた doxy 風のドキュメンテーションをどうぞ。
    // --------------------------------
  }

  if ( CROSS_SECTION && ( MAKE_EXAMPLE_BOLT || MAKE_EXAMPLE_NUT || MAKE_EXAMPLE_WASHER || MAKE_EXAMPLE_SPACER ) )
    rotate( [ 0, 0, 180 ] )
      translate( [ 0, 0, -10 ] )
        cube( size = 40, center = false );
}
