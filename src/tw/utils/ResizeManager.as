package tw.utils {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2014/06/20
	 * ResizeManager模組
	 * 專門管理RESIZE事件
	\*************************************************************************/
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.display.Stage;
	
	public class ResizeManager {
		// Must setup at initial, the originally designed Flash size
		public static var wFlash:Number = 1000;
		public static var hFlash:Number = 600;
		// Accessable variables when stage resized
		public static var wDiff:Number = 0;
		public static var hDiff:Number = 0;
		public static var wHalfDiff:Number = 0;
		public static var hHalfDiff:Number = 0;
		public static var wScale:Number = 0;
		public static var hScale:Number = 0;
		// Private
		private static var _resizeList:Dictionary = null;
		private static var _theStage:Stage = null;
		
		public function ResizeManager () {
			trace ("ResizeManager : 不需要被初始化");
		}
		
		public static function add (target:*, func:Function, firstRun:Boolean=true):void {
			if (_resizeList == null) {
				_resizeList = new Dictionary ();
				_theStage = target.stage;
				_theStage.addEventListener (Event.RESIZE, resizeAndUpdate);
				resizeAndUpdate();
			}
			
			if (_resizeList [target])
				remove (target); // 覆寫前先刪除
				
			_resizeList [target] = func;
			
			target.addEventListener (Event.REMOVED_FROM_STAGE, remove);
			target.stage.addEventListener (Event.RESIZE, resizeHandler);
			
			if (firstRun) {
				func.apply (target);
			}
		}
		
		public static function remove (target:*):void {
			if (_resizeList == null) return;
			if (target is Event) {
				target.target.removeEventListener (Event.REMOVED_FROM_STAGE, remove);
				remove (target.target);
				return;
			}
			if (_resizeList [target] == undefined) return;
			
			delete _resizeList [target];
		}
		
		private static function resizeHandler (e:Event=null):void {
			for (var target in _resizeList)
				_resizeList[target].apply (target);
		}
		
		private static function resizeAndUpdate (e:Event=null):void {
			wDiff = _theStage.stageWidth - wFlash;
			hDiff = _theStage.stageHeight - hFlash;
			wHalfDiff = wDiff * 0.5;
			hHalfDiff = hDiff * 0.5;
			wScale = _theStage.stageWidth / wFlash;
			hScale = _theStage.stageHeight / hFlash;
		}
	}
}