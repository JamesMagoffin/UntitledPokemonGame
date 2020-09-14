#===============================================================================
#                      BW2 Pokedex Entry Script
#                  by LackDeJurane or CharizardThree3
#                        for Essentials v17+ 
#                  Credits to Kleinstudio and Luka S.J
#===============================================================================
# SWITCHES 
#===============================================================================
USEEBS = true #Set this to true if you use EBS
POKEMONSPRITESCALE = 2 #Delete this if you have EBS or set this to 2
USEBW2SCENE = true # Set this to true if you want the BW2 Style not the original BW
USEMOUSE = true #Set this to false if you dont have Luka's Easy Mouse System and don't 
                #want to use the mouse


def pbFindEncounter(encounter,species)
  return false if !encounter
  for i in 0...encounter.length
    next if !encounter[i]
    for j in 0...encounter[i].length
      return true if encounter[i][j][0]==species
    end
  end
  return false
end

#===============================================================================
# Animated Bitmap Methods, you can delete this class if you have Luka's Animated 
# bitmap Script or Use EBS
#===============================================================================
class AnimatedBitmapWrapper
  attr_reader :width
  attr_reader :height
  attr_reader :totalFrames
  attr_reader :animationFrames
  attr_reader :currentIndex
  attr_accessor :scale
  
  @@disableBitmapAnimation = false
  
  def initialize(file,scale=2)
    raise "filename is nil" if file==nil
    raise ".gif files are not supported!" if File.extname(file)==".gif"
    
    @scale = scale
    @width = 0
    @height = 0
    @frame = 0
    @frames = 2
    @direction = +1
    @animationFinish = false
    @totalFrames = 0
    @currentIndex = 0
    @speed = 1
      # 0 - not moving at all
      # 1 - normal speed
      # 2 - medium speed
      # 3 - slow speed
    bmp = BitmapCache.load_bitmap(file)
    @bitmapFile=Bitmap.new(bmp.width,bmp.height); @bitmapFile.blt(0,0,bmp,Rect.new(0,0,bmp.width,bmp.height))
  bmp.dispose
    # initializes full Pokemon bitmap
    @bitmap=Bitmap.new(@bitmapFile.width,@bitmapFile.height)
    @bitmap.blt(0,0,@bitmapFile,Rect.new(0,0,@bitmapFile.width,@bitmapFile.height))
    @width=@bitmapFile.height*@scale
    @height=@bitmap.height*@scale
    
    @totalFrames=@bitmap.width/@bitmap.height
    @animationFrames=@totalFrames*@frames
    # calculates total number of frames
    @loop_points=[0,@totalFrames]
    # first value is start, second is end
    
    @actualBitmap=Bitmap.new(@width,@height)
    @actualBitmap.clear
    @actualBitmap.stretch_blt(Rect.new(0,0,@width,@height),@bitmap,Rect.new(@currentIndex*(@width/@scale),0,@width/@scale,@height/@scale))
  end
  alias initialize_elite initialize unless self.method_defined?(:initialize_elite)
    
  def length; @totalFrames; end
  def disposed?; @actualBitmap.disposed?; end
  def dispose
    @bitmap.dispose
  @bitmapFile.dispose
    @actualBitmap.dispose
  end
  def copy; @actualBitmap.clone; end
  def bitmap; @actualBitmap; end
  def bitmap=(val); @actualBitmap=val; end
  def each; end
  def alterBitmap(index); return @strip[index]; end
    
  def prepareStrip
    @strip=[]
    for i in 0...@totalFrames
      bitmap=Bitmap.new(@width,@height)
      bitmap.stretch_blt(Rect.new(0,0,@width,@height),@bitmapFile,Rect.new((@width/@scale)*i,0,@width/@scale,@height/@scale))
      @strip.push(bitmap)
    end
  end
  def compileStrip
    @bitmap.clear
    for i in 0...@strip.length
      @bitmap.stretch_blt(Rect.new((@width/@scale)*i,0,@width/@scale,@height/@scale),@strip[i],Rect.new(0,0,@width,@height))
    end
  end
  
  def reverse
    if @direction  >  0
      @direction=-1
    elsif @direction < 0
      @direction=+1
    end
  end
  
  def setLoop(start, finish)
    @loop_points=[start,finish]
  end
  
  def setSpeed(value)
    @speed=value
  end
  
  def toFrame(frame)
    if frame.is_a?(String)
      if frame=="last"
        frame=@totalFrames-1
      else
        frame=0
      end
    end
    frame=@totalFrames if frame > @totalFrames
    frame=0 if frame < 0
    @currentIndex=frame
    @actualBitmap.clear
    @actualBitmap.stretch_blt(Rect.new(0,0,@width,@height),@bitmap,Rect.new(@currentIndex*(@width/@scale),0,@width/@scale,@height/@scale))
  end
  
  def play
    return if @currentIndex >= @loop_points[1]-1
    self.update
  end
  
  def finished?
    return (@currentIndex==@totalFrames-1)
  end
  
  def update
  return false if @@disableBitmapAnimation
    return false if @actualBitmap.disposed?
    return false if @speed < 1
    case @speed
    # frame skip
    when 1
      @frames=2
    when 2
      @frames=4
    when 3
      @frames=5
    end
    @frame+=1
    if @frame >= @frames
      # processes animation speed
      @currentIndex+=@direction
      @currentIndex=@loop_points[0] if @currentIndex >=@loop_points[1]
      @currentIndex=@loop_points[1]-1 if @currentIndex < @loop_points[0]
      @frame=0
    end
    @actualBitmap.clear
    @actualBitmap.stretch_blt(Rect.new(0,0,@width,@height),@bitmap,Rect.new(@currentIndex*(@width/@scale),0,@width/@scale,@height/@scale))
    # updates the actual bitmap
  end
  alias update_elite update unless self.method_defined?(:update_elite)
    
  # returns bitmap to original state
  def deanimate
    @frame=0
    @currentIndex=0
    @actualBitmap.clear
    @actualBitmap.stretch_blt(Rect.new(0,0,@width,@height),@bitmap,Rect.new(@currentIndex*(@width/@scale),0,@width/@scale,@height/@scale))
  end
end

