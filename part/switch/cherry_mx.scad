/// Cherry MX convertible switch

use <../shaft.scad>
use <../../geometry/chamfered_cube.scad>

cherry_mx_switch_reference_data = 
  [ // source: https://www.cherrymx.de/en/dev.html
    // source: https://www.keychatter.com/2018/08/16/unpacking-the-kailh-box-switch-debacle/
    [ "stem_cross_x_bar", [ 4.00, 1.31 ] ]
  , [ "stem_cross_y_bar", [ 1.09, 4.00 ] ]
  , [ "stem_cross_x_bar_tolerance", [ [ -0.05 : +0.05 ], [ -0.02 : +0.02 ] ] ]
  , [ "stem_cross_y_bar_tolerance", [ [ -0.03 : +0.03 ], [ -0.05 : +0.05 ] ] ]
  , [ "stem_cross_z", 3.60 ]
  , [ "stem_cross_x_bar_inner_tickness", 1.02 ]
  , [ "stem_cross_x_bar_inner_tickness_tolerance", [ -0.03 : +0.03 ] ]
  , [ "housing_bottom_outer_size", [ 15.6, 15.6 ] ]

  // Authorによる MX Speed Silver, Red, Brown, Blue の実測値に基づく
  , [ "housing_bottom_outer_r", 1.00 ] // マウントプレートに引っかかる部分の角丸のR
  , [ "housing_height", 11.6 ] // 組み立て状態で下部ハウジングの底面(円柱は含まず)からステムのクロス部下端までの長さ
                               // Note: 上部ハウジング上面とステムのクロス部下端の間には
                               //       面取り(Authorの目測でおよそ30deg)の高さ分に等しい隙間があります。
  , [ "stem_stage_chamfering_length", 1 ] // [mm] ステムのクロスが乗るステージ部分のC面取り深さ
  , [ "stem_stage_chamfering_angle", 30 ] // [deg] ステムのクロスが乗るステージ部分のC面取り角度
  , [ "stem_stage_size", [ 7.22, 5.57, 3.50 ] ] // ステムの胴体部分(組み立て状態ではハウジングに埋まっている)の外形
                                                // Z は円柱状の穴の面(切れ込みに見える部分)まで
  , [ "stem_stage_x_clearance", 0.48 ] // [mm] 出っ張りの無い部分の下部ハウジングとのクリアランス
  
  , [ "stem_stage_hole_diameter", 4.3 ] // [mm] ステムを裏から見ると空いている円柱穴の直径
  , [ "stem_stage_hole_height"  , 2.5 ] // [mm] ステムを裏から見ると空いている円柱穴の深さ

  , [ "stem_bottom_shaft_diameter"          ,  1.97 ] // [mm] ステム下部シャフトの直径
  , [ "stem_bottom_shaft_height"            ,  9.00 ] // [mm] ステム下部シャフト最下端からステージ上面までの長さ
  , [ "stem_bottom_shaft_chamfering_angle"  , 30.00 ] // [deg] ステム下部シャフトのC面取り角度
  , [ "stem_bottom_shaft_chamfering_length" ,  0.866025 ] // [mm] ステム下部シャフトのC面取り深さ (周辺の長さの計測と角度の目視推定から 0.5 / tan( 30 ) = 0.866025 と推定した )

  , [ "stem_skirt_height", [ 6.40, 5.75, 5.00 ] ] // [mm] ステージ上面からステム下部へ続くスカート構造の最下部までの長さ (端子に直接触れる出っ張り部分は除く) [ 側面部, 背面部, 側面部の厚みが僅かに変化するまでの高さ ]
  , [ "stem_skirt_thickness", [ 0.75, 0.80, 0.65 ] ] // [mm] ステージ上面からステム下部へ続くスカート構造の厚さ [ 側面部のX軸方向の厚さ, 背面部のY軸方向の厚さ, 側面下端部の厚さ(外側が僅かに薄くなる) ]
  , [ "stem_skirt_notch_length", 2.48 ] // [mm] ステージ上面からステム下部へ続くスカート構造の背面側の切り欠き部の長さ(X軸方向)

  , [ "stem_crow_front", [ 6.00 - 5.57, 6.6 - 5.57 ] ] // [mm] ステム下部の接点爪構造部の front 側への突き出し長さ [ 上部, 下部 ]
  , [ "stem_crow_bottom", 0.50 ] // [mm] ステム下部の接点爪構造部の bottom 側への突き出し長さ
  , [ "stem_crow_top_depth", 3.2 ] // [mm] ステム下部の接点爪構造部の上部からステージまでの高さ
  , [ "stem_crow_right_notch_height", 1.4 ] // [mm] ステム下部の接点爪構造部の右側のハウジング内で電極を避けるノッチ部の深さ(Z軸方向の長さ)
  , [ "stem_crow_width", 0.65 ] // [mm] ステム下部の接点爪構造部の下部先端の幅(Y軸方向)
  , [ "stem_crow_height", 3.68 ] // [mm] ステム下部の接点爪構造部の高さ( stem_crow_front の構造物部分の高さ)
  , [ "stem_crow_right_notch_width", 0.8 ] // [mm] ステム下部の接点爪構造部の右側のハウジング内で電極を避けるノッチ部の最上部の長さ(Y軸方向の長さ)

  , [ "stem_rail_width", [ 2.2, 1.4 ] ] // [mm] ステム側面のハウジングレールとの噛み合わせ構造部の幅(Y軸方向長さ) [ 下部, 上部 ]
  , [ "stem_rail_thickness", 1.50 ] // [mm] ステム側面のハウジングレールとの噛み合わせ構造部の幅(X軸方向長さ)
  , [ "stem_rail_height", [ 4.35, 5.2 ] ] // [mm] ステム側面のハウジングレールとの噛み合わせ構造部の高さ [ 側面部, 中央部 ]

  , [ "housing_bottom_stem_hole_diameter", 2.00 ] // [mm] stem_bottom_shaft が挿さる穴

  ];

