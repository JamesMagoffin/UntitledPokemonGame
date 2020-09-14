#===============================================================================
# * Visible Overworld Encounters V1.11.2 - by derFischae (Credits if used please) *
#===============================================================================
#
# UPDATED TO VERSION 1.11.2. NOW INCLUDING VENDILYS RESCUE CHAIN
#
# This script is for Pokémon Essentials 17.
# As in Pokemon Let's go Pikachu/Eevee or Pokemon Shild and Sword
# random encounters pop up on the overworld,
# they move around and you can start the battle
# with them simply by moving to the pokemon.
# Clearly, you also can omit the battle by circling around them.
# 
#
# FEATURES INCLUDED:
#   - see the pokemon on the overworld before going into battle
#   - no forced battling against random encounters
#   - plays the pokemon cry while spawning
#   - Choose whether encounters occure on all terrains or only on 
#     the terrain of the player
#   - In caves, pokemon don't spawn on impassable Rock-Tiles, which have the Tile-ID 4 
#   - if you kill the same species in a row, then you increase
#     the chance of spawning a shiny of that species or an evolved pokemon of that species family
#   - choose whether pokemon spawn automatically or only while moving the player
#   - Vendilys Rescue Chain, see https://www.pokecommunity.com/showthread.php?t=415524 for original script
#   - If you want to add a procedure that modifies a pokemon only for spawning but not before battling
#     then you can use the Event @@OnWildPokemonCreateForSpawning.
#   - You can check if you are battleing a spawned pokemon with the global variable $PokemonGlobal.battlingSpawnedPokemon
#
# MODIFICATIONS OF THIS SCRIPT
# Read the whole thread https://www.pokecommunity.com/showthread.php?t=429019 for more features and modifications, including
#  - instructions on how to modify a pokemon on spawning but not on battling again, for example for the script level balancing by Joltik https://www.pokecommunity.com/showthread.php?t=409828
#  - randomized spawning
#  - adding shiny sparkle animation to spawned overworld shinys, especially useful if you want to sign out the shiny encounters on the map without using overworld shiny sprites
#  - activating and deactivating overworld encounter spawning with switches
#  - overworld spawning and original encounters at the same time
#  - forbidding pokemon to spawn on specific terrain tiles in caves
#  - adding new encounter types, eg. desert, shallow water
#  - instructions on how to have different encounters for overworld spawning and original encountering on the same map
#  - instructions on how to include JoelMatthews Add-Ons for Vendilys Rescue Chain, concerening setting the probability of spawning with hidden abilities or with max IVs
#    see https://www.pokecommunity.com/showthread.php?t=422513 for original script
#  - error solutions
#
# NEW FEATURES IN VERSION 1.1:
#   - less lag
#   - supports sprites for alternative forms of pokemon
#
# NEW FEATURES IN VERSION 1.2:
#   - supports sprites for female/male/genderless pokemon
#
# NEW FEATURES IN VERSION 1.3:
#   - bug fixes for roaming encounter and double battles
#
# NEW FEATURES IN VERSION 1.4:
#   - more options in settings
#
# NEW FEATURES IN VERSION 1.5:
#   - roaming encounters working correctly
#
# NEW FEATURES IN VERSION 1.6:
#   - more lag reduction 
#
# NEW FEATURES IN VERSION 1.7:
#   - included automatic spawning of pokemon, i.e. spawning without having to move the player
#
# NEW FEATURES IN VERSION 1.8:
#   - included vendilys rescue chain, i. e. if pokemon of the same species family spawn in a row and will be battled in a row, then you increase the chance of spawning
#     an evolved pokemon of that species family. Link: https://www.pokecommunity.com/showthread.php?t=415524
#
# NEW FEATURES IN VERSION 1.9:
#   - removed bug occuring after fainting against wild overworld encounter
#   - for script-developers, shortened the spawnEvent method for better readablitiy
#
# NEW FEATURES IN VERSION 1.10:
#   - removed bugs from version 1.9
#   - added shapes of overworld encounter for rescue chain users
#   - supports spawning of alternate forms while chaining
#   - if overworld sprites for alternative, female or shiny forms are missing,
#     then the standard sprite will be displayed instead of an invisible event
#   - bug fix for shiny encounters
#
# NEW FEATURES IN VERSION 1.11:
#   - respecting shiny state for normal encounters when using overworld and normal encounters at the same time
#   - easier chaining concerning Vendilys Rescue chain, i.e. no more resetting of the chain when spawning of a pokemon of different family but when fighting with a pokemon of different family
#   - Added new Event @@OnPokemonCreateForSpawning which only triggers on spawning
#   - Added new global variable $PokemonGlobal.battlingSpawnedShiny to check if an active battle is against a spawned pokemon.
#
# NEW FEATURES IN VERSION 1.11.2:
#   - removed bug to make the new features in version 1.11 work
#
# INSTALLATION:
# Installation as simple as it can be.
# Step 1) You need sprites for the overworld pokemon in your \Graphics\Characters
# folder named by there number 001.png, 002.png, ...,
# For instance you can use Gen 1-7 OV SPrites or whatever you want for your fakemon
# If you want to use shiny overworld sprites for shiny encounters, then make sure
# to also have the corresponding shiny versions in your \Graphics\Characters
# folder named by 001s.png, 002s.png, ....
# If you want to use alternative forms as overworld sprites, then make sure that
# you also have a sprite for each alternative form, e. g. for Unown 201_1.png, 
# 201s_1.png, 201_2.png, 201s_2.png, ...
# Please note that Scatterbug has 18 alternative forms in Pokemon Essentials. 
# But you will only see one form depending on your trainerID. 
# So, you also have to include 664_1.png, ..., 664_19.png and 664s_1.png, ..., 664s_19.png. 
# Same needs to be done for Pokemon Spewpa with number 665 and Vivillon with number 666. 
# If you want to use female forms as overworld sprites, then make sure that you 
# also have a female sprite for each pokemon named 001f.png, 001fs.png, 002f.png, 
# 002fs.png, ... (excluding genderless pokemon of course)
# Step 2) Insert a new file in the script editor above main,
# name it Overworld_Random_Encounters and copy this code into it. 
# 
# PROPERTIES:
# 1) If you want to have water encounters only while surfing,
# you also have to change the value of the
# upcoming parameter RESTRICTENCOUNTERSTOPLAYERMOVEMENT to
#     RESTRICTENCOUNTERSTOPLAYERMOVEMENT = true
# 2) You can choose how many steps the encounter moves before vanishing 
# in parameter
#     STEPSBEFOREVANISHING
# 3) You can choose how many encounters you have to kill to obtain the increased
# Shiny-Chance in parameter
#     CHAINLENGTH
# and the increased Shiny-Chance in parameter
#     SHINYPROBABILITY
# 4) You can choose whether the overworld sprite of an shiny encounter
# is always the standard sprite or is the corrensponding shiny overworld sprite  in parameter
#     USESHINYSPRITES
# 5) You can choose whether the sprite of your overworld encounter
# is always the standard sprite or can be an alternative form in parameter
#     USEALTFORMS
# 6) You can choose whether the sprites depend on the gender of the encounter
# or are always neutral in parameter
#     USEFEMALESPRITES
# 7) You can choose whether the overworld encounters have a stop/ step-animation
# similar to following pokemon in the parameter
#     USESTOPANIMATION
# 8) You can choose how many overworld encounters are agressive and run to the 
# player in the parameter
#     AGGRESSIVEENCOUNTERPROBABILITY
# 9) You can choose the move-speed and move-frequenzy of  normal and aggressive 
# encounters in parameters
#     ENCMOVESPEED, ENCMOVEFREQ, AGGRENCMOVESPEED, AGGRENCMOVEFREQ
# 10) You can choose whether pokemon can spawn automatically or only while the 
# player is moving and you can set the spawning frequency in the parameter
#     AUTOSPAWNSPEED
# 11) You can activate or deactivate vendilys rescue chain in the parameter 
#     USERESCUECHAIN
# Moreover, you also have all settings of vendilys Rescue chain here.
# 12) If you have impassable tiles in a cave, where you don't want pokemon to spawn there. Then choose the Tile-ID 4 for that tile in the tile-editor.
#
# THANKS to BulbasaurLvl5 for bringing me to pokemon essentials