class GifSprite
 # Creates a sprite from a GIF file with the specified
 # optional viewport.  Can also load non-animated bitmaps.
 # 'File' can be nil.
 def initialize(file=nil,viewport=nil)
  @file=file
  @sprite=SpriteWrapper.new(viewport)
  if file
   @bitmap=AnimatedBitmap.new(file)
   @sprite.bitmap=@bitmap.bitmap
  end
 end
 def [](index); @bitmap[index]; end
 def length; @bitmap.length; end
 def each; @bitmap.each { yield }; end
 def currentIndex; @bitmap.currentIndex; end
 def frameDelay; @bitmap.frameDelay; end
 def totalFrames; @bitmap.totalFrames; end
 def width; @bitmap.bitmap.width; end
 def height; @bitmap.bitmap.height; end
 def length; @bitmap.length; end
 def ox; @bitmap.ox; end
 def oy; @bitmap.oy; end
 def clearBitmaps
  @bitmap.dispose if @bitmap
  @bitmap=nil
  self.bitmap=nil if !self.disposed?
 end
 # Sets the icon's filename.
 def setBitmap(file,hue=0)
  oldrc=self.src_rect
  clearBitmaps()
  @name=file
  return if file==nil
  if file!=""
   @bitmap=AnimatedBitmap.new(file,hue)
   # for compatibility
   self.bitmap=@bitmap ? @bitmap.bitmap : nil
   self.src_rect=oldrc
   @sprite.bitmap=@bitmap.bitmap
  else
   @bitmap=nil
 end
 end
 def setBitmap(file)
  @bitmap.dispose if @bitmap
  @bitmap=AnimatedBitmap.new(file)   
  @sprite.bitmap=@bitmap.bitmap
 end
 def bitmap
  @sprite.bitmap
 end
 def getData
    data = "rgba" * width * height
    RtlMoveMemory_pi.call(data, self.address, data.length)
    return data
  end
 def bitmap=(value)
  @sprite.bitmap=value
 end
 def disposed?
  @sprite.disposed?
 end
 def width
  @sprite.bitmap.width
 end
 def height
  @sprite.bitmap.height
 end
 # This function must be called in order to animate
 # the GIF image.
 def update
 if @bitmap
  @bitmap.update
  @sprite.update
   if self.bitmap!=@bitmap.bitmap
   oldrc=self.src_rect
    self.bitmap=@bitmap.bitmap
   self.src_rect=oldrc
   end
 end
 end
 def update
  @bitmap.update
  @sprite.update
  if @sprite.bitmap!=@bitmap.bitmap
   oldsrc=@sprite.src_rect ? @sprite.src_rect.clone : nil
   @sprite.bitmap=@bitmap.bitmap
   @sprite.src_rect=oldsrc if oldsrc
  end
 end
 def dispose
  @bitmap.dispose
  @sprite.dispose
 end
 def flash(*arg); sprite.flash(*arg); end
 %w[
   x y z ox oy visible zoom_x zoom_y
   angle mirror bush_depth opacity blend_type 
   color tone src_rect viewport width height
 ].each do |s|
  eval <<-__END__
   def #{s}; @sprite.#{s}; end
   def #{s}=(value); @sprite.#{s}=value; end
  __END__
 end
end

def pbBitmap(name)
  return BitmapCache.load_bitmap(name)
end

def pbLoadHashPokemonBitmap(species,boy=false,shiny=false,form=0,back=false) 
  bitmapFileName=pbCheckPokemonBitmapFiles([species,back,
                                              boy,
                                              shiny,
                                              form,
                                              false])    
  animatedBitmap=AnimatedBitmapWrapper.new(bitmapFileName,
  back ? POKEMONSPRITESCALE/2 : POKEMONSPRITESCALE) 
  return animatedBitmap
end

#===============================================================================
# Credit to KleinStudio for this class
#===============================================================================
class PokemonSpriteDex
  attr_accessor :sprite

  def initialize(viewport)  
    @viewport=viewport
    @loaded=false
    @sprite=Sprite.new(@viewport)
    @lock=false
  end
  
  def x; @sprite.x; end
  def y; @sprite.y; end
  def z; @sprite.z; end
  def ox; @sprite.ox; end
  def oy; @sprite.oy; end
  def ox=(val);;end
  def oy=(val);;end
  def zoom_x; @sprite.zoom_x; end
  def zoom_y; @sprite.zoom_y; end
  def visible; @sprite.visible; end
  def opacity; @sprite.opacity; end
  def width; @bitmap.width; end
  def height; @bitmap.height; end
  def tone; @sprite.tone; end
  def bitmap; @bitmap.bitmap; end
  def actualBitmap; @bitmap; end
  def disposed?; @sprite.disposed?; end
  def color; @sprite.color; end
  def src_rect; @sprite.src_rect; end
  def blend_type; @sprite.blend_type; end
  def angle; @sprite.angle; end
  def mirror; @sprite.mirror; end
  def lock
    @lock=true
  end
  def unlock
    @lock=false
  end
  def bitmap=(val)
    @bitmap.bitmap=val
  end
  def x=(val)
    @sprite.x=val
  end
  def ox=(val)
    @sprite.ox=val
  end
  def oy=(val)
    @sprite.oy=val
  end
  def y=(val)
    @sprite.y=val
  end
  def z=(val)
    @sprite.z=val
  end
  def visible=(val)
    @sprite.visible=val
  end
  def opacity=(val)
    @sprite.opacity=val
  end
  def tone=(val)
    @sprite.tone=val
  end
  def color=(val)
    @sprite.color=val
  end
  def blend_type=(val)
    @sprite.blend_type=val
  end
  def angle=(val)
    @sprite.angle=(val)
  end
  def mirror=(val)
    @sprite.mirror=(val)
  end
  def dispose
    @sprite.dispose
  end
  
  def unloadPokemonBitmap
    @bitmap.dispose if @bitmap
    @sprite.bitmap.clear if @sprite.bitmap
  end
  
  def loadPokemonBitmap(species,boy=false,shiny=false,form=0,back=false)
    @bitmap.dispose if @bitmap
    @bitmap=pbLoadHashPokemonBitmap(species,boy,shiny,form,back) 
    @sprite.bitmap=@bitmap.bitmap.clone
    @loaded=true
  end
  
  def update
    return if @lock
    if @bitmap && Graphics.frame_count % 4 == 0
      @bitmap.update
      @sprite.bitmap=@bitmap.bitmap.clone
    end
  end  
end
#===============================================================================
# Luka S.J's Scrolling sprite class. You can delete it if you use EBS
#===============================================================================
class ScrollingSprite < Sprite
  attr_accessor :speed
  attr_accessor :direction
  attr_accessor :vertical
  
  def setBitmap(val,vertical=false,pulse=false)
    @vertical = vertical
    @pulse = pulse
    @direction = 1 if @direction.nil?
    @gopac = 1
    @speed = 32 if @speed.nil?
    val = pbBitmap(val) if val.is_a?(String)
    if @vertical
      bmp = Bitmap.new(val.width,val.height*2)
      for i in 0...2
        bmp.blt(0,val.height*i,val,Rect.new(0,0,val.width,val.height))
      end
      self.bitmap = bmp.clone
      y = @direction > 0 ? 0 : val.height
      self.src_rect.set(0,y,val.width,val.height)
    else
      bmp = Bitmap.new(val.width*2,val.height)
      for i in 0...2
        bmp.blt(val.width*i,0,val,Rect.new(0,0,val.width,val.height))
      end
      self.bitmap = bmp.clone
      x = @direction > 0 ? 0 : val.width
      self.src_rect.set(x,0,val.width,val.height)
    end
  end
  
  def update
    if @vertical
      self.src_rect.y += @speed*@direction
      self.src_rect.y = 0 if @direction > 0 && self.src_rect.y >= self.src_rect.height
      self.src_rect.y = self.src_rect.height if @direction < 0 && self.src_rect.y <= 0
    else
      self.src_rect.x += @speed*@direction
      self.src_rect.x = 0 if @direction > 0 && self.src_rect.x >= self.src_rect.width
      self.src_rect.x = self.src_rect.width if @direction < 0 && self.src_rect.x <= 0
    end
    if @pulse
      self.opacity -= @gopac*@speed
      @gopac *= -1 if self.opacity == 255 || self.opacity == 0
    end
  end
    
