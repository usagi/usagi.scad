/// 2つの [ [ key, value ] ] 型の vector を key を重複させずに結合
/// @note 組み込み版の concat の key による重複なし結合版です
///       key-value 型のデータ a に対して一部の key-value の更新または新規 key-value の追加を
///       行いたい場合に使用します
function concat_without_duplication( a, b ) =
  [ // step-1: a の keys を b から探して b の値で a の値を更新または a の値をそのまま採用
     for ( a_pair = a )
      let
      ( a_key     = a_pair[ 0 ]
      , a_value   = a_pair[ 1 ]
      , b_indices = search( [ a_key ], b )
      , b_index   = b_indices[ 0 ]
      )
        b_index == [ ] ? a_pair : b[ b_index ]
  , // step-2: b にしかない keys を a から探して b にしかない pair(key,value) 組を追加
    for ( b_pair = b )
      let
      ( b_key   = b_pair[ 0 ]
      , b_value = b_pair[ 1 ]
      , a_indices = search( [ b_key ], a )
      , a_index = a_indices[ 0 ]
      )
        if ( a_index == [ ] )
          b_pair
  ];
