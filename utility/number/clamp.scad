/// value を [ lowest .. highest ] へ丸める
function clamp( value, lowest = 0, highest = 1 ) =
  max( min( value, highest ), lowest );
