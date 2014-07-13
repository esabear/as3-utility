package tw.graphics
{
	import flash.display.Sprite;
	import flash.geom.Point;
		
	/**
	 * 畫arc
	 * @author Bear
	 */
	public class ArcDrawer {
		
		public function ArcDrawer() {
			trace ("ArcDrawer: no need to initialize");
		}
		
		public static function drawArc(target:Sprite, x:Number, y:Number, radius:Number, startAngle:Number = 0, endAngle:Number = 360, steps:uint = 90):void {
			var angleA:Number = toRadian(startAngle);
			var angleB:Number = toRadian(endAngle);
			var startP:Point = getPosition(x, y, radius, angleA);
			var g = target.graphics;
			var segAngle:Number = (angleB - angleA) / steps;
			var currentAngle:Number = angleA;
			
			g.moveTo(startP.x, startP.y);
			
			for (var i:uint = 0; i < steps; i++ ) {
				currentAngle += segAngle;
				var toP:Point = getPosition(x, y, radius, currentAngle);
				g.lineTo(toP.x, toP.y);
			}
		}
		
		public static function getPosition(x:Number, y:Number, radius:Number, radian:Number):Point {
			return new Point (x + Math.cos(radian) * radius, y + Math.sin(radian) * radius);
		}
		
		public static function toRadian(angle:Number):Number {
			return Math.PI * angle / 180;
		}
	}
}