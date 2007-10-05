﻿package away3d.core.material{		import away3d.core.*;    import away3d.core.math.*;    import away3d.core.scene.*;    import away3d.core.draw.*;    import away3d.core.render.*;    import away3d.core.utils.*;    import flash.display.*;    import flash.geom.*;	import away3d.core.material.*;		import away3d.core.mesh.Vertex;		import away3d.register.AWClassManager;    public class EnviroMaterial implements ITriangleMaterial, IUVMaterial, IAverage, IPhongLight     {        public var bitmap:BitmapData;		public var enviromap:BitmapData;		public var fxbitmap:BitmapData;		public var rect:Rectangle;        public var smooth:Boolean;        public var debug:Boolean;        public var repeat:Boolean;		public var light:String;		public var aFX:Array;		public var mySprite:Sprite;				private var eTri0x:Number;		private var eTri0y:Number;		private var eTri1x:Number;		private var eTri1y:Number;		private var eTri2x:Number;		private var eTri2y:Number;				internal var mapping:Matrix;		internal var normalmapping:Matrix = new Matrix();		private var halfW:Number;		private var halfH:Number;		 		public function get average():Boolean        {            return true;        }				public function get phonglight():Boolean        {            return true;        }                public function get width():Number        {            return bitmap.width;        }				        public function get height():Number        {            return bitmap.height;        }		        public function EnviroMaterial( enviromap:BitmapData, bitmap:BitmapData = null, init:Object = null, afx:Array = null)        {			this.enviromap = enviromap;			if(bitmap != null){				this.bitmap = bitmap;			}            init = Init.parse(init);            smooth = init.getBoolean("smooth", false);            debug = init.getBoolean("debug", false);            //repeat = init.getBoolean("repeat", false);			//light = init.getString("light", "");			if(afx != null){				this.fxbitmap = bitmap.clone();				this.rect = new Rectangle(0,0,1,1);				this.aFX = new Array();				this.aFX = afx.concat();			}						if(AWClassManager.getClass("GLOBALLIGHT") == null){				new GlobalLight();			}						halfW = (width * .5);			halfH = (height * .5);			         }        public function renderTriangle(tri:DrawTriangle, session:RenderSession):void        {			var mapping:Matrix = tri.texturemapping || tri.transformUV(this);			 			 			var i:int;			//in case we need to render as double face			if(this.bitmap != null){				var source:BitmapData = this.bitmap; 				//fx				if(this.aFX != null){					source = this.fxbitmap;					if(normal == null){						normal = AmbientLight.getNormal([tri.v0, tri.v1, tri.v2]);					}										var CT:ColorTransform;					if(tri.uvrect == null){						tri.transformUV(this);					}					for(i = 0;i<this.aFX.length;i++){ 							this.aFX[i].apply(i,this.bitmap, source, tri.uvrect, normal, CT, mySprite); 					}				}				session.renderTriangleBitmap(source, mapping, tri.v0, tri.v1, tri.v2, false, false, session.graphics);			}			var normal:Object = null;			 			var onorm:Object = new Object;			var norm:Number3D;						var facenorm:Number3D;			var average:Array;			var xnorm:Number;			var ynorm:Number;			var znorm:Number;						/*			try{				onorm.norm1 = tri.face.neighbour01.normal;				//onorm.norm1.x = (onorm.norm1.x+tri.face.normal.x)/2;				//onorm.norm1.y = (onorm.norm1.y+tri.face.normal.y)/2;				//onorm.norm1.z = (onorm.norm1.z+tri.face.normal.z)/2;			} catch(e:Error){				onorm.norm1 = new Number3D(0.33,0.33,0.33);			}			try{				onorm.norm2 = tri.face.neighbour12.normal;				//onorm.norm2.x = (onorm.norm2.x+tri.face.normal.x)/2;				//onorm.norm2.y = (onorm.norm2.y+tri.face.normal.y)/2;				//onorm.norm2.z = (onorm.norm2.z+tri.face.normal.z)/2;							} catch(e:Error){				onorm.norm2 = new Number3D(0.33,0.33,0.33);			}			try{				onorm.norm3 = tri.face.neighbour20.normal;				//onorm.norm3.x = (onorm.norm3.x+tri.face.normal.x)/2;				//onorm.norm3.y = (onorm.norm3.y+tri.face.normal.y)/2;				//onorm.norm3.z = (onorm.norm3.z+tri.face.normal.z)/2;			} catch(e:Error){				onorm.norm3 = new Number3D(0.33,0.33,0.33);			}			 */						// lets rock and roll!			for(var j:int = 1;j<4;j++){				try{										xnorm = 0;					ynorm = 0;					znorm = 0;					average = tri.face["average0"+j];										for(i = 0;i< average.length;i++){												facenorm = average[i].normal;						xnorm += facenorm.x;						ynorm += facenorm.y;						znorm += facenorm.z;					}										onorm["norm"+j] = new Number3D(xnorm/average.length, ynorm/average.length, znorm/average.length);									} catch(e:Error){					onorm["norm"+j] = new Number3D(0.33,0.33,0.33);				}			}						//translate normals to uv 2D projection			/*			eTri0x =  width * ((onorm.norm1.x*.5) + .5);			eTri0y =  height * (1 - ((-(onorm.norm1.y)*.5) + .5));			eTri1x =  width * ((onorm.norm2.x*.5) + .5);			eTri1y =  height * (1 - ((-(onorm.norm2.y)*.5) + .5));			eTri2x =  width * ((onorm.norm3.x*.5) + .5);			eTri2y =  height * (1 - ((-(onorm.norm3.y)*.5) + .5));			*/			eTri0x =  (halfW * onorm.norm1.x) + halfW;			eTri0y =  (halfH * onorm.norm1.y) + halfH;			eTri1x =  (halfW *  onorm.norm2.x) + halfW;			eTri1y =  (halfH * onorm.norm2.y) + halfH;			eTri2x =  (halfW *  onorm.norm3.x) + halfW;			eTri2y =  (halfH * onorm.norm3.y) + halfH;						normalmapping.a=eTri1x - eTri0x;			normalmapping.b=eTri1y - eTri0y;			normalmapping.c=eTri2x - eTri0x;			normalmapping.d=eTri2y - eTri0y;			normalmapping.tx=eTri0x;			normalmapping.ty=eTri0y;			            normalmapping.invert();            			session.renderTriangleBitmap(this.enviromap, normalmapping, tri.v0, tri.v1, tri.v2, false, false, session.graphics2);						var offsetX:Number;			var offsetY:Number;			var oOffsets:Number2D  = tri.face.source._offset;			// hier we substract what we didn't know before : the offset according to bitmap source scale			offsetX = oOffsets.x-halfW;			offsetY = oOffsets.y-halfH;						eTri0x += offsetX;			eTri0y += offsetY;			eTri1x += offsetX;			eTri1y += offsetY;			eTri2x += offsetX;			eTri2y += offsetY;			/// beter update class var than new matrix 			normalmapping.a=eTri1x - eTri0x;			normalmapping.b=eTri1y - eTri0y;			normalmapping.c=eTri2x - eTri0x;			normalmapping.d=eTri2y - eTri0y;			normalmapping.tx=eTri0x;			normalmapping.ty=eTri0y;			            normalmapping.invert();									session.renderTriangleBitmap(AWClassManager.getClass("GLOBALLIGHT").source, normalmapping, tri.v0, tri.v1, tri.v2, false, false, session.graphics3);			session.sprite3.blendMode = BlendMode.OVERLAY;			 						//debug = true;			if (debug){               session.renderTriangleLine(2, 0x8800FF, 1, tri.v0, tri.v1, tri.v2);			   			}        }		          public function get visible():Boolean        {            return true;        }     }}