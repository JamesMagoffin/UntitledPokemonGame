#Animations Cache
class PokemonTemp
  attr_accessor :cachePkmnAnims
end

def pbLoadCachedAnimations
  $PokemonTemp=PokemonTemp.new if !$PokemonTemp
  if !$PokemonTemp.cachePkmnAnims
    $PokemonTemp.cachePkmnAnims=load_data("Data/PkmnAnimations.rxdata")
  end
  return $PokemonTemp.cachePkmnAnims
end