﻿package away3d.core.material{	import away3d.core.*;	import away3d.core.math.*;	import away3d.core.proto.*;	import away3d.core.draw.*;	import away3d.core.render.*;	import flash.display.BitmapData;	import flash.geom.Rectangle;	import flash.geom.Matrix;	import flash.geom.ColorTransform;	public interface IGraphics	//extends IMaterial	{	}	public function renderFilledTriangle(dest_bmd:BitmapData,v0:Object,v1:Object,v2:Object,color:Number = 0,clear:Boolean=true):void	{	}	public function renderBitmapTriangle(dest_bmd:BitmapData, v0:Object,v1:Object,v2:Object,source:BitmapData,mat:Matrix,ct:ColorTransform=null,clear:Boolean=true):void	{	}	public function renderLine(dest_bmd:BitmapData,v0,v1,col:Number=0x00):void	{	}}