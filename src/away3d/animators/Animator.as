﻿package away3d.animators{	import away3d.core.base.*;		import flash.utils.Dictionary;	public class Animator extends Mesh	{		private var varr:Array = [];		private var uvarr:Array = [];		private var fnarr:Array = [];		 		private function getVertIndex(face:Face):Array		{			var a:int = 0;			var b:int = 0;			var c:int = 0;						for(var i:int = 0;i<varr.length;i++){				a = (varr[i] == face.v0)? i : a;				b = (varr[i] == face.v1)? i : b;				c = (varr[i] == face.v2)? i : c;				if(a!=0 && b!= 0 && c != 0) break;			}			return [a, b, c];		}		//Array aFrames properties: vertices:Array[vertex.x,y and z positions], prefix:String		public function generate(baseObject:Mesh, aFrames:Array, doloop:Boolean):void		{			var i:int ;			var j:int ;			var k:int ;						// export requirement			indexes = [];			var aVti:Array;						if(doloop){				var fr:Object = {};				fr["vertices"] = aFrames[0].vertices;				fr["prefix"] = aFrames[0].prefix;				var pref:String = "";				for(i=0; i<fr["prefix"].length;i++){					if(isNaN(fr["prefix"].substring(i,i+1)) ){						pref += fr.["prefix"].substring(i,i+1);					} else{						break;					}				}				fr["prefix"] = pref+(aFrames.length+1);				aFrames.push(fr);			}						var face:Face;			varr = varr.concat(baseObject.geometry.vertices);						for(i=0;i<baseObject.faces.length;i++){				face = baseObject.faces[i];				uvarr.push(face.uv0, face.uv1, face.uv2);				addFace(face);				aVti = getVertIndex(face);				indexes.push([aVti[0],aVti[1],aVti[2],uvarr.length-3,uvarr.length-2,uvarr.length-1]);            }			 			geometry.frames = new Dictionary();			geometry.framenames = new Dictionary();			fnarr = [];			var oFrames:Object = {};			var arr:Array;						for(i=0;i<aFrames.length;i++){				oFrames[aFrames[i].prefix]=[];				fnarr.push(aFrames[i].prefix);				 arr = aFrames[i].vertices;				 for(j=0;j<arr.length;j++){					 oFrames[aFrames[i].prefix].push(arr[j], arr[j], arr[j]); 				 }							} 						var frame:Frame;			for(i = 0;i<fnarr.length; i++){				trace("[ "+fnarr[i]+" ]");				frame = new Frame();				geometry.framenames[fnarr[i]] = i;				geometry.frames[i] = frame;				k=0;				 for (j = 0; j < oFrames[fnarr[i]].length; j+=3){					var vp:VertexPosition = new VertexPosition(varr[k]);					k++;						vp.x = oFrames[fnarr[i]][j].x;						vp.y = oFrames[fnarr[i]][j+1].y;						vp.z = oFrames[fnarr[i]][j+2].z;						frame.vertexpositions.push(vp);				}  								if (i == 0)					frame.adjust();			}					}				public function get framelist():Array		{			return fnarr;		}				/**		* Add new frames to the object at runtime		* 		* @paramaFrames				A multidimentional array with vertices references  [{vertices:object3d1.vertices, prefix:"frame1"}, {vertices:object3d2.vertices, prefix:"frame2"}]		* 		*/		public function addFrames(aFrames:Array):void		{			var i:int ;			var j:int ;			var k:int ;			var oFrames:Object = {};			var arr:Array;						for(i=0;i<aFrames.length;i++){				oFrames[aFrames[i].prefix]=[];				fnarr.push(aFrames[i].prefix);				arr = aFrames[i].vertices;				for(j=0;j<arr.length;j++){					oFrames[aFrames[i].prefix].push(arr[j], arr[j], arr[j]); 				}			} 			var frame:Frame;			for(i = 0;i<fnarr.length; i++){				trace("[ "+fnarr[i]+" ]");				frame = new Frame();				geometry.framenames[fnarr[i]] = i;				geometry.frames[i] = frame;				k=0;				 for (j = 0; j < oFrames[fnarr[i]].length; j+=3){					var vp:VertexPosition = new VertexPosition(varr[k]);					k++;						vp.x = oFrames[fnarr[i]][j].x;						vp.y = oFrames[fnarr[i]][j+1].y;						vp.z = oFrames[fnarr[i]][j+2].z;						frame.vertexpositions.push(vp);				}  								if (i == 0)					frame.adjust();			}					}				/**		 * Creates a new <code>Animator</code> object.		 * 		 * @param	baseObject			The Mesh to be used as reference		 * @paramaFrames				A multidimentional array with vertices references  [{vertices:object3d1.vertices, prefix:"frame1"}, {vertices:object3d2.vertices, prefix:"frame2"}]		 * @param	init	[optional]	An initialisation object for specifying default instance properties.		 * @param	doloop	[optional]	If the geometry needs to be shown in a loop		 * 		 */		public function Animator(baseObject:Mesh, aFrames:Array, init:Object = null, doloop:Boolean = false)		{			super(init);			generate(baseObject, aFrames, doloop);						type = "Animator";        	url = "Mesh";					}				/**		 * Scales the vertex positions contained within all animation frames		 * 		 * @param	scale	The scaling value		 */		public function scaleAnimation(scale:Number):void		{			var tmpnames:Array = [];			var i:int = 0;			var y:int = 0;			for (var framename:String in geometry.framenames){				tmpnames.push(framename);			}							var fr:Frame;			for (i = 0;i<tmpnames.length;i++){				fr = geometry.frames[geometry.framenames[tmpnames[i]]];				for(y = 0; y<fr.vertexpositions.length ;y++){					fr.vertexpositions[y].x *= scale;					fr.vertexpositions[y].y *= scale;					fr.vertexpositions[y].z *= scale;				}			}						}	}}