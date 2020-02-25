include <reverse.scad>

/// vector の末尾要素から length 個の要素を逆順で取得
function pop_vector( v, length = 0 ) = 
  let( end = len( v ) )
    reverse( slice_vector( v, end - length, end ) )
  ;