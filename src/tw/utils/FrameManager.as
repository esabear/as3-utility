package tw.utils {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2009/07/16
	 * 穿透力FrameManager模組
	 * 管理影格速度, 使速率達到最佳
	\*************************************************************************/
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FrameManager {
		
		public static var low:uint;
		public static var high:uint;
		
		private static var _stage:Stage;
		private static var _mouseMove:Boolean = false;
		private static var _mouseLeave:Boolean = false;
		
		public function FrameManager () {
			trace ("FrameManager : 不需要被初始化");
		}
		
		public static function setup ($stage:Stage, $low:uint=5, $high:uint=0, $autoActivate:Boolean=true):void {
			_stage = $stage;
			low = $low;
			high = $high == 0 ? $stage.frameRate : $high;
			
			if ($autoActivate) activate ();
		}
		
		public static function activate ():void {
			if (_stage) {
				highFrame ();
			} else { trace ("FrameManager : 未執行setup函式"); return; }
		}
		
		public static function enableMouse (mouseMove:Boolean=true, mouseLeave:Boolean=false):void {
			_mouseMove = mouseMove;
			_mouseLeave = mouseLeave;
			
			if (_mouseMove) {
				//_stage.addEventListener (MouseEvent.MOUSE_MOVE, FrameManager.highFrame);
			} else 
				_stage.removeEventListener (MouseEvent.MOUSE_MOVE, FrameManager.highFrame);
			
			if (_mouseLeave)
				_stage.addEventListener (Event.MOUSE_LEAVE, FrameManager.lowFrame);
			else
				_stage.removeEventListener (Event.MOUSE_LEAVE, FrameManager.lowFrame);
		}
		
		public static function lowFrame (e=null):void {
			if (low)
				setFrame (low);
			else { trace ("FrameManager : 未執行setup函式"); return; }
			
			_stage.removeEventListener (Event.DEACTIVATE, lowFrame);
			_stage.addEventListener (Event.ACTIVATE, highFrame);
				
			if (_mouseMove)
				_stage.addEventListener (MouseEvent.MOUSE_MOVE, FrameManager.highFrame);
				
			if (_mouseLeave)
				_stage.removeEventListener (Event.MOUSE_LEAVE, FrameManager.lowFrame);
		}
		
		public static function highFrame (e=null):void {
			if (high)
				setFrame (high);
			else { trace ("FrameManager : 未執行setup函式"); return; }
			
			_stage.addEventListener (Event.DEACTIVATE, lowFrame);
			_stage.removeEventListener (Event.ACTIVATE, highFrame);
				
			if (_mouseMove)
				_stage.removeEventListener (MouseEvent.MOUSE_MOVE, FrameManager.highFrame);
				
			if (_mouseLeave)
				_stage.addEventListener (Event.MOUSE_LEAVE, FrameManager.lowFrame);
		}
		
		public static function setFrame (frame:uint):void {
			if (_stage) {
				if (_stage.frameRate != frame)
					_stage.frameRate = frame;
			} else { trace ("FrameManager : 未執行setup函式"); return; }
			
			trace ("FrameManager : 設定frameRate=", frame);
		}
		
		public static function deactivate ():void {
			_stage.removeEventListener (Event.DEACTIVATE, lowFrame);
			_stage.removeEventListener (Event.ACTIVATE, highFrame);
			_stage.removeEventListener (Event.MOUSE_LEAVE, FrameManager.lowFrame);
			_stage.removeEventListener (MouseEvent.MOUSE_MOVE, FrameManager.highFrame);
		}
	}
}