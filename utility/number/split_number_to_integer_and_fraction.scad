/// @brief 数値を整数部と小数部へ分離
/// @return [ 整数部, 小数部 ]
function split_number_to_integer_and_fraction( number ) = 
  let( integer_part = floor( number ) )
    [ integer_part, number - integer_part ]
  ;