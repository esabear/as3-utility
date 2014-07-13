package tw.graphics
{
	import flash.events.MouseEvent;
	
	import tw.utils.EventManager;
	import gs.*;
	import gs.easing.*;
	/**
	 * Pie as Menu
	 * @author Bear
	 */
	public class PieMenu
	{
		public var transTime:Number = 0.3;
		public var transEase = Back.easeOut;
		
		private var _pieInfo:PieArray;
		private var _selection:int = -1;
		private var _pieList:Array;
		private var _pieDisplayObject:Array;
		private var _pieDescription:Array;
		private var _startAngle:Number;
		private var _endAngle:Number;
		private var _rollAngle:Number;
		private var _clickAngle:Number;
		private var _radius:Number;
		
		public function PieMenu (startAngle:Number, endAngle:Number, rollAngle:Number, clickAngle:Number, radius:Number, displayList:Array, descriptions:Array=null) {
			_pieDisplayObject = displayList;
			_pieDescription = descriptions;
			_startAngle = startAngle;
			_endAngle = endAngle;
			_rollAngle = rollAngle;
			_clickAngle = clickAngle;
			_radius = radius;
			
			init();
		}
		
		private function init() {
			var numPies = _pieDisplayObject.length;
			
			_pieList = [];
			_pieInfo = new PieArray(numPies, _startAngle, _endAngle);
			
			for (var i:uint = 0; i < numPies; i++) {
				var angle:Object = _pieInfo.getAngle(i);
				var target = _pieDisplayObject[i];
				var pie:Pie = new Pie(_radius, angle.startAngle, angle.endAngle, 0xFFFFFF, 10);
					pie.x = target.x;
					pie.y = target.y;
				//addChild(pie);
				target.mask = pie;
				_pieList.push(pie);
				
				EventManager.add (target, MouseEvent.CLICK, enlarge, [i, true]);
				EventManager.add (target, MouseEvent.ROLL_OVER, enlarge, [i, false]);
				EventManager.add (target, MouseEvent.ROLL_OUT, normal);
			}
		}
		
		public function enlarge (index:uint, select:Boolean = false):void {
			if (index == _selection) return;
			if (select) {
				_selection = index;
				_pieInfo.average ();
				_pieInfo.setAngle(index, _clickAngle, true);
			} else {
				_pieInfo.average ();
				_pieInfo.setAngle(index, _rollAngle, true);
			}
			renderAll ();
		}
		
		public function normal (e=null):void {
			_pieInfo.average ();
			if (_selection != -1)
				_pieInfo.setAngle(_selection, _clickAngle, true);
			renderAll ();
		}
		
		public function renderAll(useTween:Boolean = true):void {
			var numPies:uint = _pieList.length;
			for (var i:uint = 0; i < numPies; i++) {
				var angle:Object = _pieInfo.getAngle(i);
				var pie = _pieList[i];
				
				TweenLite.to (pie, useTween ? transTime : 0, {startAngle:angle.startAngle, endAngle:angle.endAngle, onUpdate:pie.render, ease:transEase});
			}
		}
	}
	
}