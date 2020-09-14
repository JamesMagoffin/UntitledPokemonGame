#Moves2Anim Cache
class PokemonTemp
  attr_accessor :cachePkmnAnims2
end

def pbLoadCachedAnimations2
  $PokemonTemp=PokemonTemp.new if !$PokemonTemp
  if !$PokemonTemp.cachePkmnAnims2
    $PokemonTemp.cachePkmnAnims2=load_data("Data/move2anim.dat")
  end
  return $PokemonTemp.cachePkmnAnims2
end