package tw.gui{
	/**
	* Jones modify  捲軸功能
	* Updated by Bear 2009.01.22
	* 2009.02.12 修增滑鼠滾動
	* 2009.06.05 修正輸入資料結構
	* 2009.07.14 增加上/下移按鈕
	* 2009.09.02 細部修正
	* 2010.10.29 增加跳躍函數jumpTo
	**/
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	public class Scrollbar extends EventDispatcher {
		private var _content:Sprite; // 被捲動的內容
		private var _ruler:Sprite; // 捲軸拉bar按鈕
		private var _background:DisplayObject; // 捲軸背景
		private var _maskmc:Sprite; // 內容遮罩
		private var _area:*; // 滾動作用區
		private var _wheel_scale:Number; // 捲動要乘的倍數
		
		private var _btn_up:Sprite;
		private var _btn_down:Sprite;
		private var _roll_speed:Number; // 按下捲動的速度
		private var _is_rolling_up:Boolean = false;
		private var _is_rolling_down:Boolean = false;
		private var _roll_timer:Timer;
		private var _timer_segment:Number; // 以秒為單位

		private var _enableFilter:Boolean = true;
		private var _atuoDestroy:Boolean = true;
		
		private var minY:Number;
		private var maxY:Number;
		private var content_start_y:Number;
		private var scroll_start_y:Number;
		
		public var percentage:Number = 0;
		public var bf:BlurFilter;

		public function Scrollbar (ruler, background, maskmc, content, area=null, wheelScale=5, atuoDestroy=true) {
			//ruler:捲軸按鈕,background:捲軸,maskmc:遮罩,content:內容,area:偵測面積
			_content = content;
			_ruler = ruler;
			_background = background;
			_maskmc = maskmc;
			_area = area;
			_wheel_scale = wheelScale; // 若設為0就不會動
			_atuoDestroy = atuoDestroy;
			
			super ();
			init ();
		}
		
		//-------------------------------------------------------------------------------------
		
		public function init (e:Event = null):void {

			bf = new BlurFilter(0, 0, 1);
			_content.mask = _maskmc;
			
			if (_ruler is MovieClip) _ruler.buttonMode = true;

			content_start_y = _content.y;
			scroll_start_y = _background.y;
			_ruler.y = scroll_start_y;

			minY = 0;
			maxY = _background.height - _ruler.height;

			_ruler.addEventListener(MouseEvent.MOUSE_DOWN, clickHandle);
			_content.stage.addEventListener(MouseEvent.MOUSE_UP, releaseHandle);
			
			if (_wheel_scale) {
				if (_area != null) _area.addEventListener (MouseEvent.MOUSE_WHEEL, wheelHandle);
				_content.addEventListener (MouseEvent.MOUSE_WHEEL, wheelHandle);
				_ruler.addEventListener (MouseEvent.MOUSE_WHEEL, wheelHandle);
			}
			
			if (_atuoDestroy) {
				_content.addEventListener (Event.REMOVED_FROM_STAGE, destroy);
			}
			
			_content.addEventListener(Event.ENTER_FRAME, enterFrameHandle);
		}
		
		// 設定向上/下按鈕
		public function addButton (btn_up=null, btn_down=null, roll_speed:Number=1, timer_segment:Number=0.05):void {
			_btn_up = btn_up;
			_btn_down = btn_down;
			_roll_speed = roll_speed;
			_timer_segment = timer_segment;
			
			if (_btn_up) {
				if (_btn_up is MovieClip) _btn_up.buttonMode = true;
				_btn_up.addEventListener (MouseEvent.MOUSE_DOWN, pressHandler_up);
			}
			
			if (_btn_down) {
				if (_btn_down is MovieClip) _btn_down.buttonMode = true;
				_btn_down.addEventListener (MouseEvent.MOUSE_DOWN, pressHandler_down);
			}
			
			_roll_timer = new Timer (_timer_segment * 1000, 100);
		}
		
		public function enableFilter (flag:Boolean):void {
			_enableFilter = flag;
		}
		
		public function resetContent ():void {
			_content.y = content_start_y;
			_ruler.y = scroll_start_y;
			
			maxY = _background.height - _ruler.height;
		}
		
		public function jumpTo (percent:Number):void {
			percent = percent < 0 ? 0 : (percent > 1 ? 1 : percent); // 限制在0~1
			_ruler.y = maxY * percent + scroll_start_y + minY;
			_content.addEventListener(Event.ENTER_FRAME, enterFrameHandle);
		}
		
		//-------------------------------------------------------------------------------------
		
		private function clickHandle (e:MouseEvent) {
			
			if (!checkContentLength()) return;
			
			var rect:Rectangle = new Rectangle (_ruler.x, scroll_start_y + minY, 0, maxY);
			_ruler.startDrag (false, rect);//拖移捲軸的範圍
			
			_content.addEventListener(Event.ENTER_FRAME, enterFrameHandle);
		}
		private function releaseHandle (e:MouseEvent) {
			_is_rolling_up = false;
			_is_rolling_down = false;
			
			if (_roll_timer)
				_roll_timer.removeEventListener (TimerEvent.TIMER, timerRollHandler);
			
			_ruler.stopDrag ();
		}
		
		private function wheelHandle (e:MouseEvent) {
			scrollData (e.delta);
		}
		
		//-------------------------------------------------------------------------------------
		
		private function pressHandler_up (e:MouseEvent) {
			scrollData (_roll_speed);
			_is_rolling_up = true;
			
			start_timer ();
		}
		
		private function pressHandler_down (e:MouseEvent) {
			scrollData (-_roll_speed);
			_is_rolling_down = true;
			
			start_timer ();
		}
		
		private function start_timer () {
			if (!_roll_timer) return;
			
			_roll_timer.reset ();
			_roll_timer.start ();
			_roll_timer.addEventListener (TimerEvent.TIMER, timerRollHandler);
		}
		
		private function timerRollHandler (e:TimerEvent) {
			scrollData (_is_rolling_up ? _roll_speed : -_roll_speed);
		}
		
		//-------------------------------------------------------------------------------------
		
		private function enterFrameHandle (e:Event) {
			positionContent ();
		}
		
		//-------------------------------------------------------------------------------------
		
		public function scrollData (q:int) {
			
			if (!checkContentLength()) return;
			
			var d:Number;
			var rulerY:Number;

			d = -q * _wheel_scale;

			if (d > 0) {
				rulerY = Math.min (scroll_start_y + maxY, _ruler.y + d);
			}
			if (d < 0) {
				rulerY = Math.max (scroll_start_y, _ruler.y + d);
			}
			_ruler.y = rulerY;

			positionContent();
			
			_content.addEventListener(Event.ENTER_FRAME, enterFrameHandle);
		}
		
		private function positionContent ():void {
			
			if (!checkContentLength()) return;

			percentage = (100 / maxY) * (_ruler.y - scroll_start_y) * 0.01;

			var finalY:int = content_start_y - percentage * (_content.height-_maskmc.height + 20);
			var curry:int = _content.y;
			
			if (curry == finalY) {
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandle);
				return;
				
			} else {
				var diff:Number = finalY-curry;
				curry += diff * 0.25;

				var bfactor:Number = Math.abs (diff) * 0.125;
				bf.blurY = bfactor * 0.5;
				if (_enableFilter) _content.filters = [bf];
			}
			_content.y = curry >> 0;
			
			this.dispatchEvent (new Event(Event.CHANGE)); // 發送更改位置的訊息

		}
		
		//-------------------------------------------------------------------------------------
		
		private function checkContentLength():Boolean {
			if (!(_ruler is MovieClip)) return true;
			if (_content.height < _maskmc.height) {
				_ruler.buttonMode = false;
				return false;
			} else {
				_ruler.buttonMode = true;
				return true;
			}
		}
		
		// destroy ----------------------------------------------------------------------------
		public function destroy (e=null):void {
			_content.removeEventListener (Event.REMOVED_FROM_STAGE, destroy);
			_content.removeEventListener (Event.ENTER_FRAME, enterFrameHandle);
			
			_ruler.removeEventListener (MouseEvent.MOUSE_DOWN, clickHandle);
			_content.stage.removeEventListener (MouseEvent.MOUSE_UP, releaseHandle);
			
			if (_wheel_scale) {
				if (_area != null) _area.removeEventListener (MouseEvent.MOUSE_WHEEL, wheelHandle);
				_content.removeEventListener (MouseEvent.MOUSE_WHEEL, wheelHandle);
				_ruler.removeEventListener (MouseEvent.MOUSE_WHEEL, wheelHandle);
			}
			
			if (_btn_up) {
				if (_btn_up is MovieClip) _btn_up.buttonMode = false;
				_btn_up.removeEventListener (MouseEvent.MOUSE_DOWN, pressHandler_up);
				_btn_up = null;
			}
			
			if (_btn_down) {
				if (_btn_down is MovieClip) _btn_down.buttonMode = false;
				_btn_down.removeEventListener (MouseEvent.MOUSE_DOWN, pressHandler_down);
				_btn_down = null;
			}
			
			if (_roll_timer) {
				_roll_timer.reset ();
				_roll_timer.removeEventListener (TimerEvent.TIMER, timerRollHandler);
				_roll_timer = null;
			}
			
			_content.filters = [];
			bf = null;
		}
	}
}