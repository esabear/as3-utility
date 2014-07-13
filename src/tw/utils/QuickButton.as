package tw.utils {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2009/05/19
	 * Last modified: 2010/04/08 enable/disable alpha
	 * 穿透力QuickButton模組
	 * 快速註冊按鈕事件，使用EventManager設定，故需注意EventManager重覆註冊問題(會被刪掉)
	\*************************************************************************/
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import tw.utils.EventManager;
	
	public class QuickButton {
		
		public function QuickButton () {
			trace ("QuickButton : 不需要被初始化");
		}
		
		public static function add (sensor:InteractiveObject, clickAction:Function=null, clickParams:Array=null, rollOverLabel="on", rollOutLabel="off", target:MovieClip=null):void {
			if (target == null) target = sensor as MovieClip;
			
			if (sensor is Sprite) (sensor as Sprite).buttonMode = true;
			
			if (rollOverLabel) EventManager.add (sensor, MouseEvent.ROLL_OVER, target.gotoAndPlay, [rollOverLabel]);
			if (rollOutLabel) EventManager.add (sensor, MouseEvent.ROLL_OUT, target.gotoAndPlay, [rollOutLabel]);
			if (clickAction != null ) {
				if (clickParams == null) clickParams = [];
				EventManager.add (sensor, MouseEvent.CLICK, clickAction, clickParams);
			}
		}
		public static function remove (sensor:InteractiveObject) {
			if (sensor is Sprite) (sensor as Sprite).buttonMode = false;
			
			EventManager.remove (sensor, MouseEvent.ROLL_OVER);
			EventManager.remove (sensor, MouseEvent.ROLL_OUT);
			EventManager.remove (sensor, MouseEvent.CLICK);
		}
		
		public static function enable (target:DisplayObject, $alpha:Number = -1):void {
			if (target is DisplayObjectContainer) (target as DisplayObjectContainer).mouseChildren = true;
			if (target is InteractiveObject) (target as InteractiveObject).mouseEnabled = true;
			if ($alpha != -1) target.alpha = $alpha;
		}
		
		public static function disable (target:DisplayObject, $alpha:Number = -1):void {
			if (target is DisplayObjectContainer) (target as DisplayObjectContainer).mouseChildren = false;
			if (target is InteractiveObject) (target as InteractiveObject).mouseEnabled = false;
			if ($alpha != -1) target.alpha = $alpha;
		}
	}
}