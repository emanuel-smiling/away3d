package away3d.cameras.lenses;

import away3d.haxeutils.Error;
import flash.display.Sprite;
import away3d.core.geom.Plane3D;
import flash.events.EventDispatcher;
import away3d.core.math.Matrix3D;
import away3d.core.base.Vertex;
import away3d.core.clip.RectangleClipping;
import away3d.containers.View3D;
import away3d.core.clip.Clipping;
import away3d.core.draw.ScreenVertex;
import away3d.core.base.Object3D;
import away3d.core.geom.Frustum;


class ZoomFocusLens extends AbstractLens, implements ILens {
	
	

	public override function setView(val:View3D):Void {
		
		super.setView(val);
		if (_clipping.minZ == -Math.POSITIVE_INFINITY) {
			_near = _clipping.minZ = -_camera.focus / 2;
		} else {
			_near = _clipping.minZ;
		}
	}

	public function getFrustum(node:Object3D, viewTransform:Matrix3D):Frustum {
		
		_frustum = _cameraVarsStore.createFrustum(node);
		_focusOverZoom = _camera.focus / _camera.zoom;
		_zoom2 = _camera.zoom * _camera.zoom;
		_plane = _frustum.planes[Frustum.NEAR];
		_plane.a = 0;
		_plane.b = 0;
		_plane.c = 1;
		_plane.d = -_near;
		_plane.transform(viewTransform);
		_plane = _frustum.planes[Frustum.FAR];
		_plane.a = 0;
		_plane.b = 0;
		_plane.c = -1;
		_plane.d = _far;
		_plane.transform(viewTransform);
		_plane = _frustum.planes[Frustum.LEFT];
		_plane.a = -_clipHeight * _focusOverZoom;
		_plane.b = 0;
		_plane.c = _clipHeight * _clipLeft / _zoom2;
		_plane.d = _plane.c * _camera.focus;
		_plane.transform(viewTransform);
		_plane = _frustum.planes[Frustum.RIGHT];
		_plane.a = _clipHeight * _focusOverZoom;
		_plane.b = 0;
		_plane.c = -_clipHeight * _clipRight / _zoom2;
		_plane.d = _plane.c * _camera.focus;
		_plane.transform(viewTransform);
		_plane = _frustum.planes[Frustum.TOP];
		_plane.a = 0;
		_plane.b = -_clipWidth * _focusOverZoom;
		_plane.c = _clipWidth * _clipTop / _zoom2;
		_plane.d = _plane.c * _camera.focus;
		_plane.transform(viewTransform);
		_plane = _frustum.planes[Frustum.BOTTOM];
		_plane.a = 0;
		_plane.b = _clipWidth * _focusOverZoom;
		_plane.c = -_clipWidth * _clipBottom / _zoom2;
		_plane.d = _plane.c * _camera.focus;
		_plane.transform(viewTransform);
		return _frustum;
	}

	public function getFOV():Float {
		//calculated from the arctan addition formula arctan(x) + arctan(y) = arctan(x + y / 1 - x*y)
		
		return Math.atan2(_clipTop - _clipBottom, _camera.focus * _camera.zoom + _clipTop * _clipBottom) * AbstractLens.toDEGREES;
	}

	public function getZoom():Float {
		
		return ((_clipTop - _clipBottom) / Math.tan(_camera.fov * AbstractLens.toRADIANS) - _clipTop * _clipBottom) / _camera.focus;
	}

	/**
	 * Projects the vertex to the screen space of the view.
	 */
	public function project(viewTransform:Matrix3D, vertex:Vertex):ScreenVertex {
		
		_screenVertex = _drawPrimitiveStore.createScreenVertex(vertex);
		if (_screenVertex.viewTimer == _camera.view.viewTimer) {
			return _screenVertex;
		}
		_screenVertex.viewTimer = _camera.view.viewTimer;
		_vx = vertex.x;
		_vy = vertex.y;
		_vz = vertex.z;
		
		_sz = _vx * viewTransform.szx + _vy * viewTransform.szy + _vz * viewTransform.szz + viewTransform.tz;
		if (Math.isNaN(_sz)) {
			throw new Error("isNaN(sz)");
		}
		if (_sz < _near && Std.is(_clipping, RectangleClipping)) {
			_screenVertex.visible = false;
			return _screenVertex;
		}
		_persp = _camera.zoom / (1 + _sz / _camera.focus);
		_screenVertex.x = (_screenVertex.vx = (_vx * viewTransform.sxx + _vy * viewTransform.sxy + _vz * viewTransform.sxz + viewTransform.tx)) * _persp;
		_screenVertex.y = (_screenVertex.vy = (_vx * viewTransform.syx + _vy * viewTransform.syy + _vz * viewTransform.syz + viewTransform.ty)) * _persp;
		_screenVertex.z = _sz;
		_screenVertex.visible = true;
		return _screenVertex;
	}

	// autogenerated
	public function new () {
		super();
		
	}

	

}

