package tw.pv3d
{
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.core.proto.MaterialObject3D;
	
	public class SmartPlane extends Plane
	{
		public function SmartPlane( material:MaterialObject3D=null, width:Number=0, height:Number=0, segmentsW:Number=0, segmentsH:Number=0 ){
			super(material,width,height,segmentsW,segmentsH);
		}

		public function get width():Number{
			return (geometry.aabb.maxX - geometry.aabb.minX)*scaleX;
		}
		public function get height():Number{
			return (geometry.aabb.maxY - geometry.aabb.minY)*scaleY;
		}
	}
}