#===============================================================================
#                             Settings            
#===============================================================================

RESTRICTENCOUNTERSTOPLAYERMOVEMENT = false
#true - means that water encounters are popping up
#       if and only if player is surfing
#       (perhaps decreases encounter rate)
#false - means that all encounter types can pop up
#        close to the player (as long as there is a suitable tile)

CHAINLENGTH      = 10 # default 10
#       number describes how many pokemon of the same species
#       you have to kill in a row to increase shiny propability

SHINYPROBABILITY = 100 # default 100 --> 10%
#       increasing this value decreases the probability of spawning a shiny

STEPSBEFOREVANISHING = 6 # default 10
#      STEPSBEFOREVANISHING is the number of steps a wild Encounter goes
#      before vanishing on the map.

USESHINYSPRITES = true # default false
#false - means that you don't use shiny sprites for your overworld encounter
#true - means that a shiny encounter will have a its special shiny overworld sprite
#       make sure that you have the shiny sprites named with an "s" (e.g. 001s.png) 
#       for the shiny forms in your \Graphics\Characters folder       

USEALTFORMS = true # default false
#false - means that you don't use alternative forms for your overworld sprite
#true - means that the sprite of overworld encounter varies by the form of that pokemon
#       make sure that you have the sprites with the right name
#       for your alternative forms in your \Graphics\Characters folder       

USEFEMALESPRITES = true # default false
#false - means that you use always a neutral overworld sprite
#true - means that female pokemon have there own female overworld sprite
#       make sure that you have the sprites with the right name 001f.png,
#       001fs.png, ... for the female forms in your \Graphics\Characters folder

USESTOPANIMATION = true # default false
#false - means that overworld encounters don't have a stop- animation
#true - means that overworld encounters have a stop- animation similar as  
#       following pokemon

ENCMOVESPEED = 3 # default 3
# this is the movement speed (compare to autonomous movement of events) of an overworld encounter
#1   - means lowest movement
#6   - means highest movement

ENCMOVEFREQ = 3 # default 3
# this is the movement frequenzy (compare to autonomous movement of events) of an overworld encounter
#1   - means lowest movement
#6   - means highest movement

AGGRESSIVEENCOUNTERPROBABILITY = 20 # default 20 
#this is the probability in percent of spawning of an agressive encounter
#0   - means that there are no aggressive encounters
#100 - means that all encounter are aggressive

AGGRENCMOVESPEED = 3 # default 3
# this is the movement speed (compare to autonomous movement of events) of an aggressive encounter
#1   - means lowest movement
#6   - means highest movement

AGGRENCMOVEFREQ = 5 # default 5
# this is the movement frequenzy (compare to autonomous movement of events) of an aggressive encounter
#1   - means lowest movement
#6   - means highest movement

AUTOSPAWNSPEED = 0 # default 60
#You can set the speed of automatic pokemon spawning, i.e. the ability of pokemon
# to spawn automatically even without even moving the player.
#0   - means that pokemon only spawn while the player is moving
#>0  - means automatic spawning is activated, the closer to 0 the faster the spawning