module cherry_mx_switch
( data = [ ]
, no_spring = true
)
{
  echo( "cherry_mx_switch: この機能は実装途中です。現在はステムの造形にのみ対応しています。たぶん数日以内に実装します。" );
  
  let( data = data == [ ] ? cherry_mx_switch_reference_data : data )
  {
    cherry_mx_switch_stem( data );
    if ( ! no_spring )
      cherry_mx_switch_spring( data );
    cherry_mx_switch_upper_housing( data );
    cherry_mx_switch_lower_housing( data );
  }
}

/// Cherry MX に近い形状のステムを造形します
/// @note 実際の Cherry 製のステムには側面のスカート部の下部には僅かに厚みの変化する高さがありますが、
///       スイッチとしての機能にはおそらくまったく関与しないか、むしろ悪い影響があるような気がするので
///       その部分は再現しません。
module cherry_mx_switch_stem( data )
{
  // data から必要なパラメーター群の index 群を取得
  indices = 
    search
    ( [ "stem_cross_x_bar"
      , "stem_cross_y_bar"
      , "stem_cross_z"
      , "housing_bottom_outer_size"
      , "housing_height"
      , "stem_stage_size"
      , "stem_stage_hole_diameter"
      , "stem_stage_hole_height"
      , "stem_bottom_shaft_diameter"
      , "stem_bottom_shaft_height"
      , "stem_bottom_shaft_chamfering_angle"
      , "stem_bottom_shaft_chamfering_length"
      , "stem_stage_chamfering_angle"
      , "stem_stage_chamfering_length"
      , "stem_skirt_height"
      , "stem_skirt_thickness"
      , "stem_rail_width"
      , "stem_rail_thickness"
      , "stem_rail_height"
      , "stem_skirt_notch_length"
      , "stem_crow_front"
      , "stem_crow_bottom"
      , "stem_crow_top_depth"
      , "stem_crow_right_notch_height"
      , "stem_crow_width"
      , "stem_crow_height"
      , "stem_crow_right_notch_width"
      ]
    , data == [ ] ? cherry_mx_switch_reference_data : data
    );

