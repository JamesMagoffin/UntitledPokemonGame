def pbChangeName(name=nil,outfit=0)
  pbChangePlayer(0) if $PokemonGlobal.playerID<0
  trainertype = pbGetPlayerTrainerType
  $trname = name
  if $trname==nil
    $trname = pbEnterPlayerName(_INTL("Your name?"),0,PLAYERNAMELIMIT)
    if $trname==""
      gender = pbGetTrainerTypeGender(trainertype) 
      trname = pbSuggestTrainerName(gender)
    end
  end
  $Trainer.name = $trname
end