USERESCUECHAIN = false # default false
#This parameter activates and deactivates vendilys rescue chain
#true  - means that fighting pokemon of the same speciesfamily in a row will increase the chance of spawning an evolved pokemon
#false - means that the rescue chain is deactivated
#
#Here the settings for Vendilys Rescue Chain
#    #===============================================================================
#    # Rescue Chain - By Vendily [v17]
#    # This script makes it so that if you chain pokemon of the same evolutionary
#    #  family together, an evolved form of the species will appear.
#    # I used no references and I completly misinterpreted a description of SOS
#    #  battles as this thing.
#    # * Minimum length of chain before evolved forms begin to appear. With every
#    #    multiple, the chance for the evolved form or a second evolved form to appear
#    #    increases. (Default 10)
#    # * Chance that the evolved form will even show up, 1 out of this constant.
#    #    (Default 4, for 1/4 chance, it's probably too high)
#    # * Random number added to the minimum level this pokemon can evolve at or
#    #    the wild pokemon's current level if it evolves through item (Default 5)
#    # * Disable this modifier while the pokeradar is being used.
#    #    I recommend leaving it as is as the pokeradar may behave strangely and the
#    #    two scripts may reset each others' chain. (Default true)
#    # * The maps where this effect can only take place in.
#    # * The maps where this effect will never happen. Ever.
#    # * The switch to disable this effect. (Default -1)
#    #===============================================================================
EVOCHAINLENGTH      = 1
EVORANDCHANCE       = 2
EVOLEVELWOBBLE      = 5
EVOPKRADERDISABLE   = true
EVOMAPSWHITELIST    = []
EVOMAPSBLACKLIST    = []
EVODISABLESWITCH    = -1
SHINY_ANIMATION_ID = 5
DUST_ANIMATION_ID = 2
SPLASH_ANIMATION_ID = 6
#===============================================================================
#                              THE SCRIPT
#===============================================================================

          #########################################################
          #                                                       #
          #             1. PART: THE CATCHCOMBO                   #
          #                                                       #
          #########################################################
#===============================================================================
# adding a new instance variable to $PokemonTemp in script PField_Metadata to
# remember which pokemon and how many of that kind were killed in a row
#===============================================================================
class PokemonTemp
  attr_accessor :catchcombo # [chain length, species]
end

#===============================================================================
# adding a new event handler on Battle end to update the catchchain (where the
# pokemon-kill-chain is saved)
#===============================================================================
Events.onWildBattleEnd+=proc {|sender,e|
   species=e[0]
   result=e[2]
   $PokemonTemp.catchcombo = [0,0] if !$PokemonTemp.catchcombo
   if $PokemonTemp.catchcombo[1]!=species
     $PokemonTemp.catchcombo=[0,species]
   end
   if result==1 && species==$PokemonTemp.catchcombo[1]
     $PokemonTemp.catchcombo[0]+=1
     #Kernel.pbMessage(_INTL("You killed {1} {2}",$PokemonTemp.catchcombo[0],$PokemonTemp.catchcombo[1]))
   end
}


          #########################################################
          #                                                       #
          #      2. PART: SPAWNING THE OVERWORLD ENCOUNTER        #
          #                                                       #
          #########################################################
#===============================================================================
# We override the original method "pbOnStepTaken" in Script PField_Field it was 
# originally used for random encounter battles
#===============================================================================
def Kernel.pbOnStepTaken(eventTriggered) # look here
  #Should it be possible to search for pokemon nearby?
  if $game_player.move_route_forcing || pbMapInterpreterRunning? || !$Trainer
    Events.onStepTakenFieldMovement.trigger(nil,$game_player)
    return
  end
  $PokemonGlobal.stepcount = 0 if !$PokemonGlobal.stepcount
  $PokemonGlobal.stepcount += 1
  $PokemonGlobal.stepcount &= 0x7FFFFFFF
  repel = ($PokemonGlobal.repel>0)
  Events.onStepTaken.trigger(nil)
  handled = [nil]
  Events.onStepTakenTransferPossible.trigger(nil,handled)
  return if handled[0]
  if !eventTriggered
    #OVERWORLD ENCOUNTERS
    #we choose the tile on which the pokemon appears
    pos = pbChooseTileOnStepTaken
    return if !pos
    #we choose the random encounter
    encounter,gender,form,isShiny = pbChooseEncounter(pos[0],pos[1],repel)
    return if !encounter
    #we generate an random encounter overworld event
    pbPlaceEncounter(pos[0],pos[1],encounter,gender,form,isShiny)
  end
end
#===============================================================================
# new method pbChooseTileOnStepTaken to choose the tile on which the pkmn spawns 
#===============================================================================
def pbChooseTileOnStepTaken
  # Choose 1 random tile from 1 random ring around the player
  i = rand(2)
  r = rand((i+1)*8)
  x = $game_player.x
  y = $game_player.y
  if r<=(i+1)*2
    x = $game_player.x-i-1+r
    y = $game_player.y-i-1
  elsif r<=(i+1)*6-2
    x = [$game_player.x+i+1,$game_player.x-i-1][r%2]
    y = $game_player.y-i+((r-1-(i+1)*2)/2).floor
  else
    x = $game_player.x-i+r-(i+1)*6
    y = $game_player.y+i+1
  end
  #check if it is possible to encounter here
  return if x<0 || x>=$game_map.width || y<0 || y>=$game_map.height #check if the tile is on the map
  #check if it's a valid grass, water or cave etc. tile
  return if PBTerrain.isIce?($game_map.terrain_tag(x,y))
  return if PBTerrain.isLedge?($game_map.terrain_tag(x,y))
  return if PBTerrain.isWaterfall?($game_map.terrain_tag(x,y))
  return if PBTerrain.isRock?($game_map.terrain_tag(x,y))
  return if PBTerrain.isOWNoSpawn?($game_map.terrain_tag(x,y))
  return if PBTerrain.isSurfNoSpawn?($game_map.terrain_tag(x,y))
  if RESTRICTENCOUNTERSTOPLAYERMOVEMENT
    return if !PBTerrain.isWater?($game_map.terrain_tag(x,y)) && 
              $PokemonGlobal && $PokemonGlobal.surfing
    return if PBTerrain.isWater?($game_map.terrain_tag(x,y)) && 
              !($PokemonGlobal && $PokemonGlobal.surfing)
  end
  return [x,y]
end

