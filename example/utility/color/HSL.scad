use <../../../utility/color/HSL.scad>

$fn = 6;

for ( L = [ 0 : 1 / 6: 1 ] )
  for ( S = [ 0 : 1 / 5: 1 ] )
    for ( H = [ 0 : 30 : S > 0 ? 360 - 1 : 0 ] )
      translate( [ S * cos( H ), S * sin( H ), L - 0.5 ] )
        color( to_RGB_from_HSL( [ H, S, L ] ) )
          rotate( [ $t * 720, 0, $t * 360 ] )
            scale( 1 - S )
              cylinder( d = 0.1, h = 0.075, center = true );
