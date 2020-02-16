include <count_integer_part_digits.scad>

/// @brief 数値を有効数字の桁へ丸める
function round_number_to_significant_figures( number, digits ) =
  let
  ( integer_part_digits = count_integer_part_digits( number )
  , factor              = pow( 10, integer_part_digits - digits )
  //, debug = echo( "D", integer_part_digits, factor, number, digits, "|", number / factor )
  )
    round( number / factor ) * factor
  ;