#===============================================================================
# defining new method pbChooseEncounter to choose the pokemon on the tile (x,y)
#===============================================================================
def pbChooseEncounter(x,y,repel=false)
  return if $Trainer.ablePokemonCount==0   #check if trainer has pokemon
  encounterType = $PokemonEncounters.pbEncounterTypeOnTile(x,y)
  $PokemonTemp.encounterType = encounterType
  return if encounterType<0 #check if there are encounters
  return if !$PokemonEncounters.isEncounterPossibleHereOnTile?(x,y)
  for event in $game_map.events.values
    if event.x==x && event.y==y
      return
    end
  end
  encounter = $PokemonEncounters.pbGenerateEncounter(encounterType)
  encounter = EncounterModifier.trigger(encounter)
  if !$PokemonEncounters.pbCanEncounter?(encounter,repel)
    $PokemonTemp.forceSingleBattle = false
    EncounterModifier.triggerEncounterEnd()
    return
  end
  #----------------------------------------
  # added to include rescue chain, forms and gender by derFischae
  form = nil
  gender = nil
  pokemon = pbGenerateWildPokemon(encounter[0],encounter[1])
  Events.onWildPokemonCreateForSpawning.trigger(nil,pokemon)
  encounter = [pokemon.species,pokemon.level]
  if USEALTFORMS == true or USEFEMALESPRITES == true or USERESCUECHAIN == true  
    gender = pokemon.gender if USEFEMALESPRITES==true
    form = pokemon.form if USEALTFORMS == true  
    isShiny = pokemon.isShiny?
    if USERESCUECHAIN == true
      unless EVOMAPSBLACKLIST.include?($game_map.map_id) and
           EVOMAPSWHITELIST.length>0 && !EVOMAPSWHITELIST.include?($game_map.map_id) and
           EVODISABLESWITCH>0 && $game_switches[EVODISABLESWITCH] and
           EVOPKRADERDISABLE && !$PokemonTemp.pokeradar.nil? and
           !$PokemonGlobal.roamEncounter.nil?
        unless pokemon.nil?
          if !$PokemonTemp.rescuechain
            $PokemonTemp.rescuechain=[0,nil]
          end
          family =pbGetBabySpecies(pokemon.species)
          if family == $PokemonTemp.rescuechain[1]
            if $PokemonTemp.rescuechain[0]>=EVOCHAINLENGTH
              for i in 0..($PokemonTemp.rescuechain[0]/EVOCHAINLENGTH).floor()
                evodata=pbGetEvolvedFormData(pokemon.species)
                if evodata.length>0 && rand(EVORANDCHANCE)==0
                  fspecies=evodata[rand(evodata.length)][2]
                  newspecies,newform=pbGetSpeciesFromFSpecies(fspecies)
                  level=pbGetMinimumLevel(fspecies)
                  level=[level,pokemon.level].max
                  level+=rand(EVOLEVELWOBBLE)
                  encounter = [newspecies,level]
                end
              end
              pokemon = pbGenerateWildPokemon(encounter[0],encounter[1])
              Events.onWildPokemonCreateForSpawning.trigger(nil,pokemon)
              encounter = [pokemon.species,pokemon.level]
              gender = pokemon.gender if USEFEMALESPRITES==true
              form = pokemon.form if USEALTFORMS == true      
              isShiny = pokemon.isShiny?
            end
          end
        end
      end
    end
  end
  return encounter,gender,form,isShiny
end

#===============================================================================
# defining new method pbPlaceEncounter to add/place and visualise the pokemon
# "encounter" on the overworld-tile (x,y)
#===============================================================================
def pbPlaceEncounter(x,y,encounter,gender = nil,form = nil,isShiny = nil)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
  if !$MapFactory
    $game_map.spawnEvent(x,y,encounter,gender,form,isShiny)
  else
    mapId = $game_map.map_id
    spawnMap = $MapFactory.getMap(mapId)
    #Kernel.pbMessage(_INTL("{1}",spawnMap.map_id))
    spawnMap.spawnEvent(x,y,encounter,gender,form,isShiny)
  end
  # Show spawn animations
  if PBTerrain.isGrass?($game_map.terrain_tag(x,y))
  # Show grass rustling animations when on grass
    $scene.spriteset.addUserAnimation(RUSTLE_NORMAL_ANIMATION_ID,x,y,true,1)
  end
  if PBTerrain.isCaveTile?($game_map.terrain_tag(x,y))
  # Show cave dust animations when in cave
    $scene.spriteset.addUserAnimation(DUST_ANIMATION_ID,x,y,true,1)
  end 
  if PBTerrain.isWater?($game_map.terrain_tag(x,y))
  # Show water splashing animations when in water
    $scene.spriteset.addUserAnimation(SPLASH_ANIMATION_ID,x,y,true,1)
  end
  # Play the pokemon cry of encounter
  pbPlayCryOnOverworld(encounter[0])
  # For roaming encounters we have to do the following:
  if $PokemonTemp.nowRoaming == true && 
     $PokemonTemp.roamerIndex != nil &&
     $PokemonGlobal.roamEncounter != nil
    $PokemonGlobal.roamEncounter = nil
    $PokemonGlobal.roamedAlready = true
  end
  $PokemonTemp.forceSingleBattle = false
  EncounterModifier.triggerEncounterEnd()
end