end
#===============================================================================
#Everything related to graphics start here
#===============================================================================
class PokemonPokedexInfo_Scene
  def pbStartScene(dexlist,index,region)
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @dexlist = dexlist
    @index   = index
    @region  = region
    @page = 1
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Pokedex/icon_typesbw"))
    @sprites = {}
    if USEBW2SCENE
    @sprites["dexentry2"] = ScrollingSprite.new(@viewport)
    @sprites["dexentry2"].setBitmap("Graphics/Pictures/Pokedex/dexbg2_grid2")
    @sprites["dexentry2"].speed = 1
    @sprites["dexentry2"].visible=false   
  else
    @sprites["dexentry2"] = ScrollingSprite.new(@viewport)
    @sprites["dexentry2"].setBitmap("Graphics/Pictures/Pokedex/dexbg2_grid2BW")
    @sprites["dexentry2"].speed = 1
    @sprites["dexentry2"].visible=false   
  end
    
    if USEBW2SCENE
    @sprites["entrybars"]=IconSprite.new(0,0,@viewport)
    @sprites["entrybars"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexentrybars"))
    @sprites["entrybars"].src_rect.set(0, 0, 512, 48) 
    @sprites["entrybars"].visible=false
  else
    @sprites["entrybars"]=IconSprite.new(0,0,@viewport)
    @sprites["entrybars"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexentrybarsBW"))
    @sprites["entrybars"].src_rect.set(0, 0, 512, 48) 
    @sprites["entrybars"].visible=false  
  end
  
  if USEBW2SCENE    
    @sprites["entrybars2"]=IconSprite.new(0,0,@viewport)
    @sprites["entrybars2"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexentrybars"))
    @sprites["entrybars2"].src_rect.set(0, 48, 512, 48) 
    @sprites["entrybars2"].z=1
    @sprites["entrybars2"].visible=false
  else
    @sprites["entrybars2"]=IconSprite.new(0,0,@viewport)
    @sprites["entrybars2"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexentrybarsBW"))
    @sprites["entrybars2"].src_rect.set(0, 48, 512, 48) 
    @sprites["entrybars2"].z=1
    @sprites["entrybars2"].visible=false
  end
    if USEBW2SCENE    
    @sprites["entrybars3"]=IconSprite.new(0,0,@viewport)
    @sprites["entrybars3"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexentrybars"))
    @sprites["entrybars3"].src_rect.set(0, 144, 512, 48) 
    @sprites["entrybars3"].z=1
    @sprites["entrybars3"].visible=false
  else
    @sprites["entrybars3"]=IconSprite.new(0,0,@viewport)
    @sprites["entrybars3"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexentrybarsBW"))
    @sprites["entrybars3"].src_rect.set(0, 144, 512, 48) 
    @sprites["entrybars3"].z=1
    @sprites["entrybars3"].visible=false
  end
    if USEBW2SCENE    
    @sprites["backgroundM"] = ScrollingSprite.new(@viewport)
    @sprites["backgroundM"].setBitmap("Graphics/Pictures/Pokedex/dexbg3")
    @sprites["backgroundM"].speed = 1
    @sprites["backgroundM"].visible=false
  else
    @sprites["backgroundM"] = ScrollingSprite.new(@viewport)
    @sprites["backgroundM"].setBitmap("Graphics/Pictures/Pokedex/dexbg3BW")
    @sprites["backgroundM"].speed = 1
    @sprites["backgroundM"].visible=false
  end
  if USEBW2SCENE    
    @sprites["grid4"] = ScrollingSprite.new(@viewport)
    @sprites["grid4"].setBitmap("Graphics/Pictures/Pokedex/dexbg4_grid")  
    @sprites["grid4"].speed = 1
    @sprites["grid4"].z=1
    @sprites["grid4"].visible=false
  else
    @sprites["grid4"] = ScrollingSprite.new(@viewport)
    @sprites["grid4"].setBitmap("Graphics/Pictures/Pokedex/dexbg4_gridBW")  
    @sprites["grid4"].speed = 1
    @sprites["grid4"].z=1
    @sprites["grid4"].visible=false
  end
    
    @sprites["background4"]= ScrollingSprite.new(@viewport)
    @sprites["background4"].setBitmap("Graphics/Pictures/Pokedex/dexbg4")
    @sprites["background4"].speed = 1
    @sprites["background4"].visible=false
  if USEBW2SCENE      
    @sprites["bginfo"]=Sprite.new(@viewport)
    @sprites["bginfo"].bitmap=RPG::Cache.picture("Pokedex/dexbg4info")
    @sprites["bginfo"].opacity=255
    @sprites["bginfo"].visible=false
  else
    @sprites["bginfo"]=Sprite.new(@viewport)
    @sprites["bginfo"].bitmap=RPG::Cache.picture("Pokedex/dexbg4infoBW")
    @sprites["bginfo"].opacity=255
    @sprites["bginfo"].visible=false    
  end
    
    @sprites["normalbar"]=IconSprite.new(0,Graphics.height-48,@viewport)
    @sprites["normalbar"].setBitmap("Graphics/Pictures/Pokedex/normalbar")
    @sprites["normalbar"].visible=false
    @sprites["normalbar"].z=1
    
    @sprites["return"]=IconSprite.new(474,346,@viewport)
    @sprites["return"].setBitmap("Graphics/Pictures/Universal/return")
    
    @sprites["info"]=IconSprite.new(96,340,@viewport)
    @sprites["info"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/info")
    @sprites["area"]=IconSprite.new(160,340,@viewport)
    @sprites["area"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/area")
    @sprites["forms"]=IconSprite.new(224,340,@viewport)
    @sprites["forms"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/forms") 
    @sprites["updown"]=IconSprite.new(10,342,@viewport)
    @sprites["updown"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/updown")  
 if USEBW2SCENE
    @sprites["leftarrow"]=IconSprite.new(246,21,@viewport)
    @sprites["leftarrow"].setBitmap("Graphics/Pictures/Pokedex/arrow_left")    
    @sprites["leftarrow"].visible=false
    @sprites["rightarrow"]=IconSprite.new(478,21,@viewport)
    @sprites["rightarrow"].setBitmap("Graphics/Pictures/Pokedex/arrow_right")    
    @sprites["rightarrow"].visible=false
    @sprites["leftarrow0"]=IconSprite.new(246,21,@viewport)
    @sprites["leftarrow0"].setBitmap("Graphics/Pictures/Pokedex/arrow_left0")    
    @sprites["leftarrow0"].visible=false
    @sprites["rightarrow0"]=IconSprite.new(478,21,@viewport)
    @sprites["rightarrow0"].setBitmap("Graphics/Pictures/Pokedex/arrow_right0")    
    @sprites["rightarrow0"].visible=false
  else
    @sprites["leftarrow"]=IconSprite.new(246,21,@viewport)
    @sprites["leftarrow"].setBitmap("Graphics/Pictures/Pokedex/arrow_leftBW")    
    @sprites["leftarrow"].visible=false
    @sprites["rightarrow"]=IconSprite.new(478,21,@viewport)
    @sprites["rightarrow"].setBitmap("Graphics/Pictures/Pokedex/arrow_rightBW")    
    @sprites["rightarrow"].visible=false
    @sprites["leftarrow0"]=IconSprite.new(246,21,@viewport)
    @sprites["leftarrow0"].setBitmap("Graphics/Pictures/Pokedex/arrow_left0BW")    
    @sprites["leftarrow0"].visible=false
    @sprites["rightarrow0"]=IconSprite.new(478,21,@viewport)
    @sprites["rightarrow0"].setBitmap("Graphics/Pictures/Pokedex/arrow_right0BW")    
    @sprites["rightarrow0"].visible=false  
  end
    
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["infosprite"] = PokemonSprite.new(@viewport)
    @sprites["infosprite"].setOffset(PictureOrigin::Center)
    @sprites["infosprite"].x = 104
    @sprites["infosprite"].y = 136
    
    pbRgssOpen("Data/townmap.dat","rb"){|f|
       @mapdata = Marshal.load(f)
    }
    mappos = (!$game_map) ? nil : pbGetMetadata($game_map.map_id,MetadataMapPosition)
    if @region<0                                   # Use player's current region
      @region = (mappos) ? mappos[0] : 0                      # Region 0 default
    end
    @sprites["areamap"] = IconSprite.new(0,400-400,@viewport)
    @sprites["areamap"].setBitmap("Graphics/Pictures/TownMap/#{@mapdata[@region][1]}")
    @sprites["areamap"].x += (Graphics.width-@sprites["areamap"].bitmap.width)/2
    @sprites["areamap"].y += (Graphics.height+32-@sprites["areamap"].bitmap.height)/10
   for hidden in REGIONMAPEXTRAS
      if hidden[0]==@region && hidden[1]>0 && $game_switches[hidden[1]]
        pbDrawImagePositions(@sprites["areamap"].bitmap,[
           ["Graphics/Pictures/#{hidden[4]}",
              hidden[2]*PokemonRegionMap_Scene::SQUAREWIDTH,
              hidden[3]*PokemonRegionMap_Scene::SQUAREHEIGHT,0,0,-1,-1]
        ])
      end
    end
    @sprites["areahighlight"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["areaoverlay"] = IconSprite.new(0,0,@viewport)
    @sprites["areaoverlay"].setBitmap("Graphics/Pictures/Pokedex/overlay_area")
    @sprites["formfront"] = PokemonSprite.new(@viewport)
    @sprites["formfront"].setOffset(PictureOrigin::Center)
    @sprites["formfront"].x = 130
    @sprites["formfront"].y = 158
    @sprites["formback"] = PokemonSprite.new(@viewport)
    @sprites["formback"].setOffset(PictureOrigin::Bottom)
    @sprites["formback"].x = 130 # y is set below as it depends on metrics
    @sprites["formicon"] = PokemonSpeciesIconSprite.new(0,@viewport)
    @sprites["formicon"].x = 284
    @sprites["formicon"].y = 76
    @sprites["uparrow"] = AnimatedSprite.new("Graphics/Pictures/uparrow",8,28,40,2,@viewport)
    @sprites["uparrow"].x = 325
    @sprites["uparrow"].y = 35
    @sprites["uparrow"].play
    @sprites["uparrow"].visible = false
    @sprites["downarrow"] = AnimatedSprite.new("Graphics/Pictures/downarrow",8,28,40,2,@viewport)
    @sprites["downarrow"].x = 325
    @sprites["downarrow"].y = 35
    @sprites["downarrow"].play
    @sprites["downarrow"].visible = false
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["forms"].z=1
    @sprites["area"].z=1
    @sprites["info"].z=1
    @sprites["iconrotate"]=Sprite.new(@viewport)
    @sprites["iconrotate"].bitmap=RPG::Cache.picture("Pokedex/iconRotate")
    @sprites["iconrotate"].x=64;@sprites["iconrotate"].y=296
    @sprites["iconrotate"].z=9999999     
    @sprites["iconrotateO"]=Sprite.new(@viewport)
    @sprites["iconrotateO"].bitmap=RPG::Cache.picture("Pokedex/iconother")
    @sprites["iconrotateO"].x=8;@sprites["iconrotateO"].y=296
    @sprites["iconrotateO"].z=9999999      
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbUpdateDummyPokemon
    @available = pbGetAvailableForms
    drawPage(@page)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbStartSceneBrief(species)  # For standalone access, shows first page only
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
#    @region = 0
    dexnum = species
    dexnumshift = false
    if $PokemonGlobal.pokedexUnlocked[$PokemonGlobal.pokedexUnlocked.length-1]
      dexnumshift = true if DEXINDEXOFFSETS.include?(-1)
    else
      dexnum = 0
      for i in 0...$PokemonGlobal.pokedexUnlocked.length-1
        if $PokemonGlobal.pokedexUnlocked[i]
          num = pbGetRegionalNumber(i,species)
          if num>0
            dexnum = num
            dexnumshift = true if DEXINDEXOFFSETS.include?(i)
#            @region = pbDexNames[i][1] if pbDexNames[i].is_a?(Array)
            break
          end
        end
      end
    end
       
    @dexlist = [[species,"",0,0,dexnum,dexnumshift]]
    @index   = 0
    @page = 1
    @brief = true
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Pokedex/icon_typesbw"))
    @sprites = {}
    @sprites["infosprite"].visible    = (@page==1)
    @sprites["areamap"].visible       = (@page==2) if @sprites["areamap"]
    @sprites["areahighlight"].visible = (@page==2) if @sprites["areahighlight"]
    @sprites["areaoverlay"].visible   = (@page==2) if @sprites["areaoverlay"]
    @sprites["formfront"].visible     = (@page==3) if @sprites["formfront"]
    @sprites["formback"].visible      = (@page==3) if @sprites["formback"]
    @sprites["formicon"].visible      = (@page==3) if @sprites["formicon"]  
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbUpdateDummyPokemon
    drawPage(@page)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end  
 
  def pbGetPokedexRegion
    if DEXDEPENDSONLOCATION
      region=pbGetCurrentRegion
      region=-1 if region>=$PokemonGlobal.pokedexUnlocked.length-1
      return region
    else
      if $PokemonGlobal.pokedexDex!=@natdex
        return $PokemonGlobal.pokedexDex
      else
        return -1
      end # National Dex -1, regional dexes 0 etc.
    end
  end  

  def pbNewDexEntryScene(species)     # Used only when capturing a new species
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    
    
   if !USEBW2SCENE
    @sprites["dexentryinfo"]=AnimatedPlane.new(@viewport)
    @sprites["dexentryinfo"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexbg2info"))
  else
    @sprites["dexentryinfo"]=AnimatedPlane.new(@viewport)
    @sprites["dexentryinfo"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexbg2infoBW2"))
  end
  if !USEBW2SCENE
    @sprites["dexinfo"]=IconSprite.new(0,46,@viewport)
    @sprites["dexinfo"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexbg2_1info"))
  else
    @sprites["dexinfo"]=IconSprite.new(0,46,@viewport)
    @sprites["dexinfo"].setBitmap(_INTL("Graphics/Pictures/Pokedex/dexbg2_1infoBW2"))
  end
    @sprites["battlebg"]=IconSprite.new(0,400-400,@viewport)
    @sprites["battlebg"].setBitmap(_INTL("Graphics/Pictures/BattleUI/battleballbg"))# Necessary Evil
   if !USEBW2SCENE
    @sprites["entrybars"]=IconSprite.new(0,0,@viewport)
    @sprites["entrybars"].setBitmap(_INTL("Graphics/Pictures/Pokedex/infocatch"))
  else
    @sprites["entrybars"]=IconSprite.new(0,0,@viewport)
    @sprites["entrybars"].setBitmap(_INTL("Graphics/Pictures/Pokedex/infocatchBW2"))
  end
    
    @sprites["iconentry"]=PokemonSpriteDex.new(@viewport)
    @sprites["iconentry"].mirror=true
    @sprites["iconentry"].lock
    
    @sprites["iconblack"]=PokemonSpriteDex.new(@viewport)
    @sprites["iconblack"].mirror=true
    @sprites["iconblack"].color=Color.new(0,0,0)
    @sprites["iconblack"].lock
        
    @sprites["iconentry"].unloadPokemonBitmap
    @sprites["iconentry"].loadPokemonBitmap(species)
    @sprites["iconentry"].visible=true
    pbPositionPokemonSprite(@sprites["iconentry"],28,68)

    @sprites["iconblack"].unloadPokemonBitmap
    @sprites["iconblack"].loadPokemonBitmap(species)
    @sprites["iconblack"].visible=true
    pbPositionPokemonSprite(@sprites["iconblack"],28,68)

    @width=@sprites["iconblack"].sprite.bitmap.width
    @height=@sprites["iconblack"].sprite.bitmap.height

    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    
    @sprites["overlay"].x=0
    @sprites["overlay"].y=0

    @sprites["dexentrytxt"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["dexentrytxt"].bitmap)
    @sprites["dexentrytxt"].bitmap.font.size=24
    
    @sprites["dexentrytxt"].x=0
    @sprites["dexentrytxt"].y=0
    
    basecolor=Color.new(90,82,82)
    shadowcolor=Color.new(165,165,173)
    
    indexNumber=pbGetRegionalNumber(pbGetPokedexRegion(),species)
    indexNumber=species if indexNumber==0
    indexNumber-=1 if DEXINDEXOFFSETS.include?(pbGetPokedexRegion)  
    yp=48

    textpos=[
       [_ISPRINTF("{1:03d}{2:s}",indexNumber," "),
          272,14+10+yp,0,basecolor,shadowcolor],
       [_ISPRINTF("{1:s}",PBSpecies.getName(species)),
          394,14+10+yp,2,basecolor,shadowcolor],
       [sprintf(_INTL("Height")),288,150+yp,0,basecolor,shadowcolor],
       [sprintf(_INTL("Weight")),288,182+yp,0,basecolor,shadowcolor]
    ]
    
      dexdata=pbOpenDexData
      pbDexDataOffset(dexdata,species,8)
      type1=dexdata.fgetb
      type2=dexdata.fgetb
      pbDexDataOffset(dexdata,species,33)
      height=dexdata.fgetw
      weight=dexdata.fgetw
      dexdata.close
      kind=pbGetMessage(MessageTypes::Kinds,species)
      dexentry=pbGetMessage(MessageTypes::Entries,species)
      inches=(height/0.254).round
      pounds=(weight/0.45359).round
      textpos.push([_ISPRINTF("{1:s} Pokémon",kind),370,58+yp,2,basecolor,shadowcolor])
      if pbGetCountry()==0xF4 # If the user is in the United States
        textpos.push([_ISPRINTF("{1:d}'{2:02d}\"",inches/12,inches%12),490,150+yp,1,basecolor,shadowcolor])
        textpos.push([_ISPRINTF("{1:4.1f} lbs.",pounds/10.0),490,182+yp,1,basecolor,shadowcolor])
      else
        textpos.push([_ISPRINTF("{1:.1f} m",height/10.0),480,150+yp,1,basecolor,shadowcolor])
        textpos.push([_ISPRINTF("{1:.1f} kg",weight/10.0),478,182+yp,1,basecolor,shadowcolor])
      end
      drawTextEx(@sprites["dexentrytxt"].bitmap,
         36,280,Graphics.width-36,3,dexentry,
         Color.new(255,255,255),Color.new(88,88,88))
         
      footprintfile=pbPokemonFootprintFile(species)
      if footprintfile
        footprint=BitmapCache.load_bitmap(footprintfile)
        @sprites["overlay"].bitmap.blt(224,114+yp,footprint,footprint.rect)
        footprint.dispose
      end
      pbDrawImagePositions(@sprites["overlay"].bitmap,[["Graphics/Pictures/Pokedex/icon_own0",208,20+yp,0,0,-1,-1]])
      typebitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/typesbw"))
      type1rect=Rect.new(0,type1*24,64,24)
      type2rect=Rect.new(0,type2*24,64,24)
      @sprites["overlay"].bitmap.blt(304,108+yp,typebitmap.bitmap,type1rect)
      @sprites["overlay"].bitmap.blt(384,108+yp,typebitmap.bitmap,type2rect) if type1!=type2
      typebitmap.dispose
      pbDrawTextPositions(@sprites["overlay"].bitmap,textpos)

    pbFadeInAndShow(@sprites)
  
  end

  def pbCentralDexEntryScene             # Used only when capturing a new species
    pbActivateWindow(@sprites,nil){
       loop do
         Graphics.update
         Input.update
          @height-=3
          @sprites["iconblack"].sprite.src_rect.set(0,0,@width,@height)
          @sprites["dexentryinfo"].ox +=1

         if Input.trigger?(Input::B) || Input.trigger?(Input::C)

           break
         end
       end
    }
  end  
  
  def pbUpdate
    if @page==2
      intensity = (Graphics.frame_count%40)*12
      intensity = 480-intensity if intensity>240
      @sprites["areahighlight"].opacity = intensity
    end
    pbUpdateSpriteHash(@sprites)
  end

  def pbUpdateDummyPokemon
    @species = @dexlist[@index][0]
    @gender  = ($Trainer.formlastseen[@species][0] rescue 0)
    @form    = ($Trainer.formlastseen[@species][1] rescue 0)
    @sprites["infosprite"].setSpeciesBitmap(@species,(@gender==1),@form)
    if @sprites["formfront"]
      @sprites["formfront"].setSpeciesBitmap(@species,(@gender==1),@form)
    end
    if @sprites["formback"]
      @sprites["formback"].setSpeciesBitmap(@species,(@gender==1),@form,false,false,true)
    if !USEEBS
      @sprites["formback"].y = 238#256
    else
      @sprites["formback"].y = 256
      end
    end
    if @sprites["formicon"]
      @sprites["formicon"].pbSetParams(@species,@gender,@form)
    end
  end

  def pbGetAvailableForms
    available = [] # [name, gender, form]
    formdata = pbLoadFormsData
    possibleforms = []
    multiforms = false
    if formdata[@species]
      for i in 0...formdata[@species].length
        fSpecies = pbGetFSpeciesFromForm(@species,i)
        formname = pbGetMessage(MessageTypes::FormNames,fSpecies)
        dexdata = pbOpenDexData
        pbDexDataOffset(dexdata,@species,18)
        genderbyte = dexdata.fgetb
        dexdata.close
        if i==0 || (formname && formname!="")
          multiforms = true if i>0
          case genderbyte
          when 0, 254, 255 # Male only, female only, genderless
            gendertopush = (genderbyte==254) ? 1 : 0
            if $Trainer.formseen[@species][gendertopush][i] || ALWAYSSHOWALLFORMS
              gendertopush = 2 if genderbyte==255
              possibleforms.push([i,gendertopush,formname])
            end
          else # Both male and female
            for g in 0...2
              if $Trainer.formseen[@species][g][i] || ALWAYSSHOWALLFORMS
                possibleforms.push([i,g,formname])
                break if (formname && formname!="")
              end
            end
          end
        end
      end
    end
    for thisform in possibleforms
      if thisform[2] && thisform[2]!="" # Has a form name
        thisformname = thisform[2]
      else # Necessarily applies only to form 0
        case thisform[1]
        when 0; thisformname = _INTL("Male")
        when 1; thisformname = _INTL("Female")
        else
          thisformname = (multiforms) ? _INTL("One Form") : _INTL("Genderless")
        end
      end
      # Push to available array
      gendertopush = (thisform[1]==2) ? 0 : thisform[1]
      available.push([thisformname,gendertopush,thisform[0]])
    end
    return available
  end

  def drawPage(page)
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    # Make certain sprites visible
    @sprites["dexentry2"].visible     = (@page==1)
    @sprites["entrybars"].visible     = (@page==1)
    @sprites["infosprite"].visible    = (@page==1)
    @sprites["backgroundM"].visible   = (@page==2) 
    @sprites["areamap"].visible       = (@page==2) if @sprites["areamap"]
    @sprites["areahighlight"].visible = (@page==2) if @sprites["areahighlight"]
    @sprites["areaoverlay"].visible   = false
    @sprites["entrybars2"].visible    = (@page==2) if @sprites["entrybars2"]
    @sprites["background4"].visible   = (@page==3)
    @sprites["grid4"].visible         = (@page==3)
    @sprites["formfront"].z           =  1
    @sprites["formback"].z            =  1
    @sprites["formicon"].z            =  1
    @sprites["return"].z              =  1
    @sprites["iconrotateO"].visible   = (@page==3) 
    @sprites["iconrotate"].visible    = (@page==3)
    @sprites["bginfo"].visible        = (@page==3)
    @sprites["bginfo"].z = 1
    @sprites["formfront"].visible     = (@page==3) if @sprites["formfront"]
    @sprites["formback"].visible      = (@page==3) if @sprites["formback"]
    @sprites["formicon"].visible      = (@page==3) if @sprites["formicon"]
    @sprites["entrybars3"].visible    = (@page==3) if @sprites["entrybars3"]
    @sprites["info"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/info") if page==1
    @sprites["area"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/area") if page==2
    @sprites["forms"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/forms") if page==3
    @sprites["info"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/info2") if @page==1 
    @sprites["area"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/area2") if @page==2  
    @sprites["forms"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/forms2") if @page==3 
    # Draw page-specific information
    case page
    when 1; drawPageInfo
    when 2; drawPageArea 
    when 3; drawPageForms   
    end
  end

  def drawPageInfo
    if USEBW2SCENE
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/Pokedex/bg_info"))
  else
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/Pokedex/bg_infoBW"))
  end
    #@sprites["info"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/Pages/info2")
    @sprites["area"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/area")
    @sprites["forms"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/forms")
    @sprites["normalbar"].visible=true 
    @sprites["updown"].z=1  
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88,88,80)
    shadow = Color.new(168,184,184)
    base2   = Color.new(255,255,255)
    shadow2 = Color.new(88,88,88)
    
    imagepos = []
    if @brief
      imagepos.push([_INTL("Graphics/Pictures/Pokedex/overlay_info"),0,0,0,0,-1,-1])
    end
    # Write various bits of text
    indexText = "???"
    if @dexlist[@index][4]>0
      indexNumber = @dexlist[@index][4]
      indexNumber -= 1 if @dexlist[@index][5]
      indexText = sprintf("%03d",indexNumber)
    end
  if USEBW2SCENE
    textpos = [
      [_INTL("INFO"),17*2,8,0,Color.new(255,255,255),Color.new(115,115,115)],
       [_INTL("{1}{2} {3}",indexText," ",PBSpecies.getName(@species)),
          246,42,0,Color.new(88,88,80),Color.new(168,184,184)],
       [_INTL("Height"),314,158,0,base,shadow],
       [_INTL("Weight"),314,190,0,base,shadow]
    ]
  else
    textpos = [    
      [_INTL("INFO"),48,8,0,Color.new(255,255,255),Color.new(115,115,115)],
       [_INTL("{1}{2} {3}",indexText," ",PBSpecies.getName(@species)),
          246,42,0,Color.new(88,88,80),Color.new(168,184,184)],
       [_INTL("Height"),314,158,0,base,shadow],
       [_INTL("Weight"),314,190,0,base,shadow]
    ]    
  end
    if $Trainer.owned[@species]
      fSpecies = pbGetFSpeciesFromForm(@species,@form)
      dexdata = pbOpenDexData
      # Write the kind
      kind = pbGetMessage(MessageTypes::Kinds,fSpecies)
      kind = pbGetMessage(MessageTypes::Kinds,@species) if !kind || kind==""
      textpos.push([_INTL("{1} Pokémon",kind),246,74,0,base,shadow])
      # Write the height and weight
      pbDexDataOffset(dexdata,fSpecies,33)
      height = dexdata.fgetw
      weight = dexdata.fgetw
      if pbGetCountry==0xF4   # If the user is in the United States
        inches = (height/0.254).round
        pounds = (weight/0.45359).round
        textpos.push([_ISPRINTF("{1:d}'{2:02d}\"",inches/12,inches%12),460,158,1,base,shadow])
        textpos.push([_ISPRINTF("{1:4.1f} lbs.",pounds/10.0),494,190,1,base,shadow])
      else
        textpos.push([_ISPRINTF("{1:.1f} m",height/10.0),470,158,1,base,shadow])
        textpos.push([_ISPRINTF("{1:.1f} kg",weight/10.0),482,190,1,base,shadow])
      end
      # Draw the Pokédex entry text
      entry = pbGetMessage(MessageTypes::Entries,fSpecies)
      entry = pbGetMessage(MessageTypes::Entries,@species) if !entry || entry==""
      overlay.font.size -= 5.9
      drawTextEx(overlay,36,234,Graphics.width-36,3,entry,base2,shadow2)
      overlay.font.size += 5.9
      #overlay.lineheight 1
      # Draw the footprint
      footprintfile = pbPokemonFootprintFile(@species,@form)
      if footprintfile
        footprint = BitmapCache.load_bitmap(footprintfile)
        overlay.blt(226,138,footprint,footprint.rect)
        footprint.dispose
      end
      # Show the owned icon
      imagepos.push(["Graphics/Pictures/Pokedex/icon_own0",209,43,0,0,-1,-1])
      # Draw the type icon(s)
      pbDexDataOffset(dexdata,fSpecies,8)
      type1 = dexdata.fgetb
      type2 = dexdata.fgetb
      type1rect = Rect.new(0,type1*32,96,32)
      type2rect = Rect.new(0,type2*32,96,32)
      overlay.blt(296,120,@typebitmap.bitmap,type1rect)
      overlay.blt(396,120,@typebitmap.bitmap,type2rect) if type1!=type2
      dexdata.close
    else
      # Write the kind
      textpos.push([_INTL("????? Pokémon"),246,74,0,base,shadow])
      # Write the height and weight
      if pbGetCountry()==0xF4 # If the user is in the United States
        textpos.push([_INTL("???'??\""),460,158,1,base,shadow])
        textpos.push([_INTL("????.? lbs."),494,190,1,base,shadow])
      else
        textpos.push([_INTL("????.? m"),470,158,1,base,shadow])
        textpos.push([_INTL("????.? kg"),482,190,1,base,shadow])
      end
    end
    # Draw all text
    pbDrawTextPositions(@sprites["overlay"].bitmap,textpos)
    # Draw all images
    pbDrawImagePositions(overlay,imagepos)
  end

  def drawPageArea
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/Pokedex/bg_area"))
   # @sprites["area"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/Pages/area2")
    @sprites["info"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/info") 
    @sprites["forms"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/forms")
    @sprites["normalbar"].visible=true 
    @sprites["updown"].z=1
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88,88,80)
    shadow = Color.new(168,184,184)
    base3  = Color.new(255,255,255)
    shadow3  = Color.new(88,88,80)
    @sprites["areahighlight"].bitmap.clear
    # Fill the array "points" with all squares of the region map in which the
    # species can be found
    points = []
    mapwidth = 1+PokemonRegionMap_Scene::RIGHT-PokemonRegionMap_Scene::LEFT
    encdata = load_data("Data/encounters.dat")
    for enc in encdata.keys
      enctypes = encdata[enc][1]
      if pbFindEncounter(enctypes,@species)
        mappos = pbGetMetadata(enc,MetadataMapPosition)
        if mappos && mappos[0]==@region
          showpoint = true
          for loc in @mapdata[@region][2]
            showpoint = false if loc[0]==mappos[1] && loc[1]==mappos[2] &&
                                 loc[7] && !$game_switches[loc[7]]
          end
          if showpoint
            mapsize = pbGetMetadata(enc,MetadataMapSize)
            if mapsize && mapsize[0] && mapsize[0]>0
              sqwidth  = mapsize[0]
              sqheight = (mapsize[1].length*1.0/mapsize[0]).ceil
              for i in 0...sqwidth
                for j in 0...sqheight
                  if mapsize[1][i+j*sqwidth,1].to_i>0
                    points[mappos[1]+i+(mappos[2]+j)*mapwidth] = true
                  end
                end
              end
            else
              points[mappos[1]+mappos[2]*mapwidth] = true
            end
          end
        end
      end
    end
    # Draw coloured squares on each square of the region map with a nest
    pointcolor   = Color.new(0,248,248)
    pointcolorhl = Color.new(192,248,248)
    sqwidth = PokemonRegionMap_Scene::SQUAREWIDTH
    sqheight = PokemonRegionMap_Scene::SQUAREHEIGHT
    for j in 0...points.length
      if points[j]
        x = (j%mapwidth)*sqwidth
        x += (Graphics.width-@sprites["areamap"].bitmap.width)+16
        y = (j/mapwidth)*sqheight
        y += (Graphics.height+32-@sprites["areamap"].bitmap.height)+18
        @sprites["areahighlight"].bitmap.fill_rect(x,y,sqwidth,sqheight,pointcolor)
        if j-mapwidth<0 || !points[j-mapwidth]
          @sprites["areahighlight"].bitmap.fill_rect(x,y-2,sqwidth,2,pointcolorhl)
        end
        if j+mapwidth>=points.length || !points[j+mapwidth]
          @sprites["areahighlight"].bitmap.fill_rect(x,y+sqheight,sqwidth,2,pointcolorhl)
        end
        if j%mapwidth==0 || !points[j-1]
          @sprites["areahighlight"].bitmap.fill_rect(x-2,y,2,sqheight,pointcolorhl)
        end
        if (j+1)%mapwidth==0 || !points[j+1]
          @sprites["areahighlight"].bitmap.fill_rect(x+sqwidth,y,2,sqheight,pointcolorhl)
        end
      end
    end
    # Set the text
    @sprites["overlay"].z=1
    textpos = []
    if points.length==0
      pbDrawImagePositions(overlay,[
         [sprintf("Graphics/Pictures/Pokedex/overlay_areanone"),108,188,0,0,-1,-1]
      ])
      textpos.push([_INTL("Area unknown"),Graphics.width/2,Graphics.height/2,2,base,shadow])
    end
if USEBW2SCENE
    textpos=[
       [_INTL("{1}",pbGetMessage(MessageTypes::RegionNames,@region)),17*2,8,0,Color.new(255,255,255),Color.new(115,115,115)],
       [_INTL("{1}'s AREA",PBSpecies.getName(@species)),Graphics.width-17*2,8,1,Color.new(255,255,255),Color.new(165,165,173)],
    ]
  else
    textpos=[
       [_INTL("{1}",pbGetMessage(MessageTypes::RegionNames,@region)),48,8,0,Color.new(255,255,255),Color.new(115,115,115)],
       [_INTL("{1}'s AREA",PBSpecies.getName(@species)),Graphics.width-48,8,1,Color.new(255,255,255),Color.new(165,165,173)],
    ]
  end
    pbDrawTextPositions(overlay,textpos)
  end
  def drawPageForms
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/Pokedex/bg_forms"))
    #@sprites["forms"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/Pages/forms2")
    @sprites["area"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/area")  
    @sprites["info"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/info")
    @sprites["normalbar"].visible=true 
    @sprites["overlay"].z=1
    @sprites["formback"].visible=false
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88,88,80)
    shadow = Color.new(168,184,184)
    base3  = Color.new(255,255,255)
    shadow3  = Color.new(88,88,80)    
    # Write species and form name
    formname = ""
    for i in @available
      if i[1]==@gender && i[2]==@form
        formname = i[0]; break
      end
    end
  if USEBW2SCENE
    textpos = [
       [_INTL("FORMS"),17*2,8,0,Color.new(255,255,255),Color.new(155,155,155)],
       [_INTL("Forms Seen"),280,222,0,base,shadow],
       [_INTL("{1}",$Trainer.numFormsSeen(@species)),462,222,0,base,shadow],
       [PBSpecies.getName(@species),354,94,0,base,shadow],#,Graphics.width-255,Graphics.height-375,2,
       [formname,365,22,2,base3,shadow3],   #,Graphics.width-105,Graphics.height-375,2
    ]
  else
    textpos = [
       [_INTL("FORMS"),48,8,0,Color.new(255,255,255),Color.new(155,155,155)],
       [_INTL("Forms Seen"),280,222,0,base,shadow],
       [_INTL("{1}",$Trainer.numFormsSeen(@species)),462,222,0,base,shadow],
       [PBSpecies.getName(@species),354,94,0,base,shadow],#,Graphics.width-255,Graphics.height-375,2,
       [formname,365,22,2,base3,shadow3],   #,Graphics.width-105,Graphics.height-375,2
    ]
  end
    
    # Draw all text
    pbDrawTextPositions(overlay,textpos)
  end

  def pbGoToPrevious
    newindex = @index
    while newindex>0
      newindex -= 1
      if $Trainer.seen[@dexlist[newindex][0]]
        @index = newindex
        break
      end
    end
  end

  def pbGoToNext
    newindex = @index
    while newindex<@dexlist.length-1
      newindex += 1
      if $Trainer.seen[@dexlist[newindex][0]]
        @index = newindex
        break
      end
    end
  end

  def pbChooseForm
    index = 0
    for i in 0...@available.length
      if @available[i][1]==@gender && @available[i][2]==@form
        index = i
        break
      end
    end
    oldindex = -1
    loop do
      if oldindex!=index
        $Trainer.formlastseen[@species][0] = @available[index][1]
        $Trainer.formlastseen[@species][1] = @available[index][2]
        pbUpdateDummyPokemon
        
        drawPage(@page)
        #@sprites["rightarrow0"].visible   =(index>0)
        #@sprites["leftarrow0"].visible = (index<@available.length-1)
        @sprites["leftarrow"].visible     = true
        @sprites["rightarrow"].visible    = true
        @sprites["leftarrow"].z = 1    
        @sprites["rightarrow"].z = 1  
        @sprites["leftarrow0"].z = 1
        @sprites["rightarrow0"].z = 1
        oldindex = index
      end
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::LEFT)
        if USEBW2SCENE
        @sprites["leftarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_left2") 
        pbWait(4)
        @sprites["leftarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_left") 
        pbPlayCursorSE
        dorefresh=true
        index = (index+@available.length-1)%@available.length
      else
        @sprites["leftarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_left2BW") 
        pbWait(4)
        @sprites["leftarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_leftBW") 
        pbPlayCursorSE
        dorefresh=true        
        index = (index+@available.length-1)%@available.length
      end
    elsif Input.trigger?(Input::RIGHT) 
      if USEBW2SCENE
        @sprites["rightarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_right2") 
        pbWait(4)
        @sprites["rightarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_right") 
        pbPlayCursorSE
        index = (index+1)%@available.length
      else
        @sprites["rightarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_right2BW") 
        pbWait(4)
        @sprites["rightarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_rightBW") 
        pbPlayCursorSE
        index = (index+1)%@available.length        
      end
    elsif  defined?($mouse) 
      if $mouse.leftClick?(@sprites["leftarrow"])
        if USEBW2SCENE
        @sprites["leftarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_left2") 
        pbWait(4)
        @sprites["leftarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_left") 
        pbPlayCursorSE
        dorefresh=true
        index = (index+@available.length-1)%@available.length
      else
        @sprites["leftarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_left2BW") 
        pbWait(4)
        @sprites["leftarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_leftBW") 
        pbPlayCursorSE
        dorefresh=true        
        index = (index+@available.length-1)%@available.length
      end      
    elsif $mouse.leftClick?(@sprites["rightarrow"])
      if USEBW2SCENE
        @sprites["rightarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_right2") 
        pbWait(4)
        @sprites["rightarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_right") 
        pbPlayCursorSE
        index = (index+1)%@available.length
      else
        @sprites["rightarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_right2BW") 
        pbWait(4)
        @sprites["rightarrow"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/arrow_rightBW") 
        pbPlayCursorSE
        index = (index+1)%@available.length        
       end       
     elsif $mouse.leftClick?(@sprites["iconrotate"])
          if @sprites["formback"].visible
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate2")
          pbWait(4)
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate")  
          @sprites["formback"].visible=false
          @sprites["formfront"].visible=true
        else
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate2")
          pbWait(4)
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate")  
          @sprites["formback"].visible=true
          @sprites["formfront"].visible=false
        end   
      elsif $mouse.rightClick?(@sprites["iconrotateO"])
        @sprites["iconrotateO"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconother2") 
        pbWait(4)
        @sprites["iconrotateO"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconother") 
        @page = 3
        pbSEPlay("BW2Cancel")
        @sprites["leftarrow"].visible     = false
        @sprites["rightarrow"].visible    = false 
        dorefresh = true
        @sprites["formicon"].visible=false
        break  
      end
    end
      if Input.trigger?(Input::B) 
        @sprites["iconrotateO"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconother2") 
        pbWait(4)
        @sprites["iconrotateO"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconother") 
        @page = 3
        pbSEPlay("BW2Cancel")
        @sprites["leftarrow"].visible     = false
        @sprites["rightarrow"].visible    = false 
        dorefresh = true
        @sprites["formicon"].visible=false
        break
      elsif Input.trigger?(Input::C)
        pbSEPlay("BW2MenuChoose")
        @sprites["leftarrow"].visible     = false
        @sprites["rightarrow"].visible    = false 
        break
      end
    end
    @sprites["uparrow"].visible   = false
    @sprites["downarrow"].visible = false
  end

  def pbScene
    pbPlayCrySpecies(@species,@form)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::A)
        pbSEStop; pbPlayCrySpecies(@species,@form) if @page==1
      elsif Input.trigger?(Input::B) 
        @sprites["return"].bitmap=Bitmap.new("Graphics/Pictures/Universal/return2")
        pbWait(3)
        @sprites["return"].bitmap=Bitmap.new("Graphics/Pictures/Universal/return")
        pbSEPlay("BW2Cancel")  
        dorefresh = true
        break       
      elsif Input.trigger?(Input::C)
        if @page==2   # Area
          dorefresh = true
        elsif @page==3   # Forms
          @sprites["iconrotateO"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconother2")
          pbWait(4)
          @sprites["iconrotateO"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconother")           
          if @available.length>1
            pbPlayDecisionSE
            pbChooseForm
            dorefresh = true
          end
        end
      elsif Input.trigger?(Input::F)
          if @sprites["formback"].visible
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate2")
          pbWait(4)
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate")  
          @sprites["formback"].visible=false
          @sprites["formfront"].visible=true
        else
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate2")
          pbWait(4)
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate")  
          @sprites["formback"].visible=true
          @sprites["formfront"].visible=false
        end          
      elsif Input.trigger?(Input::UP) 
        @sprites["updown"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/updown2")
        pbWait(3)
        @sprites["updown"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/updown")
        oldindex = @index
        pbGoToPrevious
        if @index!=oldindex
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          dorefresh = true
          pbSEStop
          (@page==1) ? pbPlayCrySpecies(@species,@form) : pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::DOWN)
        @sprites["updown"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/updown3")
        pbWait(3)
        @sprites["updown"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/updown")        
        oldindex = @index
        pbGoToNext
        if @index!=oldindex
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          dorefresh = true
          pbSEStop
          (@page==1) ? pbPlayCrySpecies(@species,@form) : pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::LEFT)
        oldpage = @page
        @page -= 1
        @page = 1 if @page<1
        @page = 3 if @page>3
        if @page!=oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::RIGHT)
        oldpage = @page
        @page += 1
        @page = 1 if @page<1
        @page = 3 if @page>3
        if @page!=oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      elsif defined?($mouse) 
        if $mouse.leftClick?(@sprites["iconrotate"])
          if @sprites["formback"].visible
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate2")
          pbWait(4)
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate")  
          @sprites["formback"].visible=false
          @sprites["formfront"].visible=true
        else
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate2")
          pbWait(4)
          @sprites["iconrotate"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconRotate")  
          @sprites["formback"].visible=true
          @sprites["formfront"].visible=false
        end 
      elsif $mouse.leftClick?(@sprites["return"])
        @sprites["return"].bitmap=Bitmap.new("Graphics/Pictures/Universal/return2")
        pbWait(3)
        @sprites["return"].bitmap=Bitmap.new("Graphics/Pictures/Universal/return")
        pbSEPlay("BW2Cancel")  
        dorefresh = true
        break               
         elsif $mouse.leftClick?(@sprites["iconrotateO"])
          @sprites["iconrotateO"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconother2")
          pbWait(4)
          @sprites["iconrotateO"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/iconother") 
           if @available.length>1
            pbPlayDecisionSE
            pbChooseForm
            dorefresh = true            
          end
      elsif $mouse.inAreaLeft?(10,342,28,34)
        @sprites["updown"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/updown2")
        pbWait(3)
        @sprites["updown"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/updown")
        oldindex = @index
        pbGoToPrevious
        if @index!=oldindex
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          dorefresh = true
          pbSEStop
          (@page==1) ? pbPlayCrySpecies(@species,@form) : pbPlayCursorSE
          dorefresh = true
        end
      elsif $mouse.inAreaLeft?(58,344,28,34)
        @sprites["updown"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/updown3")
        pbWait(3)
        @sprites["updown"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/updown")        
        oldindex = @index
        pbGoToNext
        if @index!=oldindex
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          dorefresh = true
          pbSEStop
          (@page==1) ? pbPlayCrySpecies(@species,@form) : pbPlayCursorSE
          dorefresh = true
        end          
        elsif $mouse.leftClick?(@sprites["info"])
          pbPlayCursorSE
          @sprites["info"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/info2")
          @sprites["area"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/area")
          @sprites["forms"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/forms")
          @page=1
          dorefresh = true
        elsif $mouse.leftClick?(@sprites["area"])
          pbPlayCursorSE
          @sprites["info"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/info")
          @sprites["area"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/area2")
          @sprites["forms"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/forms")
          @page=2
          dorefresh = true  
        elsif $mouse.leftClick?(@sprites["forms"])
          pbPlayCursorSE
          @sprites["info"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/info")
          @sprites["area"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/area")
          @sprites["forms"].bitmap=Bitmap.new("Graphics/Pictures/Pokedex/forms2")
          @page=3
          dorefresh = true          
        end
      end
      if dorefresh
        drawPage(@page)
      end
    end
    return @index
  end

  def pbSceneBrief
    pbPlayCrySpecies(@species,@form)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::A)
        pbSEStop; pbPlayCrySpecies(@species,@form)
      elsif Input.trigger?(Input::B)
        pbSEPlay("BW2Cancel")
        break
      elsif Input.trigger?(Input::C)
        pbPlayDecisionSE
        break
      end
    end
  end
end



class PokemonPokedexInfoScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(dexlist,index,region)
    @scene.pbStartScene(dexlist,index,region)
    ret = @scene.pbScene
    @scene.pbEndScene
    return ret   # Index of last species viewed in dexlist
  end

  def pbStartSceneSingle(species)   # For use from a Pokémon's summary screen
    region = -1
    if DEXDEPENDSONLOCATION
      region = pbGetCurrentRegion
      region = -1 if region>=$PokemonGlobal.pokedexUnlocked.length-1
    else
      region = $PokemonGlobal.pokedexDex # National Dex -1, regional dexes 0 etc.
    end
    dexnum = pbGetRegionalNumber(region,species)
    dexnumshift = DEXINDEXOFFSETS.include?(region)
    dexlist = [[species,PBSpecies.getName(species),0,0,dexnum,dexnumshift]]
    @scene.pbStartScene(dexlist,0,region)
    @scene.pbScene
    @scene.pbEndScene
  end
  
  def pbDexEntry(species)
    @scene.pbNewDexEntryScene(species)
    @scene.pbCentralDexEntryScene 
    @scene.pbEndScene
  end  
end