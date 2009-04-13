package away3d.extrusions;

import away3d.core.utils.ValueObject;
import away3d.core.base.Face;
import away3d.core.base.Mesh;
import away3d.core.utils.Init;
import away3d.core.base.UV;
import away3d.core.base.Vertex;


class SkinExtrude extends Mesh  {
	
	private var varr:Array<Vertex>;
	

	public function new(aPoints:Dynamic, ?init:Dynamic=null) {
		
		
		init = Init.parse(init);
		super(init);
		var subdivision:Int = init.getInt("subdivision", 1, {min:1});
		var scaling:Float = init.getNumber("scaling", 1);
		var coverall:Bool = init.getBoolean("coverall", false);
		var recenter:Bool = init.getBoolean("recenter", false);
		var closepath:Bool = init.getBoolean("closepath", false);
		var flip:Bool = init.getBoolean("flip", false);
		if (Std.is(aPoints[0], Array<Vertex>) && aPoints[0].length > 1) {
			if (closepath && aPoints.length <= 2) {
				closepath = false;
			}
			generate(aPoints, subdivision, scaling, coverall, closepath, flip);
		} else {
			trace("SkinExtrude, at least 2 series of minimum 2 points are required per extrude!");
		}
		if (recenter) {
			applyPosition((this.minX + this.maxX) * .5, (this.minY + this.maxY) * .5, (this.minZ + this.maxZ) * .5);
		} else {
			x = aPoints[0][0].x;
			y = aPoints[0][0].y;
			z = aPoints[0][0].z;
		}
		varr = null;
		type = "SkinExtrude";
		url = "Extrude";
	}

	private function generate(aPoints:Array<Vertex>, ?subdivision:Int=1, ?scaling:Float=1, ?coverall:Bool=false, ?closepath:Bool=false, ?flip:Bool=false):Void {
		
		var uvlength:Int = (closepath) ? aPoints.length : aPoints.length - 1;
		var i:Int = 0;
		while (i < aPoints.length - 1) {
			varr = [];
			extrudePoints(aPoints[i], aPoints[i + 1], subdivision, coverall, (1 / uvlength) * i, uvlength, flip);
			
			// update loop variables
			i++;
		}

		if (closepath) {
			varr = [];
			extrudePoints(aPoints[aPoints.length - 1], aPoints[0], subdivision, coverall, (1 / uvlength) * i, uvlength, flip);
		}
	}

	private function extrudePoints(points1:Array<Vertex>, points2:Array<Vertex>, subdivision:Int, coverall:Bool, vscale:Float, indexv:Int, flip:Bool):Void {
		
		var i:Int;
		var j:Int;
		var stepx:Float;
		var stepy:Float;
		var stepz:Float;
		var uva:UV;
		var uvb:UV;
		var uvc:UV;
		var uvd:UV;
		var va:Vertex;
		var vb:Vertex;
		var vc:Vertex;
		var vd:Vertex;
		var u1:Float;
		var u2:Float;
		var index:Int = 0;
		var bu:Float = 0;
		var bincu:Float = 1 / (points1.length - 1);
		var v1:Float = 0;
		var v2:Float = 0;
		i = 0;
		while (i < points1.length) {
			stepx = (points2[i].x - points1[i].x) / subdivision;
			stepy = (points2[i].y - points1[i].y) / subdivision;
			stepz = (points2[i].z - points1[i].z) / subdivision;
			j = 0;
			while (j < subdivision + 1) {
				varr.push(new Vertex(points1[i].x + (stepx * j), points1[i].y + (stepy * j), points1[i].z + (stepz * j)));
				
				// update loop variables
				j++;
			}

			
			// update loop variables
			++i;
		}

		i = 0;
		while (i < points1.length - 1) {
			u1 = bu;
			bu += bincu;
			u2 = bu;
			j = 0;
			while (j < subdivision) {
				v1 = (coverall) ? vscale + ((j / subdivision) / indexv) : j / subdivision;
				v2 = (coverall) ? vscale + (((j + 1) / subdivision) / indexv) : (j + 1) / subdivision;
				uva = new UV(u1, v1);
				uvb = new UV(u1, v2);
				uvc = new UV(u2, v2);
				uvd = new UV(u2, v1);
				va = varr[index + j];
				vb = varr[(index + j) + 1];
				vc = varr[((index + j) + (subdivision + 2))];
				vd = varr[((index + j) + (subdivision + 1))];
				if (flip) {
					addFace(new Face(va, vb, vc, null, uva, uvb, uvc));
					addFace(new Face(va, vc, vd, null, uva, uvc, uvd));
				} else {
					addFace(new Face(vb, va, vc, null, uvb, uva, uvc));
					addFace(new Face(vc, va, vd, null, uvc, uva, uvd));
				}
				
				// update loop variables
				++j;
			}

			index += subdivision + 1;
			
			// update loop variables
			++i;
		}

	}

}

