﻿package away3d.core.material{	import flash.display.BitmapData;	import flash.geom.Rectangle;	public class BitmapCleaner	{		public var dest_bmd:BitmapData;		public var rect:Rectangle;		private var tmprect:Rectangle = new Rectangle(0,0,1,1);		public var color:Number;		public function get drawrect():Rectangle		{			return this.rect;					}		public function clear():Boolean		{			this.dest_bmd.fillRect(rect,0x000000);			this.rect.x=2800;			this.rect.y=2800;			this.rect.width=0;			this.rect.height=0;			return true;					}		public function BitmapCleaner(dest_bmd:BitmapData,color:Number=0x00):void		{			this.dest_bmd=dest_bmd;			this.rect=new Rectangle(2800,2800,0,0);			this.color=color;		}		public function update(x0:int,y0:int,x1:int,y1:int,x2:int,y2:int):Rectangle		{						this.tmprect.x = Math.min(x0,x1,x2);			this.tmprect.y = Math.min(y0,y1,y2);			this.tmprect.width = Math.max(x0,x1,x2)-this.tmprect.x;			this.tmprect.height = Math.max(y0,y1,y2)-this.tmprect.y;			this.rect.x=Math.min(this.tmprect.x,this.rect.x);			this.rect.y=Math.min(this.tmprect.y,this.rect.y);			this.rect.width=Math.max(this.tmprect.width,this.rect.width);			this.rect.height=Math.max(this.tmprect.height,this.rect.height);						return this.tmprect;		}		 	}}