include <../number/round_number_to_significant_figures.scad>

/// @brief 数値を文字列にし、指定桁に対して小数点以下の 0 が足りなければ指定桁になるまで 0 埋めする
/// @note ( 1.23, 8 ) -> "1.2300000"
function number_to_string_with_digit( number = 0, digit = 0, zero_dot_is_not_a_valid_digit = true ) =
  let
  ( tmp           = str( number )
  , count_of_dot  = len( search( ".", tmp ) )
  , has_dot       = count_of_dot > 0
  , first_is_zero = len( tmp ) > 0 && tmp[ 0 ] == "0"
  , current_digit = len( tmp ) - count_of_dot - ( ( zero_dot_is_not_a_valid_digit && first_is_zero ) ? 1 : 0 )
  , digit         = digit == 0 ? current_digit : digit
  //, _ = echo( tmp, count_of_dot, has_dot, current_digit, zero_dot_is_not_a_valid_digit, first_is_zero ) // for debug
  )
    current_digit == digit
      ? tmp
      : current_digit > digit
        ? str( round_number_to_significant_figures( number, digit ) )
        : number_to_string_with_digit( str( tmp, has_dot ? "" : "." , "0" ), digit, zero_dot_is_not_a_valid_digit )
    ;
