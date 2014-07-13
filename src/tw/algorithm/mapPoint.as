package tw.algorithm
{
	import flash.geom.Point;
	
	/**
	 * for A* algorithm
	 * @author Bear
	 */
	public class mapPoint 
	{
		public var parent:mapPoint;
		public var point:Point;
		public var depth:uint = 0;
		public var direction:uint = 0;
		public var costToSource:int = 0;
		public var costToTarget:int = 0;
		public var costTotal:int = 0;
		
		public function mapPoint(x:Number, y:Number) {
			point = new Point(x, y);
		}
		
		public function set x(value:Number):void { point.x = value; }
		public function set y(value:Number):void { point.y = value; }
		
		public function get x():Number { return point.x; }
		public function get y():Number { return point.y; }
		
		public function equal(target:mapPoint):Boolean {
			return (x == target.x && y == target.y);
		}
		
		public function toString():String {
			return point.toString() + " costToSource=" + costToSource + " costToTarget=" + costToTarget + " direction=" + direction + " depth=" + depth;
		}
		
		public function destroy(e:*= null):void {
			point = null;
			parent = null;
		}
	}
	
}