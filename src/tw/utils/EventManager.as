package tw.utils {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2009/04/02
	 * Update: 2009/04/20 fix for non-DisplayObject
	 * Update: 2009/05/11 fix for (un)register REMOVED_FROM_STAGE events
	 * EventManager模組
	 * 管理事件註冊行為, 並增加一般函式及參數的支援
	\*************************************************************************/
	import flash.events.*;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	public class EventManager {
		
		public static const VERSION:String = "1.0";
		public static const LEVEL_TARGET:uint = 3;
		public static const LEVEL_TYPE:uint   = 2;
		public static const LEVEL_FUNC:uint   = 1;
		
		private static var _eventInfo:Dictionary = new Dictionary ();
		private static var _lastEvent:* = null;
		
		public function EventManager () {
			trace ("EventManager : 不需要被初始化");
		}
		
		public static function add (target:EventDispatcher, type:String, func:Function, args:Array=null, replace:uint=LEVEL_FUNC, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			
			if (_eventInfo[target] == undefined) {
				_eventInfo[target] = new Dictionary ();
				
				if (target is DisplayObject) {
					target.addEventListener (Event.REMOVED_FROM_STAGE, remove);
				}
			}
			
			switch (replace) { // 取代, 先清除
				case LEVEL_TARGET:
					remove (target);
					break;
				case LEVEL_TYPE:
					remove (target, type);
					break;
				case LEVEL_FUNC:
					remove (target, type, func);
					break;
				default:
			}
			
			if (_eventInfo[target][type] == undefined) { // 新增
				_eventInfo[target][type] = new Dictionary ();
			}
			
			// 添加
			if (args == null) {
				_eventInfo[target][type][func] = true;
				target.addEventListener (type, func, useCapture, priority, useWeakReference);
			} else {
				_eventInfo[target][type][eventAgent] = {"func":func, "args":args};
				target.addEventListener (type, eventAgent, useCapture, priority, useWeakReference);
			}
		}
		
		public static function remove (target:*, type:String=null, func:Function=null):void {
			
			if (target is Event) {
				remove (target.target);
				//target.target.removeEventListener (Event.REMOVED_FROM_STAGE, remove);
				//trace ("EventManager : 物件"+target.target+"離開舞台, 移除所有事件");
				return;
			}
			else if (!(target is EventDispatcher)) return;
			
			if (func != null) {
				if (_eventInfo[target] && _eventInfo[target][type])
					delete _eventInfo[target][type][func];
					
				target.removeEventListener (type, func);
				
			} else if (type != null) {
				if (_eventInfo[target]) {
					for (var f in _eventInfo[target][type]) {
						remove (target, type, f);
					}
					delete _eventInfo[target][type];
				}
			} else {
				for (var t in _eventInfo[target]) {
					remove (target, t);
				}
				delete _eventInfo[target];
				
				if (target is DisplayObject) {
					target.removeEventListener (Event.REMOVED_FROM_STAGE, remove);
				}
			}
		}
		
		public static function get lastEvent ():* { return _lastEvent; }
		
		public static function destroy ():void {
			for (var target in _eventInfo) {
				remove (target);
			}
			_eventInfo = null;
			_lastEvent = null;
		}
		
		// 事件代理人: 用來執行多參數函式
		private static function eventAgent (e:*):void {
			_lastEvent = e;
			
			var target = e.currentTarget;
			var type = e.type;
			
			var func:Function = _eventInfo[target][type][eventAgent]["func"];
			var args:Array = _eventInfo[target][type][eventAgent]["args"];
			
			func.apply (target, args);
		}
	} // end of class
} // end of package