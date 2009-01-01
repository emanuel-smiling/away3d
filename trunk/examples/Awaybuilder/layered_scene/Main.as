package{	import awaybuilder.WorldBuilder;	import awaybuilder.collada.ColladaLoader;	import awaybuilder.events.CameraEvent;	import awaybuilder.vo.SceneCameraVO;		import flash.display.Sprite;	import flash.events.Event;	import flash.net.URLRequest;				public class Main extends Sprite	{		protected var top : WorldBuilder ;		protected var bottom : WorldBuilder ;		protected var startCamera : String = "overviewCam" ;						public function Main ( )		{			this.loadBottomLayer ( ) ;		}								protected function loadBottomLayer ( ) : void		{			var loader : ColladaLoader = new ColladaLoader ( ) ;						loader.addEventListener ( Event.COMPLETE , this.bottomLoadComplete ) ;			loader.load ( new URLRequest ( "maya/bottom.dae" ) ) ;		}								protected function bottomLoadComplete ( event : Event ) : void		{			var loader : ColladaLoader = event.target as ColladaLoader ;						this.bottom = new WorldBuilder ( ) ;			this.bottom.data = loader.collada ;			this.bottom.addEventListener ( Event.COMPLETE , this.bottomBuildComplete ) ;			this.addChild ( this.bottom ) ;			this.bottom.x = this.stage.stageWidth * 0.5 ;			this.bottom.y = this.stage.stageHeight * 0.5 ;			this.bottom.build ( ) ;		}								protected function bottomBuildComplete ( event : Event ) : void		{			this.loadTopLayer ( ) ;		}								protected function loadTopLayer ( ) : void		{			var loader : ColladaLoader = new ColladaLoader ( ) ;						loader.addEventListener ( Event.COMPLETE , this.topLoadComplete ) ;			loader.load ( new URLRequest ( "maya/top.dae" ) ) ;		}								protected function topLoadComplete ( event : Event ) : void		{			var loader : ColladaLoader = event.target as ColladaLoader ;						this.top = new WorldBuilder ( ) ;			this.top.data = loader.collada ;			this.top.startCamera = this.startCamera ;			this.top.addEventListener ( Event.COMPLETE , this.topBuildComplete ) ;			this.addChild ( this.top ) ;			this.top.x = this.stage.stageWidth * 0.5 ;			this.top.y = this.stage.stageHeight * 0.5 ;			this.top.build ( ) ;		}								protected function topBuildComplete ( event : Event ) : void		{			var camera : SceneCameraVO = this.top.getCameraById ( this.startCamera ) ;						this.bottom.teleportTo ( camera ) ;			this.top.addEventListener ( CameraEvent.ANIMATION_START , this.animationStart ) ;		}								protected function animationStart ( event : CameraEvent ) : void		{			this.bottom.navigateTo ( event.targetCamera ) ;		}	}}