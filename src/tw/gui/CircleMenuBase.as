package tw.gui {
	/******************************************************\
	 * 旋轉選單
	 * Author: Bear
	\******************************************************/
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener;
	
	public class CircleMenuBase extends Sprite {
		public var _menus:Array = new Array;
		public var _curSelect:Object = 0;
		public var _index:uint = 0;
		
		private var _center:Point;
		private var _radius:Number;
		private var _timeRotate:Number = 0.5;
		private var _lastAngle:Number = 0;
		private var _hoverFilter:Array = [new GlowFilter(0xFFFFFF,1,2,2,1,BitmapFilterQuality.LOW,false,false)];
		
		// 中心點, 半徑, 選單們
		public function CircleMenuBase (center:Point, radius:Number, menus:Array) {
			_center = center.clone();
			_radius = radius;
			_menus = menus;
			
			initPosition();
			setListener();
		}
		
		public function goto_menu (index:uint):void {
			_index = index % _menus.length;
			_menus[_index].dispatchEvent (new MouseEvent(MouseEvent.CLICK));
		}
		
		public function next ():void {
			goto_menu (_index + 1);
		}

		public function prev ():void {
			goto_menu (_index - 1);
		}
		
		private function initPosition ():void {
			var segAngle:Number = 360 / _menus.length;
			for (var i = 0; i < _menus.length; i++) {
				rotateTarget (_menus[i], segAngle * i);
			}
		}
		
		private function rotateTarget (obj, angle:Number):void {
			obj.rotation = angle;
			obj.x = _center.x - _radius * Math.cos(angle * Math.PI/180);
			obj.y = _center.y - _radius * Math.sin(angle * Math.PI/180);
		}
		
		private function setListener():void {
			for (var i = 0; i < _menus.length; i++) {
				_menus[i].addEventListener(MouseEvent.CLICK, mouseClickHandler);
				_menus[i].addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
				_menus[i].addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			}
		}
		
		public function onStart ():void {
//			for (var i = 0; i < _menus.length; i++)
//				_menus[i].scaleX = _menus[i].scaleY = 1;
		}
		
		private function rePosition ():void {
			for (var i = 0; i < _menus.length; i++) {
				if (_menus[i] != _curSelect)
					rotateTarget (_menus[i], _menus[i].rotation + _curSelect.rotation - _lastAngle);
				else
					rotateTarget (_menus[i], _curSelect.rotation);
			}
			_lastAngle = _curSelect.rotation;
		}
		
		public function onComplete ():void {
//			Tweener.addTween(_curSelect, {x:_curSelect.x-10, scaleX:1.2, scaleY:1.2, time:0.5, transition:"easeOutBack"});
//			Tweener.addTween();
		}
		
		private function mouseClickHandler(e:Object):void {
			Tweener.removeTweens(_curSelect);
			
			_curSelect = e.target;
			_lastAngle = e.target.rotation;
			_index = _menus.indexOf(_curSelect);
			
			Tweener.addTween(e.target, {rotation:0, time:0.5, onStart:onStart, onUpdate:rePosition, onComplete:onComplete});
			this.dispatchEvent (new MouseEvent(MouseEvent.CLICK));
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			e.target.filters = _hoverFilter;
		}

		private function mouseOutHandler(e:MouseEvent):void {
			e.target.filters = [];
		}
	}
}