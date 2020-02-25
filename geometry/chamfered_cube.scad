include <chamfered_square.scad>

/// 面取り付き cube を造形
/// @param size [ x, y, z ] 各次元の長さ [mm]
/// @param chamfering_angle   面取り角度 [deg] (全ての面取りで共通のデフォルトの面取りパラメーターを使用したい場合用)
/// @param chamfering_length  面取り長さ(深さ) [mm] (全ての面取りで共通のデフォルトの面取りパラメーターを使用したい場合用)
/// @param chamfering_type    面取りタイプ "C" or "R" (全ての面取りで共通のデフォルトの面取りパラメーターを使用したい場合用)
/// @param chamfering_parameters 面取りパラメーター群を独立した実引数ではなく [ angle, length, type ] でまとめてモジュールを呼びたい場合用
/// @param top_right_chamfering_parameters    上面(+Z向き面)側の右面(+X向き)側の面取り設定( [ angle, length, type ] )
/// @param top_left_chamfering_parameters     上面(+Z向き面)側の左面(-X向き)側の面取り設定( [ angle, length, type ] )
/// @param top_back_chamfering_parameters     上面(+Z向き面)側の右面(+Y向き)側の面取り設定( [ angle, length, type ] )
/// @param top_front_chamfering_parameters    上面(+Z向き面)側の左面(-X向き)側の面取り設定( [ angle, length, type ] )
/// @param bottom_right_chamfering_parameters 下面(+Z向き面)側の右面(+X向き)側の面取り設定( [ angle, length, type ] )
/// @param bottom_left_chamfering_parameters  下面(+Z向き面)側の左面(-X向き)側の面取り設定( [ angle, length, type ] )
/// @param bottom_back_chamfering_parameters  下面(+Z向き面)側の右面(+Y向き)側の面取り設定( [ angle, length, type ] )
/// @param bottom_front_chamfering_parameters 下面(+Z向き面)側の左面(-X向き)側の面取り設定( [ angle, length, type ] )
/// @param front_right_chamfering_parameters  前面(-Y向き面)側の右面(+X向き)側の面取り設定( [ angle, length, type ] )
/// @param front_left_chamfering_parameters   前面(-Y向き面)側の左面(-X向き)側の面取り設定( [ angle, length, type ] )
/// @param back_right_chamfering_parameters   背面(+Y向き面)側の右面(+X向き)側の面取り設定( [ angle, length, type ] )
/// @param back_left_chamfering_parameters    背面(+Y向き面)側の左面(-X向き)側の面取り設定( [ angle, length, type ] )
/// @note 面の詳細度が高いパラメーターは面の詳細度の低いパラメーターよりも優先される
///         例1: top_right_ > top_ > (default)
///       面の詳細度が同じパラメーターかつ同じ面が重複して設定される場合の優先度は仕様として定義するものではなく実装詳細の変更により変わる可能性がある
///         例2: top_ と bottom_ を併用 --> 重複する面は無いのでどちらの設定も安全に有効
///         例3: top_ と right_ を併用 --> top_right_ に相当する面で重複が発生する
///               sub case A: top_ と right_ に同じ面取り設定を与えた場合   --> どちらが優先されても結果は同じなので安全に有効
///               sub case B: top_ と right_ に異なる面取り設定を与えた場合 --> どちらが採用されるか仕様として未定義なので動作は実装依存で不定
///       例 3/sub case B の場合は追加で top_right_ 引数を明示的に与える事で確実に意図した面取り設定を安全に有効化できます
module chamfered_cube
( size
// --- optional detail level-2 / indivual ---
, chamfering_angle = 0
, chamfering_length = 0
, chamfering_type = "C"
// --- optional detail level 2 / conposit ---
, chamfering_parameters = [ ] // 独立した実引数ではなく [ angle, length, type ] でまとめてモジュールを呼びたい場合用
// --- optional detail level 1 ---
, top_chamfering_parameters     = [ ] // 上面の右/左/前/背の4面の面取りをまとめて設定
, bottom_chamfering_parameters  = [ ] // 下面の右/左/前/背の4面の面取りをまとめて設定
, front_chamfering_parameters   = [ ] // 前面の右/左/上/下の4面の面取りをまとめて設定
, back_chamfering_parameters    = [ ] // 背面の右/左/上/下の4面の面取りをまとめて設定
, right_chamfering_parameters   = [ ] // 右面の上/下/前/背の4面の面取りをまとめて設定
, left_chamfering_parameters    = [ ] // 左面の上/下/前/背の4面の面取りをまとめて設定
// --- optional detail level 0 ---
, top_right_chamfering_parameters    = [ ] // 上面(+Z向き面)側の右面(+X向き)側の面取り設定
, top_left_chamfering_parameters     = [ ] // 上面(+Z向き面)側の左面(-X向き)側の面取り設定
, top_back_chamfering_parameters     = [ ] // 上面(+Z向き面)側の背面(+Y向き)側の面取り設定
, top_front_chamfering_parameters    = [ ] // 上面(+Z向き面)側の前面(-X向き)側の面取り設定

, bottom_right_chamfering_parameters = [ ] // 下面(+Z向き面)側の右面(+X向き)側の面取り設定
, bottom_left_chamfering_parameters  = [ ] // 下面(+Z向き面)側の左面(-X向き)側の面取り設定
, bottom_back_chamfering_parameters  = [ ] // 下面(+Z向き面)側の背面(+Y向き)側の面取り設定
, bottom_front_chamfering_parameters = [ ] // 下面(+Z向き面)側の前面(-X向き)側の面取り設定

, front_right_chamfering_parameters  = [ ] // 前面(-Y向き面)側の右面(+X向き)側の面取り設定
, front_left_chamfering_parameters   = [ ] // 前面(-Y向き面)側の左面(-X向き)側の面取り設定
, back_right_chamfering_parameters   = [ ] // 背面(+Y向き面)側の右面(+X向き)側の面取り設定
, back_left_chamfering_parameters    = [ ] // 背面(+Y向き面)側の左面(-X向き)側の面取り設定

, center = false
)
{
  translate( center ? -size / 2 : [ 0, 0, 0 ] )
  // default, level-2
  let
  ( chamfering_parameters = chamfering_parameters == [ ] ? [ chamfering_angle, chamfering_length, chamfering_type ] : chamfering_parameters
  , top_chamfering_parameters    = top_chamfering_parameters    == [ ] ? chamfering_parameters : top_chamfering_parameters
  , bottom_chamfering_parameters = bottom_chamfering_parameters == [ ] ? chamfering_parameters : bottom_chamfering_parameters
  , right_chamfering_parameters  = right_chamfering_parameters  == [ ] ? chamfering_parameters : right_chamfering_parameters
  , left_chamfering_parameters   = left_chamfering_parameters   == [ ] ? chamfering_parameters : left_chamfering_parameters
  , front_chamfering_parameters  = front_chamfering_parameters  == [ ] ? chamfering_parameters : front_chamfering_parameters
  , back_chamfering_parameters   = back_chamfering_parameters   == [ ] ? chamfering_parameters : back_chamfering_parameters
  )
  // level-1/top,bottom
  let
  ( top_right_chamfering_parameters    = top_right_chamfering_parameters    != [ ] ? top_right_chamfering_parameters    : top_chamfering_parameters
  , top_left_chamfering_parameters     = top_left_chamfering_parameters     != [ ] ? top_left_chamfering_parameters     : top_chamfering_parameters
  , top_back_chamfering_parameters     = top_back_chamfering_parameters     != [ ] ? top_back_chamfering_parameters     : top_chamfering_parameters
  , top_front_chamfering_parameters    = top_front_chamfering_parameters    != [ ] ? top_front_chamfering_parameters    : top_chamfering_parameters
  , bottom_right_chamfering_parameters = bottom_right_chamfering_parameters != [ ] ? bottom_right_chamfering_parameters : bottom_chamfering_parameters
  , bottom_left_chamfering_parameters  = bottom_left_chamfering_parameters  != [ ] ? bottom_left_chamfering_parameters  : bottom_chamfering_parameters
  , bottom_back_chamfering_parameters  = bottom_back_chamfering_parameters  != [ ] ? bottom_back_chamfering_parameters  : bottom_chamfering_parameters
  , bottom_front_chamfering_parameters = bottom_front_chamfering_parameters != [ ] ? bottom_front_chamfering_parameters : bottom_chamfering_parameters
  )
  // level-1/right,left
  let
  ( top_right_chamfering_parameters    = top_right_chamfering_parameters    != [ ] ? top_right_chamfering_parameters    : right_chamfering_parameters
  , bottom_right_chamfering_parameters = bottom_right_chamfering_parameters != [ ] ? bottom_right_chamfering_parameters : right_chamfering_parameters
  , front_right_chamfering_parameters  = front_right_chamfering_parameters  != [ ] ? front_right_chamfering_parameters  : right_chamfering_parameters
  , back_right_chamfering_parameters   = back_right_chamfering_parameters   != [ ] ? back_right_chamfering_parameters   : right_chamfering_parameters
  , top_left_chamfering_parameters     = top_left_chamfering_parameters     != [ ] ? top_left_chamfering_parameters     : left_chamfering_parameters
  , bottom_left_chamfering_parameters  = bottom_left_chamfering_parameters  != [ ] ? bottom_left_chamfering_parameters  : left_chamfering_parameters
  , front_left_chamfering_parameters   = front_left_chamfering_parameters   != [ ] ? front_left_chamfering_parameters   : left_chamfering_parameters
  , back_left_chamfering_parameters    = back_left_chamfering_parameters    != [ ] ? back_left_chamfering_parameters    : left_chamfering_parameters
  )
  // level-1/front,back
  let
  ( top_front_chamfering_parameters    = top_front_chamfering_parameters    != [ ] ? top_front_chamfering_parameters    : front_chamfering_parameters
  , bottom_front_chamfering_parameters = bottom_front_chamfering_parameters != [ ] ? bottom_front_chamfering_parameters : front_chamfering_parameters
  , front_right_chamfering_parameters  = front_right_chamfering_parameters  != [ ] ? front_right_chamfering_parameters  : front_chamfering_parameters
  , front_left_chamfering_parameters   = front_left_chamfering_parameters   != [ ] ? front_left_chamfering_parameters   : front_chamfering_parameters
  , top_back_chamfering_parameters     = top_back_chamfering_parameters     != [ ] ? top_back_chamfering_parameters     : back_chamfering_parameters
  , bottom_back_chamfering_parameters  = bottom_back_chamfering_parameters  != [ ] ? bottom_back_chamfering_parameters  : back_chamfering_parameters
  , back_right_chamfering_parameters   = back_right_chamfering_parameters   != [ ] ? back_right_chamfering_parameters   : back_chamfering_parameters
  , back_left_chamfering_parameters    = back_left_chamfering_parameters    != [ ] ? back_left_chamfering_parameters    : back_chamfering_parameters
  )
    intersection()
    {
      translate( [ 0, size[ 1 ], 0 ] )
        rotate( [ 90, 0, 0 ] )
          linear_extrude( size[ 1 ] )
            chamfered_square
            ( [ size[ 0 ], size[ 2 ] ]
            , inner_top_chamfering_angle  = top_left_chamfering_parameters[ 0 ]
            , inner_top_chamfering_length = top_left_chamfering_parameters[ 1 ]
            , inner_top_chamfering_type   = top_left_chamfering_parameters[ 2 ]
            , outer_top_chamfering_angle  = top_right_chamfering_parameters[ 0 ]
            , outer_top_chamfering_length = top_right_chamfering_parameters[ 1 ]
            , outer_top_chamfering_type   = top_right_chamfering_parameters[ 2 ]
            , inner_bottom_chamfering_angle  = bottom_left_chamfering_parameters[ 0 ]
            , inner_bottom_chamfering_length = bottom_left_chamfering_parameters[ 1 ]
            , inner_bottom_chamfering_type   = bottom_left_chamfering_parameters[ 2 ]
            , outer_bottom_chamfering_angle  = bottom_right_chamfering_parameters[ 0 ]
            , outer_bottom_chamfering_length = bottom_right_chamfering_parameters[ 1 ]
            , outer_bottom_chamfering_type   = bottom_right_chamfering_parameters[ 2 ]
            );
      
      rotate( [ 90, 0, 90 ] )
        linear_extrude( size[ 0 ] )
          chamfered_square
          ( [ size[ 1 ], size[ 2 ] ]
          , inner_top_chamfering_angle  = top_front_chamfering_parameters[ 0 ]
          , inner_top_chamfering_length = top_front_chamfering_parameters[ 1 ]
          , inner_top_chamfering_type   = top_front_chamfering_parameters[ 2 ]
          , outer_top_chamfering_angle  = top_back_chamfering_parameters[ 0 ]
          , outer_top_chamfering_length = top_back_chamfering_parameters[ 1 ]
          , outer_top_chamfering_type   = top_back_chamfering_parameters[ 2 ]
          , inner_bottom_chamfering_angle  = bottom_front_chamfering_parameters[ 0 ]
          , inner_bottom_chamfering_length = bottom_front_chamfering_parameters[ 1 ]
          , inner_bottom_chamfering_type   = bottom_front_chamfering_parameters[ 2 ]
          , outer_bottom_chamfering_angle  = bottom_back_chamfering_parameters[ 0 ]
          , outer_bottom_chamfering_length = bottom_back_chamfering_parameters[ 1 ]
          , outer_bottom_chamfering_type   = bottom_back_chamfering_parameters[ 2 ]
          );
      
      linear_extrude( size[ 2 ] )
        chamfered_square
        ( [ size[ 0 ], size[ 1 ] ]
        , inner_top_chamfering_angle  = back_left_chamfering_parameters[ 0 ]
        , inner_top_chamfering_length = back_left_chamfering_parameters[ 1 ]
        , inner_top_chamfering_type   = back_left_chamfering_parameters[ 2 ]
        , outer_top_chamfering_angle  = back_right_chamfering_parameters[ 0 ]
        , outer_top_chamfering_length = back_right_chamfering_parameters[ 1 ]
        , outer_top_chamfering_type   = back_right_chamfering_parameters[ 2 ]
        , inner_bottom_chamfering_angle  = front_left_chamfering_parameters[ 0 ]
        , inner_bottom_chamfering_length = front_left_chamfering_parameters[ 1 ]
        , inner_bottom_chamfering_type   = front_left_chamfering_parameters[ 2 ]
        , outer_bottom_chamfering_angle  = front_right_chamfering_parameters[ 0 ]
        , outer_bottom_chamfering_length = front_right_chamfering_parameters[ 1 ]
        , outer_bottom_chamfering_type   = front_right_chamfering_parameters[ 2 ]
        );
    }
}