#===============================================================================
# adding new Methods pbEncounterTypeOnTile and isEncounterPossibleHereOnTile?
# in Class PokemonEncounters in Script PField_Encounters
#===============================================================================
class PokemonEncounters
  def pbEncounterTypeOnTile(x,y)
    if PBTerrain.isJustWater?($game_map.terrain_tag(x,y))
      return EncounterTypes::Water
    elsif self.isCave?
      return EncounterTypes::Cave
    elsif PBTerrain.isOWSpawn?($game_map.terrain_tag(x,y))
      return EncounterTypes::Land
    elsif self.isGrass?
      time = pbGetTimeNow
      enctype = EncounterTypes::Land
      enctype = EncounterTypes::LandNight if self.hasEncounter?(EncounterTypes::LandNight) && PBDayNight.isNight?(time)
      enctype = EncounterTypes::LandDay if self.hasEncounter?(EncounterTypes::LandDay) && PBDayNight.isDay?(time)
      enctype = EncounterTypes::LandMorning if self.hasEncounter?(EncounterTypes::LandMorning) && PBDayNight.isMorning?(time)
      if pbInBugContest? && self.hasEncounter?(EncounterTypes::BugContest)
        enctype = EncounterTypes::BugContest
      end
      return enctype
    end
    return -1
  end
  
  def isEncounterPossibleHereOnTile?(x,y)
    if PBTerrain.isJustWater?($game_map.terrain_tag(x,y))
      return true
    elsif self.isCave?
      return true
    elsif PBTerrain.isOWSpawn?($game_map.terrain_tag(x,y))
      return true
    elsif self.isGrass?
      return PBTerrain.isGrass?($game_map.terrain_tag(x,y))
    end
    return false
  end
end

