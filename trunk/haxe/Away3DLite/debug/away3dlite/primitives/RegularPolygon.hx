﻿package away3dlite.primitives;import away3dlite.haxeutils.MathUtils;import away3dlite.core.base.Object3D;import away3dlite.materials.Material;//use namespace arcane;using away3dlite.namespace.Arcane;using away3dlite.haxeutils.HaxeUtils;/*** Creates a regular polygon.*/ class RegularPolygon extends AbstractPrimitive{	private var _radius:Float;	private var _segmentsW:Int;	private var _yUp:Bool;		/**	 * @inheritDoc	 */	private override function buildPrimitive():Void	{		super.buildPrimitive();				var i:Int = 0;				_yUp? _vertices.xyzpush(0, 0, 0) : _vertices.xyzpush(0, 0, 0);		_uvtData.xyzpush(0.5, 0.5, 1);				i = -1;		while (++i < _segmentsW)		{			var verangle:Float = 2*MathUtils.PI*i/_segmentsW;			var x:Float = _radius*Math.cos(verangle);			var y:Float = _radius*Math.sin(verangle);						_yUp? _vertices.xyzpush(x, 0, y) : _vertices.xyzpush(x, y, 0);						_uvtData.xyzpush(0.5 - 0.5*x/_radius, 0.5 + 0.5*y/_radius, 1);		}				i = -1;		while (++i < _segmentsW)		{			_indices.xyzpush(0, i + 1, (i + 1 + _segmentsW) % (_segmentsW) + 1);			_faceLengths.push(3);		}	}	/**	 * Defines the radius of the polygon. Defaults to 100.	 */	public var radius(get_radius, set_radius):Float;	private inline function get_radius():Float	{		return _radius;	}		private function set_radius(val:Float):Float	{		if (_radius == val)			return val;				_radius = val;		_primitiveDirty = true;		return val;	}		/**	 * Defines the number of horizontal segments that make up the cylinder. Defaults to 8.	 */	public var segmentsW(get_segmentsW, set_segmentsW):Int;	private inline function get_segmentsW():Int	{		return _segmentsW;	}		private function set_segmentsW(val:Int):Int	{		if (_segmentsW == val)			return val;				_segmentsW = val;		_primitiveDirty = true;		return val;	}		/**	 * Defines whether the coordinates of the polygon points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.	 */	public var yUp(get_yUp, set_yUp):Bool;	private inline function get_yUp():Bool	{		return _yUp;	}		private function set_yUp(val:Bool):Bool	{		if (_yUp == val)			return val;				_yUp = val;		_primitiveDirty = true;		return val;	}		/**	 * Creates a new <code>RegularPolygon</code> object.	 * 	 * @param	material	Defines the global material used on the faces in the regular polygon.	 * @param	radius		Defines the radius of the regularpolygon base.	 * @param	segmentsW	Defines the number of horizontal segments that make up the regularpolygon.	 * @param	yUp			Defines whether the coordinates of the regularpolygon points use a yUp orientation (true) or a zUp orientation (false).	 */	public function new(?material:Material, ?radius:Float = 100, ?segmentsW:Int = 8, ?yUp:Bool = true)	{		super(material);				_radius = radius;		_segmentsW = segmentsW;		_yUp = yUp;				type = "RegularPolygon";		url = "primitive";	}				/**	 * Duplicates the regularpolygon properties to another <code>RegularPolygon</code> object.	 * 	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>RegularPolygon</code>.	 * @return						The new object instance with duplicated properties applied.	 */	public override function clone(?object:Object3D):Object3D	{		var regularpolygon:RegularPolygon = (object != null) ? (object.downcast(RegularPolygon)) : new RegularPolygon();		super.clone(regularpolygon);		regularpolygon.radius = _radius;		regularpolygon.segmentsW = _segmentsW;		regularpolygon.yUp = _yUp;		regularpolygon._primitiveDirty = false;				return regularpolygon;	}}