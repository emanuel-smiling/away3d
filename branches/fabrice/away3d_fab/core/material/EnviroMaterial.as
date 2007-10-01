﻿package away3d.core.material{		import away3d.core.*;    import away3d.core.math.*;    import away3d.core.scene.*;    import away3d.core.draw.*;    import away3d.core.render.*;    import away3d.core.utils.*;    import flash.display.*;    import flash.geom.*;	import away3d.core.material.*;		import away3d.core.mesh.Vertex;    public class EnviroMaterial implements ITriangleMaterial, IUVMaterial, IAverage    {        public var bitmap:BitmapData;		public var enviromap:BitmapData;		public var fxbitmap:BitmapData;		public var rect:Rectangle;        public var smooth:Boolean;        public var debug:Boolean;        public var repeat:Boolean;		public var light:String;		public var aFX:Array;		public var mySprite:Sprite;				private var eTri0x:Number;		private var eTri0y:Number;		private var eTri1x:Number;		private var eTri1y:Number;		private var eTri2x:Number;		private var eTri2y:Number;				internal var mapping:Matrix;				public function get average():Boolean        {            return true;        }                public function get width():Number        {            return bitmap.width;        }				        public function get height():Number        {            return bitmap.height;        }				public function get ewidth():Number        {            return enviromap.width;        }        public function get eheight():Number        {            return enviromap.height;        }                public function EnviroMaterial( enviromap:BitmapData, bitmap:BitmapData = null, init:Object = null, afx:Array = null)        {            						this.enviromap = enviromap;			if(bitmap != null){				this.bitmap = bitmap;			}            init = Init.parse(init);            smooth = init.getBoolean("smooth", false);            debug = init.getBoolean("debug", false);            repeat = init.getBoolean("repeat", false);			light = init.getString("light", "");			if(afx != null){				this.fxbitmap = bitmap.clone();				this.rect = new Rectangle(0,0,1,1);				this.aFX = new Array();				this.aFX = afx.concat();			}			         }        public function renderTriangle(tri:DrawTriangle, session:RenderSession):void        {			var mapping:Matrix = tri.texturemapping || tri.transformUV(this);			 			 			var i:int;			//in case we need to render as double face			if(this.bitmap != null){				var source:BitmapData = this.bitmap; 				//fx				if(this.aFX != null){					source = this.fxbitmap;					if(normal == null){						normal = AmbientLight.getNormal([tri.v0, tri.v1, tri.v2]);					}										var CT:ColorTransform;					if(tri.uvrect == null){						tri.transformUV(this);					}					for(i = 0;i<this.aFX.length;i++){ 							this.aFX[i].apply(i,this.bitmap, source, tri.uvrect, normal, CT, mySprite); 					}				}				session.renderTriangleBitmap(source, mapping, tri.v0, tri.v1, tri.v2, false, false, session.graphics);			}			var normal:Object = null;			 			var onorm:Object = new Object;			var norm:Number3D;						var facenorm:Number3D;			var average:Array;			var xnorm:Number;			var ynorm:Number;			var znorm:Number;			 			// lets rock and roll!			for(var j:int = 1;j<4;j++){				try{										xnorm = 0;					ynorm = 0;					znorm = 0;					average = tri.face["average0"+j];										for(i = 0;i< average.length;i++){												facenorm = average[i].normal;						xnorm += facenorm.x;						ynorm += facenorm.y;						znorm += facenorm.z;					}										onorm["norm"+j] = new Number3D(xnorm/average.length, ynorm/average.length, znorm/average.length);									} catch(e:Error){					onorm["norm"+j] = new Number3D(0.33,0.33,0.33);				}						}						//directional offsets						var offsetX = width;			var offsetY = height;						//translate normals to uv 2D projection			eTri0x =  width * ((onorm.norm1.x*.5) + .5);			eTri0y =  height * (1 - ((-(onorm.norm1.y)*.5) + .5));			eTri1x =  width * ((onorm.norm2.x*.5) + .5);			eTri1y =  height * (1 - ((-(onorm.norm2.y)*.5) + .5));			eTri2x =  width * ((onorm.norm3.x*.5) + .5);			eTri2y =  height * (1 - ((-(onorm.norm3.y)*.5) + .5));						var normalmapping:Matrix = new Matrix(eTri1x - eTri0x, eTri1y - eTri0y, eTri2x - eTri0x, eTri2y - eTri0y, eTri0x, eTri0y);            normalmapping.invert();            			session.renderTriangleBitmap(this.enviromap, normalmapping, tri.v0, tri.v1, tri.v2, false, false, session.graphics2);			 						//debug = true;			if (debug){               session.renderTriangleLine(2, 0x8800FF, 1, tri.v0, tri.v1, tri.v2);			   			}        }		          public function get visible():Boolean        {            return true;        }     }}