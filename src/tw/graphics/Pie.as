package tw.graphics
{
	import flash.display.Sprite;
	
	/**
	 * 畫Pie
	 * @author Bear
	 */
	public class Pie extends Sprite
	{
		public var autoRender:Boolean = false;
		
		private var _radius:Number;
		private var _startAngle:Number;
		private var _endAngle:Number;
		private var _color:uint;
		private var _segment:Number;
		
		public function Pie(radius:Number, startAngle:Number, endAngle:Number, color:uint=0x0, segment:uint=90) {
			_radius = radius;
			_startAngle = startAngle;
			_endAngle = endAngle;
			_color = color;
			_segment = segment;
			
			render();
		}
		
		public function render():void {
			graphics.clear();
			graphics.beginFill(_color);
			ArcDrawer.drawArc(this, 0, 0, _radius, _startAngle, _endAngle, _segment);
			graphics.lineTo(0, 0);
			graphics.endFill();
		}
		
		// setter & getter
		public function set radius(value:Number):void { _radius = value; if(autoRender) render(); }
		public function get radius():Number { return _radius; }
		
		public function set startAngle(value:Number):void { _startAngle = value; if(autoRender) render(); }
		public function get startAngle():Number { return _startAngle; }
		
		public function set endAngle(value:Number):void { _endAngle = value; if(autoRender) render(); }
		public function get endAngle():Number { return _endAngle; }
		
		public function set color(value:uint):void { _color = value; if(autoRender) render(); }
		public function get color():uint { return _color; }
		
		public function set segment(value:uint):void { _segment = value; if(autoRender) render(); }
		public function get segment():uint { return _segment; }
	}
	
}