pbSetResizeFactor(2)
ObjectSpace.each_object(TilemapLoader){|o| o.updateClass if !o.disposed? }