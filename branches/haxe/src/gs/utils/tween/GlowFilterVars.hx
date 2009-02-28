package gs.utils.tween;



class GlowFilterVars extends FilterVars  {
	public var blurX(getBlurX, setBlurX) : Float;
	public var blurY(getBlurY, setBlurY) : Float;
	public var color(getColor, setColor) : Int;
	public var alpha(getAlpha, setAlpha) : Float;
	public var strength(getStrength, setStrength) : Float;
	public var inner(getInner, setInner) : Bool;
	public var knockout(getKnockout, setKnockout) : Bool;
	public var quality(getQuality, setQuality) : Int;
	
	private var _blurX:Float;
	private var _blurY:Float;
	private var _color:Int;
	private var _alpha:Float;
	private var _strength:Float;
	private var _inner:Bool;
	private var _knockout:Bool;
	private var _quality:Int;
	

	public function new(?$blurX:Float=10, ?$blurY:Float=10, ?$color:Int=0xFFFFFF, ?$alpha:Float=1, ?$strength:Float=2, ?$inner:Bool=false, ?$knockout:Bool=false, ?$quality:Int=2, ?$remove:Bool=false, ?$index:Int=-1, ?$addFilter:Bool=false) {
		
		
		super($remove, $index, $addFilter);
		this.blurX = $blurX;
		this.blurY = $blurY;
		this.color = $color;
		this.alpha = $alpha;
		this.strength = $strength;
		this.inner = $inner;
		this.knockout = $knockout;
		this.quality = $quality;
	}

	//for parsing values that are passed in as generic Objects, like blurFilter:{blurX:5, blurY:3} (typically via the constructor)
	public static function createFromGeneric($vars:Dynamic):GlowFilterVars {
		
		if (Std.is($vars, GlowFilterVars)) {
			return cast($vars, GlowFilterVars);
		}
		return new GlowFilterVars(($vars.blurX > 0) ? $vars.blurX : 0, ($vars.blurY > 0) ? $vars.blurY : 0, ($vars.color == null) ? 0x000000 : $vars.color, ($vars.alpha > 0) ? $vars.alpha : 0, ($vars.strength == null) ? 2 : $vars.strength, Boolean($vars.inner), Boolean($vars.knockout), ($vars.quality > 0) ? $vars.quality : 2, $vars.remove || false, ($vars.index == null) ? -1 : $vars.index, $vars.addFilter || false);
	}

	//---- GETTERS / SETTERS -------------------------------------------------------------------------------------
	public function setBlurX($n:Float):Float {
		
		_blurX = this.exposedVars.blurX = $n;
		return $n;
	}

	public function getBlurX():Float {
		
		return _blurX;
	}

	public function setBlurY($n:Float):Float {
		
		_blurY = this.exposedVars.blurY = $n;
		return $n;
	}

	public function getBlurY():Float {
		
		return _blurY;
	}

	public function setColor($n:Int):Int {
		
		_color = this.exposedVars.color = $n;
		return $n;
	}

	public function getColor():Int {
		
		return _color;
	}

	public function setAlpha($n:Float):Float {
		
		_alpha = this.exposedVars.alpha = $n;
		return $n;
	}

	public function getAlpha():Float {
		
		return _alpha;
	}

	public function setStrength($n:Float):Float {
		
		_strength = this.exposedVars.strength = $n;
		return $n;
	}

	public function getStrength():Float {
		
		return _strength;
	}

	public function setInner($b:Bool):Bool {
		
		_inner = this.exposedVars.inner = $b;
		return $b;
	}

	public function getInner():Bool {
		
		return _inner;
	}

	public function setKnockout($b:Bool):Bool {
		
		_knockout = this.exposedVars.knockout = $b;
		return $b;
	}

	public function getKnockout():Bool {
		
		return _knockout;
	}

	public function setQuality($n:Int):Int {
		
		_quality = this.exposedVars.quality = $n;
		return $n;
	}

	public function getQuality():Int {
		
		return _quality;
	}

}

