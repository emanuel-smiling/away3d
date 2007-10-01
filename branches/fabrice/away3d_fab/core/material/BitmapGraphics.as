﻿package away3d.core.material{	import flash.display.BitmapData;	import flash.display.IBitmapDrawable;	import flash.geom.Rectangle;	import flash.geom.Point;	import flash.geom.Matrix;	import flash.geom.ColorTransform;	//	public class BitmapGraphics  	//implements IGraphics	{		protected static var _rect:Rectangle = new Rectangle(0,0,0,1);		protected static var o:Object= new Object();		protected static var pt:Point= new Point(0,0);		protected static var scratch_bmd:BitmapData = new BitmapData(2798, 2798, true, 0x00FFFFFF);  		//public function BitmapGraphics(){ }		//		public static function renderFilledTriangle(dest_bmd:BitmapData,x0:int,y0:int,x1:int,y1:int,x2:int,y2:int,fillcolor:Number = 0xFFCCCCCC, linecolor:Number = -1, tmprect:Rectangle = null):void		{ 				o = new Object();			pt.x = tmprect.x;			pt.y = tmprect.y;			 			scratch_bmd.fillRect(tmprect,fillcolor);						o.col=fillcolor;			o.rct=_rect;						o.dest_bmd = dest_bmd;			o.b=false; 			if (x0<=0) {				x0 = 1;			}			if (x1<=0) {				x1 = 1;			}			if (x2<=0) {				x2 = 1;			}			 			scanL(o, x0, y0, x1, y1);			scanL(o, x1, y1, x2, y2);			scanL(o, x2, y2, x0, y0);			 			if(linecolor != -1){				drawLine(dest_bmd,x0, y0, x1, y1, linecolor);				drawLine(dest_bmd, x1, y1, x2, y2, linecolor);				drawLine(dest_bmd, x2, y2, x0, y0, linecolor);			}		} 		 		 public static function renderBitmapTriangleSmooth(dest_bmd:BitmapData,source_bmd:BitmapData,x0:int,y0:int,x1:int,y1:int,x2:int,y2:int,mat:Matrix,color1:Number,color2:Number,color3:Number, tmprect:Rectangle = null, debug_bmd:BitmapData = null):void		{				pt.x = tmprect.x;			pt.y = tmprect.y;						//dest_bmd.fillRect(tmprect,0xFFFF0000); 			scratch_bmd.draw(source_bmd, mat, null ,"normal", tmprect, false);						//debug			if(debug_bmd != null){				debug_bmd.copyPixels(scratch_bmd, tmprect, new Point(tmprect.x,tmprect.y));			}			// end debug			var o:Object= new Object();			o.dest_bmd = dest_bmd;			o.rct = _rect;			o.s = true;									// here must come a ColorObject instead of setting it each time... specially if lightning is being locked.			//color			o.tmprect = tmprect;						var c1a = color1 >> 24 & 0xFF;			var c1r = color1 >> 16 & 0xFF;			var c1g = color1 >> 8 & 0xFF;			var c1b = color1 & 0xFF;						var c2a = color2 >> 24 & 0xFF;			var c2r = color2 >> 16 & 0xFF;			var c2g = color2 >> 8 & 0xFF;			var c2b = color2 & 0xFF;			 			var c3a = color3 >> 24 & 0xFF;			var c3r = color3 >> 16 & 0xFF;			var c3g = color3 >> 8 & 0xFF;			var c3b = color3 & 0xFF;			 			//first color = most left			o.stepx1a = c1a/100;			o.stepx1r = c1r/100;			o.stepx1g = c1g/100;			o.stepx1b = c1b/100;						// second color = most right			o.stepx2a = c2a/100;			o.stepx2r = c2r/100;			o.stepx2g = c2g/100;			o.stepx2b = c2b/100;						// third color = most down			o.stepy3a = c3a/100;			o.stepy3r = c3r/100;			o.stepy3g = c3g/100;			o.stepy3b = c3b/100;			//						if (x0<=0) {				x0 = 1;			}			if (x1<=0) {				x1 = 1;			}			if (x2<=0) {				x2 = 1;			}			 			scanL(o, x0, y0, x1, y1);			scanL(o, x1, y1, x2, y2);			scanL(o, x2, y2, x0, y0);			 		}		public static function renderBitmapTriangle(dest_bmd:BitmapData,source_bmd:BitmapData,x0:int,y0:int,x1:int,y1:int,x2:int,y2:int,mat:Matrix,ct:ColorTransform=null, tmprect:Rectangle = null):void		{			 			pt.x = tmprect.x;			pt.y = tmprect.y;			 			scratch_bmd.draw(source_bmd, mat, ct ,"normal", tmprect, false);			 			var o:Object= new Object();			o.dest_bmd = dest_bmd;			o.rct = _rect;			o.b=true;			 			if (x0<=0) {				x0 = 1;			}			if (x1<=0) {				x1 = 1;			}			if (x2<=0) {				x2 = 1;			}			 			scanL(o, x0, y0, x1, y1);			scanL(o, x1, y1, x2, y2);			scanL(o, x2, y2, x0, y0);					 }				public static function traceLine(o:Object,  x:int,y:int):void {			if (o[y]) {				if(o.s){					var py:int;					var py2:int;					var startx:int;					var xend:int;					var a:int;					var r:int;					var g:int;					var b:int;					var scol:Number;					var sa:int;					var sr:int;					var sg:int;					var sb:int;					var px:int;					var px2:int;					var xx:int = 0;				}				if (o[y] > x) {					o.rct.width = o[y] - x;					o.rct.x = x;					o.rct.y = y;					if(o.b){						//flat bitmap						pt.x = x;						pt.y = y;						o.dest_bmd.copyPixels(scratch_bmd, o.rct, pt);					}else if(o.s){						//smooth						py = (y/o.tmprect.height)*100;						py2 = 100-py;												startx = x;						xend = startx+(o[y] - x);						 						while (startx++<xend){														scol = scratch_bmd.getPixel32(startx,y);							sa = scol >> 24 & 0xFF;							sr = scol >> 16 & 0xFF;							sg = scol >> 8 & 0xFF;							sb = scol & 0xFF;														px = (xx/o.tmprect.width)*100;							px2 = 100-px;														a = ((o.stepx1a*px)+(o.stepx2a*px2)+(o.stepy3a*py)+sa)/3;							r = ((o.stepx1r*px)+(o.stepx2r*px2)+(o.stepy3r*py)+sr)/3;							g = ((o.stepx1g*px)+(o.stepx2g*px2)+(o.stepy3g*py)+sg)/3;							b = ((o.stepx1b*px)+(o.stepx2b*px2)+(o.stepy3b*py)+sb)/3;							 							o.dest_bmd.setPixel(startx, y, a << 24 | r << 16 | g << 8 | b);														xx ++; 						}						 						//o.dest_bmd.fillRect(o.rct,o.col1);					} else {						  o.dest_bmd.fillRect(o.rct,o.col);						//pt.x = x;						//pt.y = y;						// o.dest_bmd.copyPixels(scratch_bmd, o.rct, pt); 						//drawLine(o.dest_bmd, x, y, x+(o[y] - x), y, o.col);					}				} else {					o.rct.width = x - o[y];					o.rct.x = o[y];					o.rct.y = y;										if(o.b){						//flat bitmap						pt.x = o[y];						pt.y = y;												o.dest_bmd.copyPixels(scratch_bmd, o.rct, pt); 					}else if(o.s){						//smooth						py = (y/o.tmprect.height)*100;						py2 = 100-py;												startx = o[y];						xend = startx+o.rct.width;						 						while (startx++<xend){														scol = scratch_bmd.getPixel32(startx,y);							sa = scol >> 24 & 0xFF;							sr = scol >> 16 & 0xFF;							sg = scol >> 8 & 0xFF;							sb = scol & 0xFF;							 							px = (xx/o.tmprect.width)*100;							px2 = 100-px;														a = ((o.stepx1a*px)+(o.stepx2a*px2)+(o.stepy3a*py)+sa)/3;							r = ((o.stepx1r*px)+(o.stepx2r*px2)+(o.stepy3r*py)+sr)/3;							g = ((o.stepx1g*px)+(o.stepx2g*px2)+(o.stepy3g*py)+sg)/3;							b = ((o.stepx1b*px)+(o.stepx2b*px2)+(o.stepy3b*py)+sb)/3;							 							o.dest_bmd.setPixel(startx, y, a << 24 | r << 16 | g << 8 | b);														xx ++;						}						//o.dest_bmd.fillRect(o.rct,o.col1);					} else {						 o.dest_bmd.fillRect(o.rct,o.col);						//pt.x = o[y];						//pt.y = y;						//o.dest_bmd.copyPixels(scratch_bmd, o.rct, pt); 						//drawLine(o.dest_bmd, o[y], y, o[y]+(x - o[y]), y, acolor);					}				}			} else {				o[y]=x;			}		}		/*		void shadedline (int x1, int firstcolor, int x2, int lastcolor, int y){int length;int numcolors;int colorvalue;int step;int x;unsigned char far * dest;   /// Ptr to the screen length = x2 - x1 + 1; if (length > 0) {  numcolors = lastcolor - firstcolor + 1;  colorvalue = firstcolor << 8;  step = ((long)numcolors << 8) / (long)length;  dest = abuf + y * 320 + x1; // Make a pointer to the first pixel  for (x = x1; x <= x2; x++)    {     dest++ = colorvalue >> 8;     // Draw the pixel and move to the next location in memory      colorvalue += step;    } }}*/				 public static function scanL(o:Object, x0:int,y0:int,x1:int,y1:int):void		 {			 				var steep:Boolean= (y1-y0)*(y1-y0) > (x1-x0)*(x1-x0);								if (steep){					var swap:int=x0; 					x0=y0; 					y0=swap;					swap=x1;					x1=y1;					y1=swap;				}				if (x0>x1){					x0^=x1; x1^=x0; x0^=x1;					y0^=y1; y1^=y0; y0^=y1;				}				var dx:int = x1 - x0;				var dy:int = Math.abs(y1 - y0);				var error:int = 0;				var y:int = y0;							var ystep:int = y0<y1 ? 1 : -1;				var x:int=x0;				var xend:int=x1-(dx>>1);				var fx:int=x1;				var fy:int=y1; 				var px:int=0;				o.rct.x = 0;				o.rct.y = 0;				o.rct.width = 0;										while (x++<=xend){					if (steep){						traceLine(o, y,x );												if (fx!=x1 && fx!=xend){							traceLine(o,fy,fx+1 );						}					}					error += dy;					if ((error<<1) >= dx){						if (!steep) {							traceLine(o,x-px+1,y );							if (fx!=xend) {								traceLine(o,fx+1,fy );							}						}						px=0;						y+=ystep;						fy-=ystep;						error -= dx; 					}					px++;					fx--;				}				if (!steep){					traceLine(o, x-px+1,y );				}								}		public static function drawLine(dest_bmd:BitmapData,x1:int,y1:int,x2:int,y2:int,color:Number=0x00):void		{			var error:Number;			var dx:Number;			var dy:Number;			if (x1 > x2) {				var tmp:Number = x1;				x1 = x2;				x2 = tmp;				tmp = y1;				y1 = y2;				y2 = tmp;			}			dx = x2 - x1;			dy = y2 - y1;			var yi:Number = 1;			if (dx < dy) {				x1 ^= x2;				x2 ^= x1;				x1 ^= x2;				y1 ^= y2;				y2 ^= y1;				y1 ^= y2;			}			if (dy < 0) {				dy = -dy;				yi = -yi;			}			if (dy > dx) {				error = -(dy >> 1);				for (; y2 < y1; y2++) {				dest_bmd.setPixel32(x2, y2, color);					error += dx;					if (error > 0) {						x2 += yi;						error -= dy;					}				}			} else {				error = -(dx >> 1);				for (; x1 < x2; x1++) {					dest_bmd.setPixel32(x1, y1, color);					error += dy;				if (error > 0) {					y1 += yi;						error -= dx;					}				}			}		}	}}