  // data から必要なパラメーター群を取得
  cxxy                                = data[ indices[  0 ] ][ 1 ];
  cyxy                                = data[ indices[  1 ] ][ 1 ];
  cz                                  = data[ indices[  2 ] ][ 1 ];
  housing_bottom_outer_size           = data[ indices[  3 ] ][ 1 ];
  housing_height                      = data[ indices[  4 ] ][ 1 ];
  stem_stage_size                     = data[ indices[  5 ] ][ 1 ];
  stem_stage_hole_diameter            = data[ indices[  6 ] ][ 1 ];
  stem_stage_hole_height              = data[ indices[  7 ] ][ 1 ];
  stem_bottom_shaft_diameter          = data[ indices[  8 ] ][ 1 ];
  stem_bottom_shaft_height            = data[ indices[  9 ] ][ 1 ];
  stem_bottom_shaft_chamfering_angle  = data[ indices[ 10 ] ][ 1 ];
  stem_bottom_shaft_chamfering_length = data[ indices[ 11 ] ][ 1 ];
  stem_stage_chamfering_angle         = data[ indices[ 12 ] ][ 1 ];
  stem_stage_chamfering_length        = data[ indices[ 13 ] ][ 1 ];
  stem_skirt_height                   = data[ indices[ 14 ] ][ 1 ];
  stem_skirt_thickness                = data[ indices[ 15 ] ][ 1 ];
  stem_rail_width                     = data[ indices[ 16 ] ][ 1 ];
  stem_rail_thickness                 = data[ indices[ 17 ] ][ 1 ];
  stem_rail_height                    = data[ indices[ 18 ] ][ 1 ];
  stem_skirt_notch_length             = data[ indices[ 19 ] ][ 1 ];
  stem_crow_front                     = data[ indices[ 20 ] ][ 1 ];
  stem_crow_bottom                    = data[ indices[ 21 ] ][ 1 ];
  stem_crow_top_depth                 = data[ indices[ 22 ] ][ 1 ];
  stem_crow_right_notch_height        = data[ indices[ 23 ] ][ 1 ];
  stem_crow_width                     = data[ indices[ 24 ] ][ 1 ];
  stem_crow_height                    = data[ indices[ 25 ] ][ 1 ];
  stem_crow_right_notch_width         = data[ indices[ 26 ] ][ 1 ];

  // XY中心/クロスの底をZ=0として造形すると頂点群の脳内デバッグが楽なので対称なパラメーター群を half にして保持
  cxxh = cxxy[ 0 ] / 2;
  cxyh = cxxy[ 1 ] / 2;
  cyxh = cyxy[ 0 ] / 2;
  cyyh = cyxy[ 1 ] / 2;

  // 原点で作成した後でハウジングに収まる位置へ移動するための移動量
  translation = 
    [ housing_bottom_outer_size[ 0 ] / 2
    , housing_bottom_outer_size[ 1 ] / 2
    , housing_height
    ];