#===============================================================================
# new Method spawnEvent in Class Game_Map in Script Game_Map
#===============================================================================
class Game_Map
  def spawnEvent(x,y,encounter,gender = nil,form = nil, isShiny = nil)
    #------------------------------------------------------------------
    # generating a new event
    event = RPG::Event.new(x,y)
    # naming the event "vanishingEncounter" for PART 3 
    event.name = "vanishingEncounter"
    #setting the nessassary properties
    key_id = (@events.keys.max || -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
    #event.pages[0].graphic.tile_id = 0
    if encounter[0] < 10
      character_name = "00"+encounter[0].to_s
    elsif encounter[0] < 100
      character_name = "0"+encounter[0].to_s
    else
      character_name = encounter[0].to_s
    end
    # use sprite of female pokemon
    character_name = character_name+"f" if USEFEMALESPRITES == true and gender==1 and pbResolveBitmap("Graphics/Characters/"+character_name+"f")
    # use shiny-sprite if probability & killcombo is high or shiny-switch is on
    $PokemonTemp.catchcombo=[0,0] if !$PokemonTemp.catchcombo
    shinysprite = nil
    if isShiny==true
      character_name = character_name+"s" if USESHINYSPRITES == true and pbResolveBitmap("Graphics/Characters/"+character_name+"s")
      shinysprite = true
        $scene.spriteset.addUserAnimation(SHINY_ANIMATION_ID,event.x,event.y,true,2)
    elsif ($PokemonTemp.catchcombo[0]>=CHAINLENGTH && $PokemonTemp.catchcombo[1]==encounter[0])
      if rand(SHINYPROBABILITY)<$PokemonTemp.catchcombo[0]
        character_name = character_name+"s" if USESHINYSPRITES == true and pbResolveBitmap("Graphics/Characters/"+character_name+"s")
        shinysprite = true
      end
    end
    # use sprite of alternative form
    if USEALTFORMS==true and form!=nil and form!=0
      character_name = character_name+"_"+form.to_s if pbResolveBitmap("Graphics/Characters/"+character_name+"_"+form.to_s)
    end
    event.pages[0].graphic.character_name = character_name
    # we configure the movement of the overworld encounter
    if rand(100) < AGGRESSIVEENCOUNTERPROBABILITY
      event.pages[0].move_type = 3
      event.pages[0].move_speed = AGGRENCMOVESPEED
      event.pages[0].move_frequency = AGGRENCMOVEFREQ
      event.pages[0].move_route.list[0].code = 10
      event.pages[0].move_route.list[1] = RPG::MoveCommand.new
    else
      event.pages[0].move_type = 1
      event.pages[0].move_speed = ENCMOVESPEED
      event.pages[0].move_frequency = ENCMOVEFREQ
    end
    event.pages[0].step_anime = true if USESTOPANIMATION
    event.pages[0].trigger = 2
    #------------------------------------------------------------------
    # we add the event commands to the event of the overworld encounter
    if $PokemonGlobal.roamEncounter!=nil
      #[i,species,poke[1],poke[4]]
      parameter1 = $PokemonGlobal.roamEncounter[0].to_s
      parameter2 = $PokemonGlobal.roamEncounter[1].to_s
      parameter3 = $PokemonGlobal.roamEncounter[2].to_s
      $PokemonGlobal.roamEncounter[3] != nil ? (parameter4 = '"'+$PokemonGlobal.roamEncounter[3].to_s+'"') : (parameter4 = "nil")
      parameter = " $PokemonGlobal.roamEncounter = ["+parameter1+","+parameter2+","+parameter3+","+parameter4+"] "
    else
      parameter = " $PokemonGlobal.roamEncounter = nil "
    end
    pbPushScript(event.pages[0].list,sprintf(parameter))
    parameter = ($PokemonTemp.nowRoaming!=nil) ? " $PokemonTemp.nowRoaming = "+$PokemonTemp.nowRoaming.to_s : " $PokemonTemp.nowRoaming = nil "
    pbPushScript(event.pages[0].list,sprintf(parameter))
    parameter = ($PokemonTemp.roamerIndex!=nil) ? " $PokemonTemp.roamerIndex = "+$PokemonTemp.roamerIndex.to_s : " $PokemonTemp.roamerIndex = nil "
    pbPushScript(event.pages[0].list,sprintf(parameter))
    parameter = ($PokemonGlobal.nextBattleBGM!=nil) ? " $PokemonGlobal.nextBattleBGM = '"+$PokemonGlobal.nextBattleBGM.to_s+"'" : " $PokemonGlobal.nextBattleBGM = nil "
    pbPushScript(event.pages[0].list,sprintf(parameter))
    parameter = ($PokemonTemp.forceSingleBattle!=nil) ? " $PokemonTemp.forceSingleBattle = "+$PokemonTemp.forceSingleBattle.to_s : " $PokemonTemp.forceSingleBattle = nil "
    pbPushScript(event.pages[0].list,sprintf(parameter))
    parameter = ($PokemonTemp.encounterType!=nil) ? " $PokemonTemp.encounterType = "+$PokemonTemp.encounterType.to_s : " $PokemonTemp.encounterType = nil "
    pbPushScript(event.pages[0].list,sprintf(parameter))
    # setting shiny switch on if sprite is a shiny-sprite
    oldShinySwitchStatus=$game_switches[SHINY_WILD_POKEMON_SWITCH]
    parameter = (shinysprite == true) ? " $game_switches["+SHINY_WILD_POKEMON_SWITCH.to_s+"]=true" : " $game_switches["+SHINY_WILD_POKEMON_SWITCH.to_s+"]=false"
    pbPushScript(event.pages[0].list,sprintf(parameter))
    # setting $PokemonGlobal.battlingSpawnedPokemon = true
    pbPushScript(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = true"))    
    #pbSingleOrDoubleWildBattle(encounter[0],encounter[1])
    gender = "nil" if gender==nil
    form = "nil" if form==nil
    shinysprite = "nil" if shinysprite==nil
    pbPushScript(event.pages[0].list,sprintf(" pbSingleOrDoubleWildBattle("+encounter[0].to_s+","+encounter[1].to_s+", $game_map.events["+key_id.to_s+"].map.map_id, $game_map.events["+key_id.to_s+"].x, $game_map.events["+key_id.to_s+"].y,"+gender.to_s+","+form.to_s+","+shinysprite.to_s+")"))
    # setting $PokemonGlobal.battlingSpawnedPokemon = false
    pbPushScript(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = false"))        
    # setting shiny switch back to previous state
    pbPushScript(event.pages[0].list,sprintf(" $game_switches["+SHINY_WILD_POKEMON_SWITCH.to_s+"]="+oldShinySwitchStatus.to_s))
    pbPushScript(event.pages[0].list,sprintf("$PokemonTemp.encounterType = -1"))
    pbPushScript(event.pages[0].list,sprintf("$PokemonTemp.forceSingleBattle = false"))
    pbPushScript(event.pages[0].list,sprintf("EncounterModifier.triggerEncounterEnd()"))
    if !$MapFactory
      parameter = "$game_map.removeThisEventfromMap(#{key_id})"
    else
      mapId = $game_map.map_id
      parameter = "$MapFactory.getMap("+mapId.to_s+").removeThisEventfromMap(#{key_id})"
    end
    pbPushScript(event.pages[0].list,sprintf(parameter))
    pbPushEnd(event.pages[0].list)
    #------------------------------------------------------------------
    # creating and adding the Game_Event
    gameEvent = Game_Event.new(@map_id, event, self)
    key_id = (@events.keys.max || -1) + 1
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    @events[key_id] = gameEvent
    #-------------------------------------------------------------------------
    #updating the sprites
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
  end
end

#===============================================================================
# adding new Method pbSingleOrDoubleWildBattle to reduce the code in spawnEvent
#===============================================================================
def pbSingleOrDoubleWildBattle(species,level,map_id,x,y,gender = nil,form = nil,shinysprite = nil)
  if $MapFactory
    terrainTag = $MapFactory.getTerrainTag(map_id,x,y)
  else
    terrainTag = $game_map.terrain_tag(x,y)
  end
  if !$PokemonTemp.forceSingleBattle && ($PokemonGlobal.partner ||
      ($Trainer.ablePokemonCount>1 &&
      PBTerrain.isDoubleWildBattle?(terrainTag) &&
      rand(100)<30))
    encounter2 = $PokemonEncounters.pbEncounteredPokemon($PokemonTemp.encounterType)
    encounter2 = EncounterModifier.trigger(encounter2)
    pbDoubleWildBattle(species,level,encounter2[0],encounter2[1],nil,true,false,gender,form,shinysprite,nil,nil,nil)
  else
    pbWildBattle(species,level,nil,true,false,gender,form,shinysprite)
  end
end

#===============================================================================
# overriding Method pbWildBattle in Script PField_Battles
# to include alternate forms of the wild pokemon
#===============================================================================
def pbWildBattle(species,level,variable=nil,canescape=true,canlose=false,gender = nil,form = nil,shinysprite = nil)
  if (Input.press?(Input::CTRL) && $DEBUG) || $Trainer.pokemonCount==0
    if $Trainer.pokemonCount>0
      Kernel.pbMessage(_INTL("SKIPPING BATTLE..."))
    end
    pbSet(variable,1)
    $PokemonGlobal.nextBattleBGM  = nil
    $PokemonGlobal.nextBattleME   = nil
    $PokemonGlobal.nextBattleBack = nil
    return true
  end
  if species.is_a?(String) || species.is_a?(Symbol)
    species = getID(PBSpecies,species)
  end
  handled = [nil]
  Events.onWildBattleOverride.trigger(nil,species,level,handled)
  return handled[0] if handled[0]!=nil
  currentlevels = []
  for i in $Trainer.party
    currentlevels.push(i.level)
  end
  genwildpoke = pbGenerateWildPokemon(species,level)
  #-----------------------------------------------------------------------------
  #added by derFischae to set the form
  genwildpoke.setGender(gender) if USEFEMALESPRITES==true and gender!=nil and gender>=0 and gender<3
  genwildpoke.form = form if USEALTFORMS==true and form!=nil and form>0
  genwildpoke.shinyflag = shinysprite if shinysprite!=nil
  # well actually it is not okay to test if form>0, we should also test if form 
  # is smaller than the maximal form, but for now I keep it that way. 
  #-----------------------------------------------------------------------------
  Events.onStartBattle.trigger(nil,genwildpoke)
  scene = pbNewBattleScene
  battle = PokeBattle_Battle.new(scene,$Trainer.party,[genwildpoke],$Trainer,nil)
  battle.internalbattle = true
  battle.cantescape     = !canescape
  pbPrepareBattle(battle)
  decision = 0
  pbBattleAnimation(pbGetWildBattleBGM(species),0,[genwildpoke]) {
    pbSceneStandby {
      decision = battle.pbStartBattle(canlose)
    }
    pbAfterBattle(decision,canlose)
  }
  Input.update
  pbSet(variable,decision)
  Events.onWildBattleEnd.trigger(nil,species,level,decision)
  return (decision!=2)
end


#===============================================================================
# overriding Method pbDoubleWildBattle in Script PField_Battles
# to include alternate forms of the wild pokemon in double battles
#===============================================================================
def pbDoubleWildBattle(species1,level1,species2,level2,variable=nil,canescape=true,canlose=false,gender1 = nil,form1 = nil,shinysprite1 = nil,gender2 = nil,form2 = nil,shinysprite2 = nil)
  if (Input.press?(Input::CTRL) && $DEBUG) || $Trainer.pokemonCount==0
    if $Trainer.pokemonCount>0
      Kernel.pbMessage(_INTL("SKIPPING BATTLE..."))
    end
    pbSet(variable,1)
    $PokemonGlobal.nextBattleBGM  = nil
    $PokemonGlobal.nextBattleME   = nil
    $PokemonGlobal.nextBattleBack = nil
    return true
  end
  if species1.is_a?(String) || species1.is_a?(Symbol)
    species1 = getID(PBSpecies,species1)
  end
  if species2.is_a?(String) || species2.is_a?(Symbol)
    species2 = getID(PBSpecies,species2)
  end
  currentlevels = []
  for i in $Trainer.party
    currentlevels.push(i.level)
  end
  genwildpoke  = pbGenerateWildPokemon(species1,level1)
  genwildpoke2 = pbGenerateWildPokemon(species2,level2)
  #-----------------------------------------------------------------------------
  #added by derFischae to set the form
  # well actually it is not okay to test if form>0, we should also test if form 
  # is smaller than the maximal form, but for now I keep it that way. 
  genwildpoke.setGender(gender1) if USEFEMALESPRITES==true and gender1!=nil and gender1>=0 and gender1<3
  if USEALTFORMS==true and form1!=nil and form1>0
    genwildpoke.form = form1   
    genwildpoke.shinyflag = shinysprite1 if shinysprite1!=nil
    genwildpoke.resetMoves
  end
  genwildpoke2.setGender(gender) if USEFEMALESPRITES==true and gender2!=nil and gender2>=0 and gender2<3
  if USEALTFORMS==true and form2!=nil and form2>0
    genwildpoke2.form = form2 if USEALTFORMS==true and form2!=nil and form2>0  
    genwildpoke2.shinyflag = shinysprite2 if shinysprite2!=nil
    genwildpoke2.resetMoves
  end
  #-----------------------------------------------------------------------------
  Events.onStartBattle.trigger(nil,genwildpoke)
  scene = pbNewBattleScene
  if $PokemonGlobal.partner
    othertrainer = PokeBattle_Trainer.new($PokemonGlobal.partner[1],$PokemonGlobal.partner[0])
    othertrainer.id    = $PokemonGlobal.partner[2]
    othertrainer.party = $PokemonGlobal.partner[3]
    combinedParty = []
    for i in 0...$Trainer.party.length
      combinedParty[i] = $Trainer.party[i]
    end
    for i in 0...othertrainer.party.length
      combinedParty[6+i] = othertrainer.party[i]
    end
    battle = PokeBattle_Battle.new(scene,combinedParty,[genwildpoke,genwildpoke2],[$Trainer,othertrainer],nil)
    battle.fullparty1 = true
  else
    battle = PokeBattle_Battle.new(scene,$Trainer.party,[genwildpoke,genwildpoke2],$Trainer,nil)
    battle.fullparty1 = false
  end
  battle.internalbattle = true
  battle.doublebattle   = battle.pbDoubleBattleAllowed?()
  battle.cantescape     = !canescape
  pbPrepareBattle(battle)
  decision = 0
  pbBattleAnimation(pbGetWildBattleBGM(species1),2,[genwildpoke,genwildpoke2]) { 
    pbSceneStandby {
      decision = battle.pbStartBattle(canlose)
    }
    pbAfterBattle(decision,canlose)
  }
  Input.update
  pbSet(variable,decision)
  return (decision!=2 && decision!=5)
end

#===============================================================================
# adding new method PBTerrain.isRock? to module PBTerrain in script PBTerrain
# to check if the terrainTag "tag" is rock
#===============================================================================
module PBTerrain
  def PBTerrain.isRock?(tag)
    return tag==PBTerrain::Rock
  end
end

#===============================================================================
# adding new method pbPlayCryOnOverworld to load/play Pokémon cry files 
# SPECIAL THANKS TO "Ambient Pokémon Cries" - by Vendily
# actually it's not used, but that code helped to include the pkmn cries faster
#===============================================================================
def pbPlayCryOnOverworld(pokemon,volume=90,pitch=nil)
  return if !pokemon
  if pokemon.is_a?(Numeric)
    pbPlayCrySpecies(pokemon,0,volume,pitch)
  elsif !pokemon.egg?
    if pokemon.respond_to?("chatter") && pokemon.chatter
      pokemon.chatter.play
    else
      pkmnwav = pbCryFile(pokemon)
      if pkmnwav
        pbBGSPlay(RPG::AudioFile.new(pkmnwav,volume,
           (pitch) ? pitch : (pokemon.hp*25/pokemon.totalhp)+75)) rescue nil
      end
    end
  end
end

#===============================================================================
# adding a new method attr_reader to the Class Spriteset_Map in Script
# Spriteset_Map to get access to the variable @character_sprites of a
# Spriteset_Map
#===============================================================================
class Spriteset_Map
  attr_reader :character_sprites
end

#===============================================================================
# adding a new method attr_reader to the Class Scene_Map in Script
# Scene_Map to get access to the Spriteset_Maps listed in the variable 
# @spritesets of a Scene_Map
#===============================================================================
class Scene_Map
  attr_reader :spritesets
end

          #########################################################
          #                                                       #
          #      3. PART: VANISHING OF OVERWORLD ENCOUNTER        #
          #                                                       #
          #########################################################
#===============================================================================
# adding a new variable stepCount and replacing the method increase_steps
# in class Game_Event in script Game_Event to count the steps of
# overworld encounter and to make them disappear after taking more then
# STEPSBEFOREVANISHING steps
#===============================================================================
class Game_Event < Game_Character
  attr_accessor :event
  attr_accessor :stepCount #counts the steps of an overworld encounter
  
  alias original_increase_steps increase_steps
  def increase_steps
    if self.name=="vanishingEncounter" && @stepCount && @stepCount>=STEPSBEFOREVANISHING
      removeThisEventfromMap
    else
      @stepCount=0 if (!@stepCount || @stepCount<0)
      @stepCount+=1
      #original_increase_steps # edit here
    end
  end
  
  def removeThisEventfromMap
    if $game_map.events.has_key?(@id) and $game_map.events[@id]==self
      #-------------------------------------------------------------------------
      # added to reduce lag by derFischae
      for sprite in $scene.spritesets[$game_map.map_id].character_sprites
        if sprite.character==self
          $scene.spritesets[$game_map.map_id].character_sprites.delete(sprite)
          sprite.dispose
          break
        end
      end
      #-------------------------------------------------------------------------
      $game_map.events.delete(@id)        
    else
      if $MapFactory
        for map in $MapFactory.maps
          if map.events.has_key?(@id) and map.events[@id]==self
            #-------------------------------------------------------------------------
            # added to reduce lag by derFischae
            for sprite in $scene.spritesets[self.map_id].character_sprites
              if sprite.character==self
                $scene.spritesets[map.map_id].character_sprites.delete(sprite)
                sprite.dispose
                break
              end
            end
            #-------------------------------------------------------------------------
            map.events.delete(@id)
            break
          end
        end
      else
        Kernel.pbMessage("Actually, this should not be possible")
      end
    end
    #-------------------------------------------------------------------------
    # added some code above to reduce lag by derFischae
    # Original Code was
    #$scene.disposeSpritesets
    #$scene.createSpritesets
    #-------------------------------------------------------------------------
  end
end

class Game_Map
  def removeThisEventfromMap(id)
    if @events.has_key?(id)
      #-------------------------------------------------------------------------
      # added to reduce lag by derFischae
      for sprite in $scene.spritesets[@map_id].character_sprites
        if sprite.character == @events[id]
          $scene.spritesets[@map_id].character_sprites.delete(sprite)
          sprite.dispose
          break
        end
      end
      #-------------------------------------------------------------------------
      @events.delete(id)        
    end
    #-------------------------------------------------------------------------
    # added some code above to reduce lag by derFischae
    # Original Code was
    #$scene.disposeSpritesets
    #$scene.createSpritesets
    #-------------------------------------------------------------------------
  end  
end

#===============================================================================
# for automatic spawning without making a step
#===============================================================================

class Game_Map
  
  alias original_update update
  def update
    #--------------------------------
    # for testing auto spawning
    $framecounter = 0 if !$framecounter 
    $framecounter = $framecounter + 1
    if $framecounter == AUTOSPAWNSPEED
      $framecounter = 0
      Kernel.pbOnStepTaken(nil)
    end
    #--------------------------------
    original_update
  end
end

#===============================================================================
# For The Rescue Chain - By Vendily [v17]
# edited to obtain compatibility for visible overworld encounter by derFischae
#===============================================================================

class PokemonTemp
  attr_accessor :rescuechain # [chain length, evo family]
end

Events.onWildBattleEnd+=proc {|sender,e|
   next if EVOMAPSBLACKLIST.include?($game_map.map_id)
   next if EVOMAPSWHITELIST.length>0 && !EVOMAPSWHITELIST.include?($game_map.map_id)
   next if EVODISABLESWITCH>0 && $game_switches[EVODISABLESWITCH]
   next if EVOPKRADERDISABLE && !$PokemonTemp.pokeradar.nil?
   $PokemonTemp.rescuechain = [0,nil] if !$PokemonTemp.rescuechain
   species=e[0]
   result=e[2]
   family=pbGetBabySpecies(species)
   if $PokemonTemp.rescuechain[1]!=family
     $PokemonTemp.rescuechain=[0,family]
   end
   if (result==1 || result == 4) && family==$PokemonTemp.rescuechain[1]
     $PokemonTemp.rescuechain[0]+=1
   end 
}

#===============================================================================
# Adding Event OnWildPokemonCreateForSpawning to Module Events in Script PField_Field.
# This Event is triggered  when a new pokemon spawns. Use this Event instead of OnWildPokemonCreate
# if you want to add a new procedure that modifies a pokemon on spawning 
# but not on creation while going into battle with an already spawned pokemon.
#Note that OnPokemonCreate is also triggered when a pokemon is created for spawning,
#But OnPokemonCreateForSpawning is not triggered when a pokemon is created in other situations than for spawning
#===============================================================================
module Events
  @@OnWildPokemonCreateForSpawning          = Event.new

  # Triggers whenever a wild Pokémon is created for spawning
  # Parameters: 
  # e[0] - Pokémon being created for spawning
  def self.onWildPokemonCreateForSpawning; @@OnWildPokemonCreateForSpawning; end
  def self.onWildPokemonCreateForSpawning=(v); @@OnWildPokemonCreateForSpawning = v; end

end

#===============================================================================
# adds new parameter battlingSpawnedPokemon to the class PokemonGlobalMetadata
# defined in script section PField_Metadata. Also overrides initialize include that parameter there.
#===============================================================================

class PokemonGlobalMetadata
  attr_accessor :battlingSpawnedPokemon

  alias original_initialize initialize
  def initialize
    battlingSpawnedPokemon = false
    original_initialize
  end
end