include <reverse.scad>

/// 2D頂点群からなる vector についてX軸またはY軸の鏡像を成す頂点群または元の頂点群に鏡像部位を追加した頂点群を取得
/// @param vertices [ [ x0, y0 ], [ x1, y1 ], ... ]
/// @param x true:ミラー頂点をX軸反転で生成する, false:反転せずに生成する
/// @param y true:ミラー頂点をY軸反転で生成する, false:反転せずに生成する
/// @param merge true:元の頂点群にミラー頂点群を結合した頂点群を取得する, false:ミラー頂点群のみを取得する
function mirror( vertices, x = true, y = false, merge = true ) = 
  let
  ( p = x ? -1 : 1
  , q = y ? -1 : 1
  )
    [ if ( merge )
        for ( v = vertices )
          v
    , for ( v = reverse( vertices ) )
        [ p * v[ 0 ], q * v[ 1 ] ]
    ]
  ;
