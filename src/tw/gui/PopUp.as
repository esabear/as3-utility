package tw.gui {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2009/04/08
	 * LastModify: 2010/01/14 gs=>com / autoPopOut
	 * PopUp模組: 跳出小視窗
	\*************************************************************************/
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class PopUp extends EventDispatcher {
		public static const POP_IN:String = "POP_IN";
		public static const POP_OUT:String = "POP_OUT";
		
		public static const ALPHA_IN  = {autoAlpha:1};
		public static const ALPHA_OUT = {autoAlpha:0};
		public static const SCALE_IN  = {autoAlpha:1, scaleX:1, scaleY:1, ease:Back.easeOut};
		public static const SCALE_OUT = {autoAlpha:0, scaleX:0, scaleY:0};
		public static const JUMP_IN  = {autoAlpha:1, y:"-30"};
		public static const JUMP_OUT = {autoAlpha:0, y:"30"};
		public static const JUMP2_IN  = {autoAlpha:1, y:"-30", ease:Back.easeOut};
		public static const JUMP2_OUT = {autoAlpha:0, y:"30"};
		public static const ROTATION_IN  = {autoAlpha:1, scaleX:1, scaleY:1, rotation:0};
		public static const ROTATION_OUT = {autoAlpha:0, scaleX:0, scaleY:0, rotation:230};
		public static const TV_IN  = [{scaleY:1}, {scaleX:1, delay:0.3, ease:Back.easeOut, overwrite:0}];
		public static const TV_OUT = [{scaleX:0}, {scaleY:0, delay:0.3, ease:Back.easeOut, overwrite:0}];
		public static const SHIFTX_IN  = {x:"1000", ease:Back.easeOut};
		public static const SHIFTX_OUT = {x:"-1000"};
		
		public static const ALPHA = [ALPHA_IN, ALPHA_OUT];
		public static const SCALE = [SCALE_IN, SCALE_OUT];
		public static const JUMP  = [JUMP_IN, JUMP_OUT];
		public static const JUMP2 = [JUMP2_IN, JUMP2_OUT];
		public static const ROTATION = [ROTATION_IN, ROTATION_OUT];
		public static const TV = [TV_IN, TV_OUT];
		public static const SHIFTX = [SHIFTX_IN, SHIFTX_OUT];
		
		public static const ID_IN  = 0;
		public static const ID_OUT = 1;
		
		private var _mc:MovieClip;
		private var _type:Array;
		private var _closer:DisplayObject;
		private var _msg:TextField;
		private var _transTime:Number = 0.5;
		private var _isShow:Boolean = false;
		
		public function PopUp (mc:MovieClip, type:Array, closer:DisplayObject=null, msg:TextField=null, autoPopOut:Boolean=true):void {
			_mc = mc;
			_type = type.concat();
			_closer = closer;
			_msg = msg;
			
			init (autoPopOut);
		}
		
		private function init (autoPopOut:Boolean=true):void {
			if (_closer) {
				_closer.addEventListener (MouseEvent.CLICK, closeThis);
				if (_closer is MovieClip)
					MovieClip(_closer).buttonMode = true;
			}
				
			if (autoPopOut) pop (0, ID_OUT);
			else _isShow = true;
			
			_mc.addEventListener (Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function show (flag:Boolean=true, msg:String=""):void {
			if (_msg)
				_msg.text = msg;
			
			if (_isShow == flag) return;
			
			_isShow = flag;
			pop (_transTime, flag ? ID_IN : ID_OUT);
		}
		
		public function pop (time:Number=0.5, index:uint=ID_IN):void {
			if (_type[index] is Array) {
				TweenMax.killTweensOf (_mc, true);
				for each (var type in _type[index])
					tweenTo (time, type);
			}
			else if (_type[index] is String) {
				_mc.gotoAndPlay (_type[index]);
			}
			else if (_type[index] is Object) {
				TweenMax.killTweensOf (_mc, true);
				tweenTo (time, _type[index]);
				_mc.blendMode = BlendMode.LAYER;
				TweenMax.delayedCall(time, function() { _mc.blendMode = BlendMode.NORMAL; } );
			}
			dispatchEvent(new Event(index == ID_IN ? POP_IN : POP_OUT));
		}
		
		public function get content ():MovieClip { return _mc; }
		public function set transTime (value:Number):void { _transTime = Math.abs (value); }
		public function get transTime ():Number { return _transTime; }
		public function set type (value:Array):void { _type = value.concat(); }
		public function get type ():Array { return _type; }
		public function get isShow ():Boolean { return _isShow; }
		
		private function closeThis (e):void { show (false); }
		
		private function tweenTo (time, type):void { TweenMax.to (_mc, time, type); }
		
		public function destroy (e=null):void {
			TweenMax.killTweensOf (_mc);
			_mc.removeEventListener (Event.REMOVED_FROM_STAGE, destroy);
			_mc = null;
			
			if (_closer) 
				_closer.removeEventListener (MouseEvent.CLICK, closeThis);
				
			_type = null;
		}
	}
}