  // 造形
  //translate( translation )
  {
    // cross
    linear_extrude( cz )
      polygon
      ( [ [ -cxxh, -cxyh ]
        , [ -cyxh, -cxyh ]
        , [ -cyxh, -cyyh ]
        , [ +cyxh, -cyyh ]
        , [ +cyxh, -cxyh ]
        , [ +cxxh, -cxyh ]
        , [ +cxxh, +cxyh ]
        , [ +cyxh, +cxyh ]
        , [ +cyxh, +cyyh ]
        , [ -cyxh, +cyyh ]
        , [ -cyxh, +cxyh ]
        , [ -cxxh, +cxyh ]
        ]
      );
    
    module rail()
    {
      translate( [ 0, -stem_rail_width[ 0 ] / 2, -stem_skirt_height[ 0 ] ] )
      cube( [ stem_rail_thickness, stem_rail_width[ 0 ], stem_rail_height[ 0 ] ] );
      translate( [ 0, -stem_rail_width[ 1 ] / 2, -stem_skirt_height[ 0 ] + stem_rail_height[ 0 ] ] )
      cube( [ stem_rail_thickness, stem_rail_width[ 1 ], stem_rail_height[ 1 ] - stem_rail_height[ 0 ] ] );
    }

    // skirt/side
    module side_skirt( is_right = true )
    {
      dxdy = ( stem_crow_front[ 0 ] - stem_crow_front[ 1 ] ) / stem_crow_height;
      
      x1 = dxdy * stem_crow_width;
      x2 = x1 + 0.8;
      x3 = x2 + dxdy * ( ( stem_crow_top_depth  - stem_skirt_height[ 0 ] ) - ( -stem_crow_height + stem_crow_right_notch_height ) );

      xl = dxdy * stem_crow_bottom;

      va = 
        [ [ 0, 0 ]
        , [ -stem_crow_front[ 0 ], 0 ]
        , [ -stem_crow_front[ 1 ], -stem_crow_height ]
        , [ -stem_crow_front[ 1 ] + stem_crow_width, -stem_crow_height ]
        ];
      
      vb = 
        [ [ x3, stem_crow_top_depth  - stem_skirt_height[ 0 ] ]
        , [ stem_stage_size[ 1 ], stem_crow_top_depth  - stem_skirt_height[ 0 ] ]
        , [ stem_stage_size[ 1 ], stem_crow_top_depth - stem_stage_chamfering_length ]
        , [ 0, stem_crow_top_depth - stem_stage_chamfering_length ]
        ];

      vertices = 
        concat
        ( va
        , is_right
            ? [ [ x1, -stem_crow_height + stem_crow_right_notch_height ] // 4
              , [ x2, -stem_crow_height + stem_crow_right_notch_height ] // 5
              ]
            : [ [ xl, -stem_crow_height + stem_crow_bottom ]
              ]
        , vb
        );

      translate( [ is_right ? stem_stage_size[ 0 ] / 2 - stem_skirt_thickness[ 0 ] : -( stem_stage_size[ 0 ] / 2 ), -stem_stage_size[ 1 ] / 2, -stem_crow_top_depth ] )
      rotate( [ 90, 0, 0 ] )
      rotate( [ 0, 90, 0 ] )
      linear_extrude( stem_skirt_thickness[ 0 ] )
        polygon( vertices );
    }

    union()
    {
      // stage
      difference()
      {
        translate( [ -stem_stage_size[ 0 ] / 2, -stem_stage_size[ 1 ] / 2, -stem_stage_size[ 2 ] ] )
        //stem_stage_chamfering_angle
        chamfered_cube
        ( [ stem_stage_size[ 0 ], stem_stage_size[ 1 ], stem_stage_size[ 2 ] ]
        , top_chamfering_parameters = [ stem_stage_chamfering_angle, stem_stage_chamfering_length, "C" ]
        );
        translate( [ 0, 0, -stem_stage_size[ 2 ] - stem_stage_hole_height * 0.01 ] )
          cylinder( d = stem_stage_hole_diameter, h = stem_stage_hole_height * 1.01 );
      }
      
      // skirt/back
      translate( [ stem_skirt_notch_length / 2, stem_stage_size[ 1 ] / 2 - stem_skirt_thickness[ 1 ], -stem_skirt_height[ 1 ] ] )
      cube( [ ( stem_stage_size[ 0 ] - stem_skirt_notch_length ) / 2 , stem_skirt_thickness[ 1 ], stem_skirt_height[ 1 ]  - stem_stage_chamfering_length ] );
      translate( [ -( stem_skirt_notch_length / 2 ) - ( stem_stage_size[ 0 ] - stem_skirt_notch_length ) / 2, stem_stage_size[ 1 ] / 2 - stem_skirt_thickness[ 1 ], -stem_skirt_height[ 1 ] ] )
      cube( [ ( stem_stage_size[ 0 ] - stem_skirt_notch_length ) / 2 , stem_skirt_thickness[ 1 ], stem_skirt_height[ 1 ]  - stem_stage_chamfering_length ] );

      // skirt/side
      side_skirt();
      side_skirt( false );

      // rail
      translate( [ stem_stage_size[ 0 ] / 2 - stem_skirt_thickness[ 0 ], 0, 0 ] )
        rail();
      translate( [ -( stem_stage_size[ 0 ] / 2 - stem_skirt_thickness[ 0 ] ) - stem_rail_thickness, 0, 0 ] )
        rail();

      // shaft
      translate( [ 0, 0, -stem_bottom_shaft_height ] )
        shaft
        ( diameter = stem_bottom_shaft_diameter
        , length = stem_bottom_shaft_height
        , top_chamfering_angle = 0
        , top_chamfering_length = 0
        , bottom_chamfering_angle = stem_bottom_shaft_chamfering_angle
        , bottom_chamfering_length = stem_bottom_shaft_chamfering_length
        );
    }
  }
}

module cherry_mx_switch_lower_housing( data )
{
  echo( "cherry_mx_switch_lower_housing: この機能は未実装です。たぶん数日以内に実装します。" );
}

module cherry_mx_switch_upper_housing( data )
{
  echo( "cherry_mx_switch_upper_housing: この機能は未実装です。たぶん数日以内に実装します。" );
}

module cherry_mx_switch_spring( data )
{
  echo( "cherry_mx_switch_spring: この機能は未実装です。たぶん数日以内に実装します。" );
}
