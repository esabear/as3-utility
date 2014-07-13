package tw.gui {
	/******************************************************\
	 * 旋轉選單
	 * Author: Bear
	\******************************************************/
	import flash.geom.Point;
	import caurina.transitions.Tweener;
	
	public class CircleMenu extends CircleMenuBase {
		private var _start_to_all:Object; // onStart時 套用在所有選單的參數 (ex: {alpha:0.5, scaleX:0.8} )
		private var _complete_to_all:Object; // onComplete時 套用在所有選單的參數
		private var _complete_to_select:Object; // ...套用在被選擇的選項
		
		private var _bg_extra:Array = new Array(); // 額外的背景
		private var _bg_extra_start:Array = new Array();
		private var _bg_extra_complete:Array = new Array();
		
		public function CircleMenu (center:Point, radius:Number, menus:Array, start:Object=null, complete:Object=null, complete_to_select:Object=null) {
			_start_to_all = start;
			_complete_to_all = complete;
			_complete_to_select = complete_to_select;
			
			super(center, radius, menus);
			
			onStart();
		}
		
		public function add_extra_bg (obj:Object, start:Object=null, complete:Object=null):void {
			_bg_extra.push (obj);
			_bg_extra_start.push (start);
			_bg_extra_complete.push (complete);
		}
		
		override public function onStart():void {
			//trace("CircleMenu: wheel start!");
			
			applyProperty_All (_menus, _start_to_all);
			applyProperty_All (_bg_extra, _bg_extra_start);
		}
		
		override public function onComplete():void {
			//trace("CircleMenu: wheel complete!");
			
			applyProperty_All(_menus, _complete_to_all);
			applyProperty_All (_bg_extra, _bg_extra_complete);
			applyProperty (_curSelect, _complete_to_select);
		}
		
		private function applyProperty_All (ary:Array, param:Object):void {
			for (var i = 0; i < ary.length; i++)
				if (param is Array) // 如果傳進來的是屬性陣列 就一一套用
					applyProperty(ary[i], param[i]);
				else // 否則就共用
					applyProperty(ary[i], param);
					
		}
		
		private function applyProperty (obj:Object, param:Object):void {
//			for (var p in param){trace(p);
			Tweener.addTween(obj, param);
		}
	}
}