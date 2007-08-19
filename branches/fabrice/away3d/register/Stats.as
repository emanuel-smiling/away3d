﻿package away3d.register{	import flash.ui.ContextMenu;    import flash.ui.ContextMenuItem;    import flash.ui.ContextMenuBuiltInItems;    import flash.events.ContextMenuEvent;	import flash.display.Sprite;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.TextFieldAutoSize;	import flash.display.Stage;	import flash.geom.Matrix;	import flash.geom.Rectangle;	import flash.geom.Point;	import flash.geom.ColorTransform;	import flash.net.*;	import flash.events.*;    import flash.filters.DropShadowFilter;	import flash.display.Loader;	import flash.display.Graphics;	import flash.system.System;	import flash.utils.*;	import fl.motion.Color;	import away3d.register.MCClassManager;	import away3d.register.RenderEvent;		public class Stats extends Sprite	{		public static var instance:Stats=new Stats();		private static var oStats:Object=new Object  ;		private static var totalFaces:int=0;		private static var meshes:int=0;		private static var aTypes:Array = new Array();		private static var contextmenu:ContextMenu;		public static var scopeMenu:Sprite = null;		public static var scopeMenuRegion:Sprite = null;		public static var displayMenu:Sprite = null;		public static var geomMenu:Sprite = null;		public static var stage:Stage;		private static var lastrender:int;		private static var fpsLabel:TextField;		private static var titleField:TextField;		private static var perfLabel:TextField;		private static var ramLabel:TextField;		private static var swfframerateLabel:TextField;		private static var avfpsLabel:TextField;		private static var peakLabel:TextField;		private static var faceLabel:TextField;		private static var faceRenderLabel:TextField;		private static var geomDetailsLabel:TextField;		private static var meshLabel:TextField;		private static var fpstotal:int = 0;		private static var refreshes:int = 0;		private static var bestfps:int = 0;		private static var lowestfps:int = 999;		private static var bar:Sprite;		private static var barwidth:int = 0;		private static var closebtn:Sprite;		private static var cambtn:Sprite;		private static var clearbtn:Sprite;		private static var geombtn:Sprite;		private static var maxminbtn:Sprite;		private static var barscale:int = 0;		private static var stageframerate:Number;		private static var displayState:int;		private static var camLabel:TextField;		private static var camMenu:Sprite;		private static var camProp:Array;		private static var rectclose:Rectangle = new Rectangle(228,4,18,17);		private static var rectcam:Rectangle = new Rectangle(207,4,18,17);		private static var rectclear:Rectangle = new Rectangle(186,4,18,17);		private static var rectdetails:Rectangle = new Rectangle(165,4,18,17);		private static var geomLastAdded:String;		private static var defautTF:TextFormat = new TextFormat("Verdana", 10, 0x000000);		//		private static const VERSION:String = "1";		private static const REVISION:String = "0.0.1";		private static const APPLICATION_NAME:String = "Away3D.com";				function Stats()		{						}				public function generateMenu(scope:Sprite, stage:Stage, stageframerate:Number = 0):void		{			Stats.scopeMenu = scope;			Stats.contextmenu = new ContextMenu();			Stats.stageframerate = (stageframerate == 0)? 30 : stageframerate;			Stats.stage = stage;			Stats.displayState = 0;			var menutitle:String = Stats.APPLICATION_NAME+"\tv" + Stats.VERSION+"."+Stats.REVISION;			var menu:ContextMenuItem = new ContextMenuItem(menutitle, true, true, true);			var menu2:ContextMenuItem = new ContextMenuItem("Away3D Project stats", true, true, true);			var menu3:ContextMenuItem = new ContextMenuItem(" ");			Stats.contextmenu.customItems = [menu2, menu, menu3];			menu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Stats.instance.visiteWebsite);			menu2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Stats.instance.displayStats);			Stats.scopeMenu.contextMenu = Stats.contextmenu;			         }		//Redirect to site		public function visiteWebsite(e:ContextMenuEvent):void 		{			var url:String = "http://www.away3d.com";            	var request:URLRequest = new URLRequest(url);            try {				navigateToURL(request);            } catch (e:Error) {				            }		}		//Displays stats        public function displayStats(e:ContextMenuEvent):void		{			 if(!Stats.displayMenu){				Stats.instance.generateSprite();				Stats.instance.addEventMouse();				Stats.instance.applyShadow();			 }        }				//Closes stats and cleans up a bit...		private function closeStats():void		{ 			Stats.displayState = 0;			MCClassManager.getMCClass("BasicRenderer").removeEventListener("RENDER", Stats.instance.updateFPS);			Stats.scopeMenu.removeEventListener(MouseEvent.MOUSE_DOWN, Stats.instance.onCheckMouse);			Stats.scopeMenu.removeEventListener(MouseEvent.MOUSE_MOVE, Stats.instance.updateTips);			Stats.scopeMenu.removeChild(Stats.displayMenu);			Stats.displayMenu = null;		}				//Mouse Events		private function addEventMouse():void		{  			Stats.scopeMenu.addEventListener(MouseEvent.MOUSE_DOWN, Stats.instance.onCheckMouse);			Stats.scopeMenu.addEventListener(MouseEvent.MOUSE_MOVE, Stats.instance.updateTips);		}				private function updateTips(me:MouseEvent):void		{ 			if(Stats.scopeMenu != null){				var x:Number = Stats.displayMenu.mouseX;				var y:Number = Stats.displayMenu.mouseY;				var pt:Point = new Point(x,y);				try {					if(Stats.rectcam.containsPoint(pt)){						Stats.titleField.text = "CAMERA INFO";					} else if(Stats.rectclose.containsPoint(pt)){						Stats.titleField.text = "CLOSE STATS";					} else if(Stats.rectclear.containsPoint(pt)){						Stats.titleField.text = "CLEAR AVERAGES";					} else if(Stats.rectdetails.containsPoint(pt)){						Stats.titleField.text = "MESH INFO";					} else{						Stats.titleField.text = "AWAY3D PROJECT";					}				} catch (e:Error) {									}			}		}						private function onCheckMouse(me:MouseEvent):void		{ 			var x:Number = Stats.displayMenu.mouseX;			var y:Number = Stats.displayMenu.mouseY;			var pt:Point = new Point(x,y);						if(Stats.rectcam.containsPoint(pt)){				if(Stats.displayState != 1){					Stats.instance.closeOtherScreen(Stats.displayState);					Stats.displayState = 1;					Stats.instance.showCamInfo();				} else{					Stats.displayState = 0;					Stats.instance.hideCamInfo();				}			} else if(Stats.rectdetails.containsPoint(pt)){				if(Stats.displayState != 2){					Stats.instance.closeOtherScreen(Stats.displayState);					Stats.displayState = 2;					Stats.instance.showGeomInfo();				} else{					Stats.displayState = 0;					Stats.instance.hideGeomInfo();				}			} else if(Stats.rectclose.containsPoint(pt)){				Stats.instance.closeStats();			} else if(Stats.rectclear.containsPoint(pt)){				Stats.instance.clearStats();			} else{				Stats.displayMenu.startDrag();				Stats.scopeMenu.addEventListener(MouseEvent.MOUSE_UP, Stats.instance.mouseReleased);			}		}				private function closeOtherScreen(actual:int):void {			 switch(actual){				case 1:				Stats.instance.hideCamInfo();				break;				case 2:				Stats.instance.hideGeomInfo();			 }		}				private function mouseReleased(event:MouseEvent):void {			Stats.displayMenu.stopDrag();			Stats.scopeMenu.removeEventListener(MouseEvent.MOUSE_UP, Stats.instance.mouseReleased);		}				//drawing the stats container		private function generateSprite():void		{  		  			Stats.displayMenu = new Sprite();			var myMatrix:Matrix = new Matrix();    		myMatrix.rotate(90 * Math.PI/180); 			Stats.displayMenu.graphics.beginGradientFill("linear", [0x333366, 0xCCCCCC], [1,1], [0,255], myMatrix, "pad", "rgb", 0);			Stats.displayMenu.graphics.drawRect(0, 0, 250, 86);						Stats.displayMenu.graphics.beginFill(0x333366);			Stats.displayMenu.graphics.drawRect(3, 3, 244, 20);			 			Stats.scopeMenu.addChild(Stats.displayMenu);			 			Stats.displayMenu.x -= Stats.displayMenu.width*.5;			Stats.displayMenu.y -= Stats.displayMenu.height*.5;						// generate closebtn			Stats.closebtn = new Sprite();			Stats.closebtn.graphics.beginFill(0x666666);			Stats.closebtn.graphics.drawRect(0, 0, 18, 17);			var cross = new Sprite();			cross.graphics.beginFill(0xC6D0D8);			cross.graphics.drawRect(2, 7, 14, 4);			cross.graphics.endFill();			cross.graphics.beginFill(0xC6D0D8);			cross.graphics.drawRect(7, 2, 4, 14);			cross.graphics.endFill();			cross.rotation = 45;			cross.x+=9;			cross.y-=4;			Stats.closebtn.addChild(cross);			Stats.displayMenu.addChild(Stats.closebtn);			Stats.closebtn.x = 228;			Stats.closebtn.y = 4;						// generate cam btn			Stats.cambtn = new Sprite();			var cam:Graphics = Stats.cambtn.graphics;			cam.beginFill(0x666666);			cam.drawRect(0, 0, 18, 17);			cam.endFill();			cam.beginFill(0xC6D0D8);			cam.moveTo(10,8);			cam.lineTo(16,4);			cam.lineTo(16,14);			cam.lineTo(10,10);			cam.lineTo(10,8);			cam.drawRect(2, 6, 8, 6);			cam.endFill();			Stats.displayMenu.addChild(Stats.cambtn);			Stats.cambtn.x = 207;			Stats.cambtn.y = 4;						// generate clear btn			Stats.clearbtn = new Sprite();			var clear_btn:Graphics = Stats.clearbtn.graphics;			clear_btn.beginFill(0x666666);			clear_btn.drawRect(0, 0, 18, 17);			clear_btn.endFill();			clear_btn.beginFill(0xC6D0D8);			clear_btn.drawRect(6, 6, 6, 6);			clear_btn.endFill();			Stats.displayMenu.addChild(Stats.clearbtn);			Stats.clearbtn.x = 186;			Stats.clearbtn.y = 4;						// generate geometrie btn			Stats.geombtn = new Sprite();			var geom_btn:Graphics = Stats.geombtn.graphics;			geom_btn.beginFill(0x666666);			geom_btn.drawRect(0, 0, 18, 17);			geom_btn.endFill();			geom_btn.beginFill(0xC6D0D8, 0.7);			geom_btn.moveTo(3,4);			geom_btn.lineTo(11,2);			geom_btn.lineTo(16,5);			geom_btn.lineTo(7,7);			geom_btn.lineTo(3,4);			geom_btn.beginFill(0x7D8489, 0.8);			geom_btn.moveTo(3,4);			geom_btn.lineTo(7,7);			geom_btn.lineTo(7,16);			geom_btn.lineTo(3,12);			geom_btn.lineTo(3,4);			geom_btn.beginFill(0xC6D0D8,1);			geom_btn.moveTo(7,7);			geom_btn.lineTo(16,5);			geom_btn.lineTo(15,13);			geom_btn.lineTo(7,16);			geom_btn.lineTo(7,7);			geom_btn.endFill();			 			geom_btn.endFill();			Stats.displayMenu.addChild(Stats.geombtn);			Stats.geombtn.x = 165;			Stats.geombtn.y = 4;						// generate bar			Stats.displayMenu.graphics.beginGradientFill("linear", [0x000000, 0xFFFFFF], [1,1], [0,255], new Matrix(), "pad", "rgb", 0);			Stats.displayMenu.graphics.drawRect(3, 22, 244, 4);			Stats.displayMenu.graphics.endFill();			Stats.bar = new Sprite();			Stats.bar.graphics.beginFill(0xFFFFFF);			Stats.bar.graphics.drawRect(0, 0, 244, 4);			Stats.displayMenu.addChild(Stats.bar);			Stats.bar.x = 3;			Stats.bar.y = 22;			Stats.barwidth = 244;			Stats.barscale = int(Stats.barwidth/Stats.stageframerate);			// load picto			Stats.instance.loadPicto();						// Generate textfields			// title			Stats.titleField = new TextField();			Stats.titleField.defaultTextFormat = new TextFormat("Verdana", 10, 0xFFFFFF, true, null,null,null,null,"left");			Stats.titleField.text = "AWAY3D PROJECT";			Stats.titleField.height = 20;			Stats.titleField.width = 200;			Stats.titleField.x = 22;			Stats.titleField.y = 4;			Stats.displayMenu.addChild(Stats.titleField);						// fps			var fpst:TextField = new TextField();			fpst.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);			fpst.text = "FPS:";			Stats.fpsLabel = new TextField();			Stats.fpsLabel.defaultTextFormat = Stats.defautTF			Stats.displayMenu.addChild(fpst);			Stats.displayMenu.addChild(Stats.fpsLabel);			fpst.x = 3;			fpst.y = Stats.fpsLabel.y = 30;			fpst.autoSize = "left";			Stats.fpsLabel.x = fpst.x+fpst.width-2;						//average perf			var afpst:TextField = new TextField();			afpst.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);			afpst.text = "AFPS:";			Stats.avfpsLabel = new TextField();			Stats.avfpsLabel.defaultTextFormat = Stats.defautTF			Stats.displayMenu.addChild(afpst);			Stats.displayMenu.addChild(Stats.avfpsLabel);			afpst.x = 52;			afpst.y = Stats.avfpsLabel.y = Stats.fpsLabel.y;			afpst.autoSize = "left";			Stats.avfpsLabel.x = afpst.x+afpst.width-2;						//Max peak			var peakfps:TextField = new TextField();			peakfps.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);			peakfps.text = "Max:";			Stats.peakLabel = new TextField();			Stats.peakLabel.defaultTextFormat = Stats.defautTF			Stats.displayMenu.addChild(peakfps);			Stats.displayMenu.addChild(Stats.peakLabel);			peakfps.x = 107;			peakfps.y = Stats.peakLabel.y = Stats.avfpsLabel.y;			peakfps.autoSize = "left";			Stats.peakLabel.x = peakfps.x+peakfps.width-2;						//MS			var pfps:TextField = new TextField();			pfps.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);			pfps.text = "MS:";			Stats.perfLabel = new TextField();			Stats.perfLabel.defaultTextFormat = Stats.defautTF			Stats.displayMenu.addChild(pfps);			Stats.displayMenu.addChild(Stats.perfLabel);			pfps.x = 177;			pfps.y = Stats.perfLabel.y = Stats.fpsLabel.y;			pfps.autoSize = "left";			Stats.perfLabel.x = pfps.x+pfps.width-2;			 			//ram usage			var ram:TextField = new TextField();			ram.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);			ram.text = "RAM:";			Stats.ramLabel = new TextField();			Stats.ramLabel.defaultTextFormat = Stats.defautTF			Stats.displayMenu.addChild(ram);			Stats.displayMenu.addChild(Stats.ramLabel);			ram.x = 3;			ram.y = Stats.ramLabel.y = 46;			ram.autoSize = "left";			Stats.ramLabel.x = ram.x+ram.width-2;						//meshes count			var meshc:TextField = new TextField();			meshc.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);			meshc.text = "MESHES:";			Stats.meshLabel = new TextField();			Stats.meshLabel.defaultTextFormat = Stats.defautTF			Stats.displayMenu.addChild(meshc);			Stats.displayMenu.addChild(Stats.meshLabel);			meshc.x = 70;			meshc.y = Stats.meshLabel.y = Stats.ramLabel.y;			meshc.autoSize = "left";			Stats.meshLabel.x = meshc.x+meshc.width-2;						//swf framerate			var rate:TextField = new TextField();			rate.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);			rate.text = "SWF FR:";			Stats.swfframerateLabel = new TextField();			Stats.swfframerateLabel.defaultTextFormat = Stats.defautTF			Stats.displayMenu.addChild(rate);			Stats.displayMenu.addChild(Stats.swfframerateLabel);			rate.x = 170;			rate.y = Stats.swfframerateLabel.y = Stats.ramLabel.y;			rate.autoSize = "left";			Stats.swfframerateLabel.x = rate.x+rate.width-2;						//faces			var faces:TextField = new TextField();			faces.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);			faces.text = "FACES:";			Stats.faceLabel = new TextField();			Stats.faceLabel.defaultTextFormat = Stats.defautTF			Stats.displayMenu.addChild(faces);			Stats.displayMenu.addChild(Stats.faceLabel);			faces.x = 3;			faces.y = Stats.faceLabel.y = 62;			faces.autoSize = "left";			Stats.faceLabel.x = faces.x+faces.width-2;						//shown faces			var facesrender:TextField = new TextField();			facesrender.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);			facesrender.text = "RFACES:";			Stats.faceRenderLabel = new TextField();			Stats.faceRenderLabel.defaultTextFormat = Stats.defautTF			Stats.displayMenu.addChild(facesrender);			Stats.displayMenu.addChild(Stats.faceRenderLabel);			facesrender.x = 95;			facesrender.y = Stats.faceRenderLabel.y = Stats.faceLabel.y;			facesrender.autoSize = "left";			Stats.faceRenderLabel.x = facesrender.x+facesrender.width-2;						// ok lets fill some info here			MCClassManager.getMCClass("BasicRenderer").addEventListener("RENDER", Stats.instance.updateFPS); 			 		}				private function updateFPS(e:RenderEvent):void		{			var now:int = getTimer();			var perf:int = now - Stats.lastrender;			Stats.lastrender = now;						if (perf < 1000) {				var fps:int = int(1000 / (perf+0.001));				Stats.fpstotal += fps;				Stats.refreshes ++;				var average:int = fpstotal/refreshes;				Stats.bestfps = (fps>Stats.bestfps)? fps : Stats.bestfps;				Stats.lowestfps = (fps<Stats.lowestfps)? fps : Stats.lowestfps;				var w:int = Stats.barscale*fps;				Stats.bar.width = (w<=Stats.barwidth)? w : Stats.barwidth;			}			//color			var procent:int = (Stats.bar.width/Stats.barwidth)*100;			var colorTransform:ColorTransform = Stats.bar.transform.colorTransform;			colorTransform.color =  255-(2.55*procent) << 16 | 2.55*procent << 8 | 40;			Stats.bar.transform.colorTransform = colorTransform;							if(Stats.displayState == 0){				Stats.avfpsLabel.text = ""+average;				Stats.ramLabel.text = ""+int(System.totalMemory/1024/1024)+"MB";				Stats.peakLabel.text = Stats.lowestfps+"/"+Stats.bestfps;				Stats.fpsLabel.text = "" + fps; 				Stats.perfLabel.text = "" + perf;				Stats.faceLabel.text = ""+Stats.totalFaces;				Stats.faceRenderLabel.text = ""+e.oData.totalfaces;				Stats.meshLabel.text = ""+Stats.meshes;				Stats.swfframerateLabel.text = ""+Stats.stageframerate;			} else if(Stats.displayState == 1){				var caminfo:String = "";				for(var i:int = 0;i<Stats.camProp.length;i++){					if(i>12){						caminfo += String(e.oData.camera[Stats.camProp[i]])+"\n";					}else{						var info:String = String(e.oData.camera[Stats.camProp[i]]);						caminfo += info.substring(0, 19)+"\n";					}				}				Stats.camLabel.text = caminfo;			} else if(Stats.displayState == 2){				Stats.geomDetailsLabel.appendText(Stats.instance.lastRegister);				Stats.geomDetailsLabel.scrollV = Stats.geomDetailsLabel.maxScrollV;			}					}				//clear peaks		private function clearStats():void		{			Stats.fpstotal = 0;			Stats.refreshes = 0;			Stats.bestfps = 0;			Stats.lowestfps = 999;		}				//geometrie info		private function showGeomInfo():void		{			if(Stats.geomMenu == null){				Stats.instance.createGeometrieMenu();			} else{				Stats.displayMenu.addChild(Stats.geomMenu);				Stats.geomMenu.y = 26;			}		}				private function hideGeomInfo():void		{				if(Stats.geomMenu != null){				Stats.displayMenu.removeChild(Stats.geomMenu);			}		}		private function createGeometrieMenu():void{			Stats.geomMenu = new Sprite();			var myMatrix:Matrix = new Matrix();    		myMatrix.rotate(90 * Math.PI/180);			Stats.geomMenu.graphics.beginGradientFill("linear", [0x333366, 0xCCCCCC], [1,1], [0,255], myMatrix, "pad", "rgb", 0);			Stats.geomMenu.graphics.drawRect(0, 0, 250, 200);			Stats.displayMenu.addChild(Stats.geomMenu);			Stats.geomMenu.y = 26;			Stats.geomDetailsLabel = new TextField();			Stats.geomDetailsLabel.x = 3;			Stats.geomDetailsLabel.y = 3;			Stats.geomDetailsLabel.defaultTextFormat = Stats.defautTF			Stats.geomDetailsLabel.text = Stats.instance.stats;			Stats.geomDetailsLabel.height = 200;			Stats.geomDetailsLabel.width = 235;			Stats.geomDetailsLabel.multiline = true;			Stats.geomDetailsLabel.selectable = true;			Stats.geomDetailsLabel.wordWrap = true;			Stats.geomMenu.addChild(Stats.geomDetailsLabel);		}				//cam info		private function showCamInfo():void		{			if(Stats.camMenu == null){				Stats.instance.createCamMenu();			} else{				Stats.displayMenu.addChild(Stats.camMenu);				Stats.camMenu.y = 26;			}		}				private function hideCamInfo():void		{				if(Stats.camMenu != null){				Stats.displayMenu.removeChild(Stats.camMenu);			}		}		// cam info menu		private function createCamMenu():void		{				Stats.camMenu = new Sprite();			var myMatrix:Matrix = new Matrix();    		myMatrix.rotate(90 * Math.PI/180);			Stats.camMenu.graphics.beginGradientFill("linear", [0x333366, 0xCCCCCC], [1,1], [0,255], myMatrix, "pad", "rgb", 0);			Stats.camMenu.graphics.drawRect(0, 0, 250, 220);			Stats.displayMenu.addChild(Stats.camMenu);			Stats.camMenu.y = 26;			Stats.camLabel = new TextField();			Stats.camLabel.height = 210;			Stats.camLabel.width = 170;			Stats.camLabel.x = 100;			Stats.camLabel.multiline = true;			var tf:TextFormat = Stats.defautTF			tf.leading = 1.5;			Stats.camLabel.defaultTextFormat = tf;			Stats.camLabel.wordWrap = true;			Stats.camMenu.addChild(Stats.camLabel);			Stats.camLabel.x = 100;			Stats.camLabel.y = 3;			Stats.camProp = ["x","y","z","zoom","focus","distance","panangle","tiltangle","targetpanangle","targettiltangle","mintiltangle","maxtiltangle","steps","target"];			//props			var campropfield = new TextField();			tf = new TextFormat("Verdana", 10, 0x000000, true);			tf.leading = 1.5;			tf.align = "right";			campropfield.defaultTextFormat = tf;			campropfield.x = campropfield.y = 3;			campropfield.multiline = true;			campropfield.selectable = false;			campropfield.autoSize = "left";			campropfield.height = 210;			for(var i:int = 0;i<Stats.camProp.length;i++){				campropfield.text += Stats.camProp[i]+":\n";			}			Stats.camMenu.addChild(campropfield);		}		//		private function loadPicto():void		{			var ldr:Loader = new Loader();			Stats.instance.confListeners(ldr);			try{				ldr.load(new URLRequest("http://www.away3d.com/awaygraphics/awaylogo_icon.swf"));				Stats.displayMenu.addChild(ldr);				ldr.x = ldr.y = 4;			}catch(e:Error){							}		}		//just to avoid error messages		private function confListeners(dptch:IEventDispatcher):void {            dptch.addEventListener(SecurityErrorEvent.SECURITY_ERROR, Stats.instance.securityErrorHandler);            dptch.addEventListener(HTTPStatusEvent.HTTP_STATUS, Stats.instance.httpStatusHandler);            dptch.addEventListener(IOErrorEvent.IO_ERROR, Stats.instance.ioErrorHandler);        }        private function securityErrorHandler(event:SecurityErrorEvent):void {			//draw picto in class        }        private function httpStatusHandler(event:HTTPStatusEvent):void {			//draw picto in class        }        private function ioErrorHandler(event:IOErrorEvent):void {			//draw picto in class        }				private function applyShadow():void		{			var shadowfilter:DropShadowFilter = new DropShadowFilter(5, 45, 0x000000, 1, 5, 5, 1, 2, false, false, false);			Stats.displayMenu.filters = [shadowfilter];		}		// registration faces and types		public function register(type:String=null,facecount:int=0,url:String=""):void		{			if (type != null && facecount != 0) {				Stats.aTypes.push({type:type,facecount:facecount,url:(url == "")? "internal" : url});				Stats.totalFaces += facecount;				Stats.meshes += 1;			}			Stats.geomLastAdded = " - "+type+" , faces: "+facecount+", url: "+url+"\n";		}		private function get lastRegister():String		{			var last:String = Stats.geomLastAdded;			Stats.geomLastAdded = "";			return last;		}		public function get stats():String		{			var stats:String= "";			for (var i:int = 0;i<Stats.aTypes.length;i++){				stats += " - "+Stats.aTypes[i].type+" , faces: "+Stats.aTypes[i].facecount+", url: "+Stats.aTypes[i].url+"\n";			}			Stats.geomLastAdded = "";			return stats;		}	}}