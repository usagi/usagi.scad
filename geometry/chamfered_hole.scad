include <chamfered_cube.scad>
include <../part/shaft.scad>

/// @param hole_size 穴の大きさ
///                    hole_type == "cube"    : [ X, Y, Z ]
///                    hole_type == "cylinder": [ Diameter, Height ]
/// @param hole_type 穴の形状 "cube" | "cylinder" | "screw"
/// @aperrural_angle 穴からの面取り部分の開口角度(穴の中心から左右両方へ併せて180°までのうち、どれだけ開くか。片側だけみて30°なら両側で60°として与えます)
module chamfered_hole
( hole_size
, hole_type = "cube"
, apertural_angle   = 120
, apertural_length  = 0
, piercing = false
, center = false
)
{
  if ( hole_type == "cube" )
    translate
    ( [ center ? -hole_size[ 0 ] / 2 : 0
      , center ? -hole_size[ 1 ] / 2 : 0
      , 0
      ]
    )
    {
      translate( [ 0, 0, -hole_size[ 2 ] ] )
        cube( hole_size );
      
      ah = apertural_angle / 2;
      dy = apertural_length / tan( ah );
      dh = apertural_length * 2;
      s = [ hole_size[ 0 ] + dh, hole_size[ 1 ] + dh, dy * 2 ];
      cp = [ ah, dy, "C" ];

      translate( [ -apertural_length, -apertural_length, -dy ] )
        chamfered_cube( s, bottom_chamfering_parameters = cp );

      if ( piercing )
        translate( [ -apertural_length, -apertural_length, -hole_size[ 2 ] - dy ] )
          chamfered_cube( s, top_chamfering_parameters = cp );
    }
  else if ( hole_type == "cylinder" )
  {
    translate( [ 0, 0, -hole_size[ 1 ] ] )
      cylinder( d = hole_size[ 0 ], h = hole_size[ 1 ] );

    ah = apertural_angle / 2;
    dy = apertural_length / tan( ah );
    dd = apertural_length * 2;
    
    cp = [ ah, dy, "C" ];

    translate( [ 0, 0, -dy ] )
      shaft( hole_size[ 0 ] + dd, dy * 2, chamfering_parameters = cp );        
    
    if ( piercing )
      translate( [ 0, 0, -hole_size[ 1 ] - dy ] )
        shaft( hole_size[ 0 ] + dd, dy * 2, chamfering_parameters = cp );
  }
}
