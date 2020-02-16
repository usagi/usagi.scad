/// @brief 数値の整数部の桁を取得
function count_integer_part_digits( number ) =
  number > 0
    ? ceil( log( number ) )
    : number < 0
      ? ceil( log( -number ) )
      : 0
  ;