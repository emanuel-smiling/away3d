﻿package away3d.core.material.fx{	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.geom.Matrix;	import flash.filters.ConvolutionFilter;	import flash.filters.DisplacementMapFilter;	import flash.filters.ColorMatrixFilter;	import flash.geom.ColorTransform;	import flash.geom.Transform;	import flash.display.BitmapData;	import flash.display.Sprite;	import away3d.register.RenderEvent;	import flash.events.EventDispatcher;	import away3d.core.material.filters.AWDisplacementMapFilter;	import away3d.core.material.filters.AWConvolutionFilter;		import away3d.register.MCClassManager;	//	public class Bump extends EventDispatcher	{		public var source_bmd:BitmapData;		public var bump_bmd:BitmapData;		public var dest_bmd:BitmapData;		public var light_bmd:BitmapData;		public var mask_bmd:BitmapData;		public var overlay_bmd:BitmapData;		public var overlayscratch_bmd:BitmapData;		public var overlayalpha_bmd:BitmapData;		private var zeropoint:Point = new Point(0,0);		private var CF:ConvolutionFilter;		private var DP:DisplacementMapFilter;		private var dummy:BitmapData;		private var tempmap:BitmapData;		private var _mode:String = "";		private var _usedrect:Rectangle;		private var _usedpoint:Point = new Point(0,0);		private var bReUse:Boolean;		private var bOverlaymask:Boolean;		private var bTotalmask:Boolean = false;		private var bAnimate:Boolean = false;		private var container:Sprite;		//		function Bump(bump_bmd:BitmapData, light_bmd:BitmapData = null, bAnimate:Boolean = false, strmode:String = "", mask_bmd:BitmapData = null, bTotalmask:Boolean = false, bOverlaymask:Boolean = false)		{			this.bump_bmd = bump_bmd.clone();			this.light_bmd = light_bmd;			this.bAnimate = bAnimate;			if(mask_bmd != null){				this.mask_bmd = mask_bmd;				this.bTotalmask = bTotalmask;				this.generateMask(mask_bmd);				this.bOverlaymask = bOverlaymask;			}			this._mode = strmode;		}				public function apply(index:int, source_bmd:BitmapData, dest_bmd:BitmapData, destrect:Rectangle,  normal:Object = null, CT:ColorTransform = null, container:Sprite = null):void		{				this.applyBump(index, source_bmd, dest_bmd, destrect, normal, CT, container);		}				private function checkMode(strmode:String):String{			//normal is not considered to save a draw handeling, the value is set to "" witch equals "normal"			var aModelist = ["add", "overlay", "screen", "substract", "multiply", "layer", "invert", "hardlight", "erase", "darken", "alpha", "difference"];			for(var i = 0;i<aModelist.length;i++){				if(strmode == aModelist[i]){					return aModelist[i];				}			}			return "";		}				public function set mode(strmode:String):void		{			this._mode = this.checkMode(strmode.toLowerCase());		}				private function generateMask(mask_source:BitmapData):void		{			var tempsourceBMD:BitmapData = new BitmapData(mask_source.width, mask_source.height, true, 0x00000000);			tempsourceBMD.copyPixels(mask_source, mask_source.rect, this.zeropoint);			var tempBMD:BitmapData = tempsourceBMD.clone();			tempBMD.copyChannel(tempsourceBMD, mask_source.rect, this.zeropoint, 1, 8);			this.mask_bmd.copyPixels(tempBMD, tempsourceBMD.rect, this.zeropoint);			tempBMD.dispose();			tempsourceBMD.dispose(); 		}				private function inverseMask(dest_bmd:BitmapData):void		{			if(!dest_bmd.transparent){				var tmp:BitmapData = new BitmapData(dest_bmd.width, dest_bmd.height, true, 0xFFFFFFFF);				tmp.copyPixels(dest_bmd, dest_bmd.rect, this.zeropoint);				dest_bmd = tmp.clone();				tmp.dispose();			}			var tempsourceBMD:BitmapData = new BitmapData(dest_bmd.width, dest_bmd.height, true, 0xFFFFFFFF);			tempsourceBMD.copyChannel(this.mask_bmd, this.mask_bmd.rect, this.zeropoint, 8, 1);			tempsourceBMD.applyFilter(tempsourceBMD, tempsourceBMD.rect,  new Point(0,0), new ColorMatrixFilter([-1, 0, 0,0,255, 0,-1, 0,0,255, 0, 0,-1,0,255,  0, 0, 0,1,0]));			dest_bmd.copyChannel(tempsourceBMD, tempsourceBMD.rect, this.zeropoint, 1, 8);			tempsourceBMD.dispose(); 		}				private function applyMask(dest:BitmapData):void		{			dest.copyChannel(this.mask_bmd, this.mask_bmd.rect, this.zeropoint, 8, 8);		}				private function buildbump():void		{			 			this.dummy.copyPixels(this.source_bmd , this.source_bmd.rect, this.zeropoint);			this.tempmap.copyPixels(this.source_bmd , this.source_bmd.rect, this.zeropoint);			 			this.dummy.applyFilter(this.bump_bmd, this.bump_bmd.rect, this.zeropoint, this.CF);			this.CF.matrix = new Array(0,-1,0,0,0,0,0,1,0);						this.tempmap.applyFilter(this.bump_bmd, this.bump_bmd.rect, this.zeropoint, this.CF);			this.dummy.copyChannel(this.tempmap, this.tempmap.rect, this.zeropoint, 1, 2);						if(this.mask_bmd != null){				this.applyMask(this.dummy);			}		}			 		private function applyBump(index:int, source_bmd:BitmapData, dest_bmd:BitmapData, destrect:Rectangle, normal:Object, CT:ColorTransform, container:Sprite):void		{				/* technotes				applyed formula on each channels				dst (x, y) = ((src (x-1, y-1) * a0 + src(x, y-1) * a1				src(x, y+1) * a7 + src (x+1,y+1) * a8) / divisor) + bias								The filter must be a 3x3 filter.				All the filter terms must be integers between -127 and +127.				The sum of all the filter terms must not have an absolute value greater than 127.				If any filter term is negative, the divisor must be between 2.00001 and 256.				If all filter terms are positive, the divisor must be between 1.1 and 256.				The bias must be an integer.				*/						 if (!this.CF) {								if(index > 0){ 					this.bReUse = true;					this.source_bmd = dest_bmd;					this.dest_bmd = source_bmd;				} else{					this.source_bmd = source_bmd;					this.dest_bmd = dest_bmd;				}				this.tempmap = this.bump_bmd.clone();				this.dummy = this.bump_bmd.clone(); 				this.zeropoint = new Point(0,0);								this.CF = AWConvolutionFilter.instance.createFilter(3, 3, [0,0,0,-1,0,1,0,0,0], 1, 127, true, true, 0, 0);				this.DP = AWDisplacementMapFilter.instance.createFilter(this.dummy, this.zeropoint, 1, 2, -127, -127, "wrap", 0, 0);								if(this.mask_bmd != null && this.bOverlaymask){					this.overlay_bmd = this.source_bmd.clone();					this.inverseMask(this.overlay_bmd);					this.overlayscratch_bmd = new BitmapData(this.overlay_bmd.width, this.overlay_bmd.height, false);					this.overlayalpha_bmd = this.source_bmd.clone();				}				 				if(this.mask_bmd != null && !this.bTotalmask){					 this.applyMask(this.bump_bmd);				}								this.buildbump();								if(this.bAnimate){					MCClassManager.getMCClass("BasicRenderer").addEventListener("RENDER", this.updateBump); 				} else{ 					MCClassManager.getMCClass("BasicRenderer").addEventListener("RENDER", this.updateBumpOnce);					 				}								this.container = container;			}						//area improvement			if(!this._usedrect){				this._usedrect = destrect;			}else{				this._usedrect = this._usedrect.union(destrect);			}									 			 		}		private function updateBumpOnce(e:RenderEvent):void{			this.reDraw();			this._usedrect = source_bmd.rect;			this.dest_bmd = source_bmd;			this.reDraw();			MCClassManager.getMCClass("BasicRenderer").removeEventListener("RENDER", this.updateBumpOnce);		}		private function updateBump(e:RenderEvent):void{			this.reDraw();		}		public function reDraw():void		{			 			try{				this._usedpoint.x = this._usedrect.x;				this._usedpoint.y = this._usedrect.y;				this._usedrect.width +=this._usedrect.x;				this._usedrect.height +=this._usedrect.y;				this._usedrect.x = 0;				this._usedrect.y = 0;								if(this.light_bmd != null){  					this.dest_bmd.applyFilter(this.light_bmd, this._usedrect, this.zeropoint, this.DP);					//this.container.filters = new Array();					//this.container.filters = [this.CF,this.DP];				} else{					this.dest_bmd.applyFilter(this.source_bmd, this._usedrect, this.zeropoint, this.CF);				}								this._usedrect.x = this._usedpoint.x;				this._usedrect.y = this._usedpoint.y;								if(this._mode != ""){					this.dest_bmd.draw(this.source_bmd,null,null,this._mode,this._usedrect, false);				}				 				if(this.bTotalmask){					this.applyMask(this.dest_bmd);				}								if(this.bOverlaymask){					this.overlayalpha_bmd.copyChannel(this.dest_bmd, this._usedrect, this._usedpoint, 8, 1);					this.overlayscratch_bmd.copyPixels(this.dest_bmd,this._usedrect,this._usedpoint, this.dest_bmd,this._usedpoint,false);					this.overlayscratch_bmd.copyPixels(this.overlay_bmd,this._usedrect,this._usedpoint, this.overlay_bmd,this._usedpoint,false);					this.dest_bmd.copyPixels(overlayscratch_bmd,this._usedrect,this._usedpoint, overlayscratch_bmd,this._usedpoint,false);					this.dest_bmd.copyChannel(this.overlayalpha_bmd, this._usedrect, this._usedpoint, 1, 8);				}				//reset used rect				this._usedrect = null;				 				 			} catch(er:Error){				//trace("Bump error:"+er.message);			} 			 		}				public function displacement():DisplacementMapFilter		{		return this.DP;		}		 	}}