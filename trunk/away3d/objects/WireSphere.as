package away3d.objects
{
    import away3d.core.*;
    import away3d.core.math.*;
    import away3d.core.proto.*;
    import away3d.core.geom.*;
    import away3d.core.material.*;
    
    import flash.display.BitmapData;

    public class WireSphere extends Mesh3D
    {
        public var radius:Number = 100;
        public var segmentsW:int = 8;
        public var segmentsH:int = 6;
    
        public function WireSphere(material:IMaterial = null, init:Object = null)
        {
            super(material, init);
    
            if (init != null)
            {
            	radius = init.radius || radius;
            	segmentsW = Math.max(3, init.segmentsW) || segmentsW;
            	segmentsH = Math.max(2, init.segmentsH) || segmentsH;
            }
    
            buildSphere(radius);
        }
    
        private function buildSphere(radius:Number):void
        {
            var i:int;
            var j:int;
            var grid:Array = [];

            for (j = 0; j <= segmentsH; j++)  
            { 
                var horangle:Number = j / segmentsH * Math.PI;
                var z:Number = -radius * Math.cos(horangle);
                var ringradius:Number = radius * Math.sin(horangle);
                var row:Array = [];
                var vertex:Vertex3D;

                for (i = 0; i < segmentsW; i++) 
                { 
                    var verangle:Number = 2 * i / segmentsW;
                    var x:Number = ringradius * Math.sin(verangle*Math.PI);
                    var y:Number = ringradius * Math.cos(verangle*Math.PI);

                    if (((0 < j) && (j < segmentsH)) || (i == 0)) 
                    { 
                        vertex = new Vertex3D(y,z,x);
                        vertices.push(vertex);
                    }
                    row.push(vertex);
                }
                grid.push(row);
            }

            for (j = 1; j <= segmentsH; j++) 
            {
                for (i = 0; i < segmentsW; i++) 
                {
                    var a:Vertex3D = grid[j][i];
                    var b:Vertex3D = grid[j][(i-1+segmentsW) % segmentsW];
                    var c:Vertex3D = grid[j-1][(i-1+segmentsW) % segmentsW];
                    var d:Vertex3D = grid[j-1][i];

                    segments.push(new Segment3D(a, d));
                    segments.push(new Segment3D(b, c));
                    if (j < segmentsH)  
                        segments.push(new Segment3D(a, b));
                    /*
                    if (j < segmentsH)  
                        faces.push(new Face3D(a,b,c, null, uva,uvb,uvc));
                    if (j > 1)                
                        faces.push(new Face3D(a,c,d, null, uva,uvc,uvd));
                    */
                }
            }
        }
    }
}