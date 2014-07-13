package tw.graphics
{
	import flash.events.Event;
	import gs.*;
	import gs.easing.*;
	
	/**
	 * Pie Array
	 * @author Bear
	 */
	public class PieArray 
	{
		private var _startAngleArray:Array;
		private var _endAngleArray:Array;
		private var _startAngle:Number;
		private var _endAngle:Number;
		private var _numPies:uint;
		
		public function PieArray(length:uint, startAngle:Number, endAngle:Number) {
			_numPies = length;
			_startAngle = startAngle;
			_endAngle = endAngle;
			
			average();
		}
		
		public function average():Number {
			_startAngleArray = [];
			_endAngleArray = [];
			
			var segAngle:Number = (_endAngle - _startAngle) / _numPies;
			
			for (var i:uint = 0; i < _numPies; i++) {
				var startAngle = _startAngle + segAngle * i;
				_startAngleArray.push(startAngle);
				_endAngleArray.push(startAngle + segAngle);
			}
			
			return segAngle;
		}
		
		public function getAngle(index:uint):Object {
			return {startAngle:_startAngleArray[index], endAngle:_endAngleArray[index]};
		}
		
		public function setAngle(index:uint, toAngle:Number, spread:Boolean = true):void {
			var originalAngle:Number = _endAngleArray[index] - _startAngleArray[index];
			var segAngle:Number = (toAngle - originalAngle) / (_numPies - 1);
			
			var i:uint;
			var originalSeg:Number;
			var toSeg:Number;
			
			if (spread) {
				for (i = 0; i < _numPies; i++) {
					originalSeg = _endAngleArray[i] - _startAngleArray[i];
					toSeg = originalSeg - segAngle;
					
					_startAngleArray[i] = (i == 0) ? _startAngle : _endAngleArray[i - 1];
					
					if (i != index) {
						_endAngleArray[i] = _startAngleArray[i] + toSeg;
					} else {
						_endAngleArray[i] = _startAngleArray[i] + toAngle;
					}
				}
			} else {
				for (i = 0; i < _numPies; i++) {
					originalSeg = _endAngleArray[i] - _startAngleArray[i];
					toSeg = originalSeg - segAngle;
					
					_startAngleArray[i] = i == 0 ? _startAngle : _startAngleArray[i - 1];
					
					if (i != index) {
						_endAngleArray[i] = _startAngleArray[i] + toSeg;
					} else {
						_endAngleArray[i] = _startAngleArray[i] + toAngle;
					}
				}
			}
		}
		
		public function get info():Object {
			return {startAngles:_startAngleArray.concat(), endAngles:_endAngleArray.concat()};
		}
		
		public function set info(value:Object):void {
			_startAngleArray = value.startAngles.concat();
			_endAngleArray = value.endAngles.concat();
		}
		
		public function destroy(e:*= null):void {
		}
	}
	
}