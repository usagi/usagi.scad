include <../part/switch/key_switch/stem.scad>
include <../part/switch/key_switch/reference_switch_parameters/Cherry_MX.scad>
include <../part/pipe.scad>
include <../part/shaft.scad>
include <../geometry/chamfered_cube.scad>

/// ザ・エムエックス・オブ・ザ・リングは世界に一つだけのアナタ専用のキーキャップを装着して初めて完成します。
/// 何時の日か、かっこいいザ・エムエックス・オブ・ザ・リングを完成させ素晴らしい名前を指輪に付けてあげて下さい。
/// @note この説明書きはモジュールの名前を John Ronald Reuel Tolkien CBE にフィーチャーしてかっこよくするため
///       Author により適当に妄想されました。("the"なringであるためにはそういう背景事情が無いと"a"とか"some"になってしまうので…)
// --- 一般的に必要な引数 ---
/// @param inner_circumference   指輪の内周 [mm] ( inner_diameter 引数を使用する場合は無視されます )
/// @param thickness             指輪の厚さ [mm]
/// @param width                 指輪の幅 [mm] ; 参考 https://zexy.net/mar/manual/ring_info/marriage_design_article8.html
// --- 場合によっては使用するとよい引数 ---
/// @param stage_depth           クロス部分を乗せるステージを指輪の外周からどれくらい押し出す or 掘り下げるか指定します
///                                eg. +1.0 を設定した場合、指輪の外周から 1.0mm 外側側へ突き出した台座が生成されます
///                                eg. -0.5 を設定した場合、指輪の外周から 0,5mm 内周側へ指輪を削り出した台座が生成されます(削りすぎると指輪の内周にめり込むのでご注意下さい)
/// @param stage_type            クロス部分を乗せるステージの造形タイプを設定できます
///                                [ ]: なし( stage_depth < 0 の場合や、独自にデザインしたステージのモデルをリングとクロスの間に挟み込みたい場合にご使用下さい)
///                                "chamfered_cube": 面取り立方体
///                                "shaft": シャフト
/// @param stage_size            クロス部分を乗せるステージを造形する場合に大きさを設定します( chamfered_cube: [ X長さ(mm), Y長さ(mm) ], shaft: 直径(mm) )
/// @param stage_rotation        クロス部分を乗せるステージを造形する場合にZ軸回転を設定します。矩形状のステージの場合に 45 deg 回すと厨二度が向上します
/// @param stage_chamfering_parameters クロス部分を乗せるステージを造形する場合の面取り設定 [ 角度(deg), 深さ(mm), タイプ("C"=平面,"R"=円) ]
/// @param ring_chamfering_parameters  指輪の面取り設定 [ 角度(deg), 深さ(mm), タイプ("C"=平面,"R"=円) ]
/// @param inner_diameter        指輪の内直径 [mm] ( この引数を使用する場合 inner_circumference は無視します )
/// @param inner_text            指輪の内側に彫り込む文字列
/// @param outer_text            指輪の外側に彫り込む文字列(クロス部分は適当に space を入れて隔てるように調整するとかして下さい)
/// @param key_switch_data       part/siwtch/key_switch 系で使用可能な data パラメーターと同様のスイッチ造形用パラメーターをユーザー定義できます
///                              よくわからない場合は引数を与えなければ自動的に Cherry MX 互換の設定が使用されます
///                              クロス部分の造形パラメーターを独自にカスタマイズしたい場合にご使用頂ければ幸いです
module the_MX_of_the_ring
( inner_circumference = 48.2
, thickness = 1
, width = 4.5
, stage_depth = -0.5
, stage_type = "chamfered_cube"
, stage_size = [ ]
, stage_rotation = 0
, stage_chamfering_parameters = [ 0, 0.1, "R" ]
, ring_chamfering_parameters = [ 45, 0.2, "C" ]
, inner_diameter = [ ]
, key_switch_data = [ ]
)
{
  let
  ( inner_diameter = inner_diameter != [ ] ? inner_diameter : inner_circumference / PI
  , outer_diameter = inner_diameter + thickness * 2
  , outer_radius = outer_diameter / 2
  , key_switch_data = key_switch_data != [ ] ? key_switch_data : reference_switch_parameters_Cherry_MX
  , data_indices = 
      search
      ( [ "stem_cross_x_bar"
        , "stem_cross_y_bar"
        ]
      , key_switch_data
      )
  , data_index_of_stem_cross_x_bar = data_indices[ 0 ]
  , data_index_of_stem_cross_y_bar = data_indices[ 1 ]
  , data_of_stem_cross_x_bar = key_switch_data[ data_index_of_stem_cross_x_bar ][ 1 ]
  , data_of_stem_cross_y_bar = key_switch_data[ data_index_of_stem_cross_y_bar ][ 1 ]
  , cross_xy = [ data_of_stem_cross_x_bar[ 0 ], data_of_stem_cross_y_bar[ 1 ] ]
  )
  {
    union()
    {
      difference()
      {
        translate( [ 0, 0, -outer_radius - stage_depth ] )
          rotate( [ 90, 0, 0 ] )
            pipe( inner_diameter, outer_diameter, width, chamfering_parameters = ring_chamfering_parameters, center = true );
        if ( stage_depth < 0 )
          translate( [ -outer_radius, -outer_radius, 0 ] )
            cube( [ outer_diameter, outer_diameter, outer_diameter ] );
      }
      if ( stage_type == "chamfered_cube" )
        let( stage_size = stage_size != [ ] ? stage_size : cross_xy )
          rotate( [ 0, 0, stage_rotation ] )
            translate( [ -stage_size[ 0 ] / 2, -stage_size[ 1 ] / 2, -stage_depth - thickness ] )
              chamfered_cube( [ stage_size[ 0 ], stage_size[ 1 ], stage_depth + thickness ], chamfering_parameters = stage_chamfering_parameters );
      else if ( stage_type == "shaft" )
        let( stage_size = stage_size != [ ] ? stage_size : cross_xy[ 0 ] )
          translate( [ 0, 0, -stage_depth - thickness ] )
            shaft( stage_size, stage_depth + thickness, chamfering_parameters = stage_chamfering_parameters );
      key_switch_stem( key_switch_data, enable_cross = true, enable_stage = false, enable_rails = false, enable_skirt = false, enable_shaft = false );
    }
  }
}
