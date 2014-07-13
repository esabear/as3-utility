package tw.gui {
	/******************************************************\
	 * 旋轉展示效果
	 * Date: 2009.02.19
	 * Update: 2009.03.17 註冊不同的滑鼠事件 存取focusAngle來使用
	 * Author: Bear
	\******************************************************/
	import flash.filters.BlurFilter;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	public class CircleDisplay extends EventDispatcher {
		
		public static const BASE_ANGLE = Math.PI / 2; // 固定加上90度 使0度物件移至最前
		// 初始參數
		private var _objs:Array;
		private var _radiusX:Number;
		private var _radiusY:Number;
		private var _centerX:Number;
		private var _centerY:Number;
		// 角度變數
		private var _curAngle:Number;
		private var _segAngle:Number;
		private var _focusAngle:Number = 0;
		// Tween設定
		private var _transMode = Elastic.easeOut;
		private var _transTween:Tween;
		private var _transTime:Number = 0.5;
		// 深度特效
		private var _blurFilter:BlurFilter;
		private var _maxBlur:Number; // 模糊
		private var _minScale:Number; // 縮放
		private var _minAlpha:Number; // 透明
		private var _fBlur:Boolean = false; // 是否啟用模糊
		private var _fScale:Boolean = false; // 是否啟用縮放
		private var _fAlpha:Boolean = false; // 是否啟用透明
		// 不動物件
		private var _staticObjs:Array = new Array();

		public function CircleDisplay (objs:Array, 
									   rX:Number, rY:Number, 
									   cX:Number, cY:Number) {
			_objs = objs;
			_radiusX = rX;
			_radiusY = rY;
			_centerX = cX;
			_centerY = cY;
			
			init ();
		}
		
		private function init () {
			_curAngle = 0;
			_segAngle = (Math.PI * 2) / _objs.length;
			
			for (var i = 0; i < _objs.length; i++) {
				var angle:Number = _segAngle * i;
				_objs[i].angle = angle;
			}
			reposition ();
		}
		
		public function reposition (shift:Number = 0):void {
			if (!_objs) return;
			
			_curAngle = (_curAngle + shift) % (Math.PI * 2);
			_curAngle = ( Math.abs (_curAngle) < 0.0001 ) ? 0 : _curAngle
			
			for (var i = 0; i < _objs.length; i++) {
				var angle = - _curAngle + _objs[i].angle;
					angle %= Math.PI * 2;
					angle = (angle > Math.PI * 2) ? angle - Math.PI * 2 : ( (angle < 0) ? angle + Math.PI * 2 : angle );
				
				_objs[i].x = _centerX + _radiusX * Math.cos (BASE_ANGLE + angle);// - _objs[i].width/2;
				_objs[i].y = _centerY + _radiusY * Math.sin (BASE_ANGLE + angle);// - _objs[i].height/2;
				_objs[i].z = (angle >= Math.PI) ? Math.PI - (angle % Math.PI) : angle; // 越後面z越大
				//trace (_objs[i].name, _objs[i].angle, angle, _objs[i].z, _curAngle);
			}
			applyDepth ();
		}
		
		private function applyDepth ():void {
			var sortArray:Array = new Array();
			
			for (var i = 0; i < _objs.length; i++)
				sortArray.push (_objs[i]); // 複製一份
				
			for (i = 0; i < _staticObjs.length; i++)
				sortArray.push (_staticObjs[i]); // 靜態物也複製一份
			
			sortArray.sortOn ("z");
		
			for (i = sortArray.length-1; i >= 0; i--) {
				sortArray[i].parent.addChild(sortArray[i]); // 越後面的先加
				if (!sortArray[i].isStatic) {
					var effect:Number = (sortArray[i].z < 0.001) ? 0 : sortArray[i].z / Math.PI;
					//trace (sortArray[i].name, sortArray[i].z, effect);
					if (_fBlur)  applyBlur  ( sortArray[i], effect ); // 越後方影響值越大
					if (_fScale) applyScale ( sortArray[i], effect );
					if (_fAlpha) applyAlpha ( sortArray[i], effect );
				}
				sortArray.pop ();
			}
			sortArray = null;
		}
		
		// 套用深度效果
		private function applyBlur (target, effect:Number):void {
			_blurFilter.blurX = _blurFilter.blurY = effect * _maxBlur;
			target.filters = [_blurFilter];
		}
		private function applyScale (target, effect:Number):void {
			var scale:Number = 1 - effect * (1 - _minScale);
			target.scaleX = target.scaleY = scale;
		}
		private function applyAlpha (target, effect:Number):void {
			var scale:Number = 1 - effect * (1 - _minAlpha);
			target.alpha = scale;
		}
		
		// 在時間(秒)內轉自指定的角度(弧度)
		public function toAngle (angle:Number, time:Number):void {
			if (angle - curAngle > Math.PI) angle -= Math.PI * 2; // 旋轉最小角度
			if (curAngle - angle > Math.PI) angle += Math.PI * 2;
			_transTween = new Tween (this, "curAngle", _transMode, curAngle, angle, time, true);
		}
		
		public function prev ():void {
			toAngle (curAngle - _segAngle, _transTime);
		}
		
		public function next ():void {
			toAngle (curAngle + _segAngle, _transTime);
		}
		
		public function addStaticObj (obj, z:Number = 0.5) {
			obj.z = z * Math.PI;
			obj.isStatic = true;
			_staticObjs.push (obj);
		}
		
		// getter / setter
		public function set zBlur (value:Number):void {
			if (value > 0) {
				_fBlur = true;
				_maxBlur = value;
				if (!_blurFilter) _blurFilter = new BlurFilter ();
			} else {
				_fBlur = false;
			}
		}
		
		public function set zScale (value:Number):void {
			if (value == 1) { _fScale = false; return; }
			_fScale = true;
			_minScale = value;
		}
		
		public function set zAlpha (value:Number):void {
			if (value == 1) { _fAlpha = false; return; }
			_fAlpha = true;
			_minAlpha = value;
		}
		
		public function set objs (ary:Array):void {
			removeObjs ();
			_objs = ary;
			init ();
		}
		
		public function set radiusX (value:Number):void {
			_radiusX = value;
			reposition (); // 重新定位
		}
		public function set radiusY (value:Number):void {
			_radiusY = value;
			reposition (); // 重新定位
		}
		public function set centerX (value:Number):void {
			_centerX = value;
			reposition (); // 重新定位
		}
		public function set centerY (value:Number):void {
			_centerY = value;
			reposition (); // 重新定位
		}
		
		public function get radiusX ():Number {
			return _radiusX;
		}
		public function get radiusY ():Number {
			return _radiusY;
		}
		public function get centerX ():Number {
			return _centerX;
		}
		public function get centerY ():Number {
			return _centerY;
		}
		
		public function set buttonMode (flag:Boolean):void {
			if (!_objs) return;
			for (var i = 0; i < _objs.length; i++)
				_objs[i].buttonMode = flag;
		}
		
		public function set transMode (mode):void {
			_transMode = mode;
		}
		
		public function set transTime (time:Number):void {
			_transTime = Math.abs (time);
		}
		
		public function get transTime ():Number {
			return _transTime;
		}
		
		// 設定目前旋轉角度
		public function set curAngle (angle:Number):void {
			_curAngle = angle;
			reposition (); // 重新定位
		}
		public function get curAngle ():Number {
			return _curAngle;
		}
		public function get segAngle ():Number {
			return _segAngle;
		}
		public function get focusAngle ():Number {
			return _focusAngle;
		}
		
		public function addEventListeners (e=MouseEvent.CLICK):void {
			for (var i = 0; i < _objs.length; i++)
				_objs[i].addEventListener (e, triggerHandler);
		}
		public function removeEventListeners (e=MouseEvent.CLICK):void {
			for (var i = 0; i < _objs.length; i++)
				_objs[i].removeEventListener (e, triggerHandler);
		}
		
		private function triggerHandler (e:MouseEvent):void {
			//toAngle (e.currentTarget.angle, _transTime);
			_focusAngle = e.currentTarget.angle;
			dispatchEvent (new MouseEvent(e.type));
		}
		
		// 解構
		public function destroy ():void {
			removeObjs ();
			_blurFilter = null;
		}
		
		private function removeObjs ():void {
			removeEventListeners ();
			for (var i = _objs.length-1; i >= 0; i--) {
				delete _objs[i].angle;
				delete _objs[i].z;
				_objs[i].filters = [];
				_objs.pop ();
			}
			_objs = null;
		}
	}
}