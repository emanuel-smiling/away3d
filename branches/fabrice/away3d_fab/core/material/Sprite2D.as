﻿package away3d.core.material{    import away3d.core.*;    import away3d.core.math.*;    import away3d.core.proto.*;    import away3d.core.draw.*;    import away3d.core.render.*;    import flash.display.*;    import flash.geom.*;		import away3d.core.material.*;	     public class Sprite2D implements ITriangleMaterial, IUVMaterial    {        public var source_bmd:BitmapData;		                 public function get width():Number        {            return this.source_bmd.width;        }        public function get height():Number        {            return this.source_bmd.height;        }				public function clear():void        {            this.cleaner.clear();        }                public function Sprite2D(source_bmd:BitmapData,init:Object = null)        {            this.source_bmd = source_bmd;			         }        public function renderTriangle(tri:DrawTriangle, session:RenderSession):void        {			         }        public function get visible():Boolean        {            return true;        }     }}