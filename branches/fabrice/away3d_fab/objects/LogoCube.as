﻿package away3d.objects
{
    import away3d.core.*;
    import away3d.core.mesh.*;
    import away3d.core.material.*;
    import away3d.core.utils.*;
	import away3d.core.stats.*;
    
    import flash.display.*;

    /** LogoCube */ 
    public class LogoCube extends Cube
    {
        public function LogoCube(init:Object = null)
        {
            super(init);
            
            var sprite:Sprite = new Sprite();
            var graphics:Graphics = sprite.graphics;

            graphics.lineStyle(1, 0xFF00FF);
            graphics.drawRect(0, 0, 400, 400);
            graphics.endFill();

            graphics.lineStyle();
            graphics.beginFill(0x0000FF);
            graphics.moveTo(185, 48);
            graphics.lineTo(47, 325);
            graphics.lineTo(285, 325);
            graphics.lineTo(268, 295);
            graphics.lineTo(98, 295);
            graphics.lineTo(219, 48);
            graphics.endFill();

            material = Cast.material(sprite);
			
			Stats.instance.register("LogoCube",1,"primitive");
        }
    }
    
}