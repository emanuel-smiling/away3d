package away3dlite.cameras
{
	import away3dlite.arcane;
	import away3dlite.cameras.lenses.*;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	
	import flash.geom.*;
	
	use namespace arcane;
	
	/**
	 * Basic camera used to resolve a view.
	 * 
	 * @see	away3dlite.containers.View3D
	 */
	public class Camera3D extends Object3D
	{
		/** @private */
		arcane var _view:View3D;
		arcane var _lens:AbstractLens;
		/** @private */
		arcane var _invSceneMatrix3D:Matrix3D = new Matrix3D();
		arcane var _projectionMatrix3D:Matrix3D;
		arcane var _screenMatrix3D:Matrix3D = new Matrix3D();
		
		/** @private */
		arcane function update():void
		{
			if (_lensDirty) {
				_lensDirty = false;
				_lens._update();
				_projectionMatrix3D = _lens._projectionMatrix3D;
			}
			
			_invSceneMatrix3D.rawData = _sceneMatrix3D.rawData = transform.matrix3D.rawData;
			_invSceneMatrix3D.invert();
			
			_screenMatrix3D.rawData = _invSceneMatrix3D.rawData;
			_screenMatrix3D.append(_projectionMatrix3D);
		}
		
		private var _focus:Number = 100;
		private var _zoom:Number = 10;
		private var _lensDirty:Boolean;
		
		protected const toRADIANS:Number = Math.PI/180;
		protected const toDEGREES:Number = 180/Math.PI;
		
		public function get projection():PerspectiveProjection
		{
			return root.transform.perspectiveProjection;
		}
		
		/**
		 * Defines the distance from the focal point of the camera to the viewing plane.
		 */
		public function get focus():Number
		{
			return _focus;
		}
		public function set focus(val:Number):void
		{
			_focus = val;
			
			_lensDirty = true;
		}
		
		/**
		 * Defines the overall scale value of the view.
		 */
		public function get zoom():Number
		{
			return _zoom;
		}
		
		public function set zoom(val:Number):void
		{
			_zoom = val;
			
			_lensDirty = true;
		}
		
		/**
		 * Return current ratio
		 */		
		public function get ratio():Number
		{
			return 2*_view.screenWidth/_view.screenHeight;
		}
		
		/**
		 * Return current angle
		 */	
		public function get angle():Number
		{
			return Math.atan2(_view.screenWidth, Math.abs(z));
		}
		
		/**
		 * Returns the 3d matrix representing the camera inverse scene transform for the view.
		 */
		public function get invSceneMatrix3D():Matrix3D
		{
			return _invSceneMatrix3D;
		}
		
		/**
		 * Returns the 3d matrix representing the camera projection for the view.
		 */
		public function get projectionMatrix3D():Matrix3D
		{
			return _projectionMatrix3D;
		}
		
		/**
		 * Returns the 3d matrix used in resolving screen space for the render loop.
		 * 
		 * @see away3dlite.containers.View3D#render()
		 */
		public function get screenMatrix3D():Matrix3D
		{
			return _screenMatrix3D;
		}
		
		/**
		 * Defines the lens used for calculating the <code>projectionMatrix3D/code> of the camera.
		 */
		public function get lens():AbstractLens
		{
			return _lens;
		}
		
		public function set lens(val:AbstractLens):void
		{
			if (_lens == val)
				return;
			
			if (_lens)
				_lens._camera = null;
			
			_lens = val;
			
			if (_lens)
				_lens._camera = this;
			else
				throw new Error("Camera cannot have lens set to null");
			
			_lensDirty = true;
		}
		/**
		 * Creates a new <code>Camera3D</code> object.
		 * 
		 * @param focus		Defines the distance from the focal point of the camera to the viewing plane.
		 * @param zoom		Defines the overall scale value of the view.
		 * @param lens		Defines the lens used for calculating the <code>projectionMatrix3D/code> of the camera.
		 */
		public function Camera3D(zoom:Number = 10, focus:Number = 100, lens:AbstractLens = null)
		{
			super();
			
			this.lens = lens || new ZoomFocusLens();			
			this.zoom = zoom;
			this.focus = focus;
			
			//set default z position
			z = -1000;
			
			//speed up
			mouseEnabled = mouseChildren = false;
		}
	}
}
