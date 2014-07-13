package tw.display {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2009/05/12
	 * Update: 2009/06/01 增加Event.CHANGE發送
	 * 跑馬燈模組
	 * 使用範例:
	import tw.display.Marquee;

	var marquee:Marquee = new Marquee (mc, mc.x, mc.y, 300, 200, Marquee.LEFT);
		//marquee.shift (150, 0);
		marquee.speed = 10;
		marquee.alternate = true;
		marquee.setMask ();
		marquee.play ();
	\*************************************************************************/
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Marquee extends EventDispatcher {

		public static const UP = "u";
		public static const DOWN = "d";
		public static const LEFT = "l";
		public static const RIGHT = "r";
		
		public static const MASK_AUTO = "auto";
		
		public var target:DisplayObject = null;
		public var x:Number = 0;
		public var y:Number = 0;
		public var width:Number = 0;
		public var height:Number = 0;
		public var direction:String;
		
		public var speed:Number = 1; // 位移速度 per frame
		public var alternate:Boolean = false; // 是否為往復運動
		
		private var _isPlaying:Boolean = false;
		private var _isSelfMask:Boolean = false;
		
		public function Marquee ($target:DisplayObject, $x:Number, $y:Number, $width:Number, $height:Number, $direction:String=LEFT) {
			target = $target;
			x = $x;
			y = $y;
			width = $width;
			height = $height;
			direction = $direction;
			
			target.addEventListener (Event.REMOVED_FROM_STAGE, destroy);
			
			init ();
		}
		
		public function init ():void {
			target.x = x;
			target.y = y;
		}
		
		public function setMask ($mask:*=MASK_AUTO):void { // can be null as well
			target.cacheAsBitmap = true;
			
			if ($mask == MASK_AUTO) {
				var sp_mask:Sprite = new Sprite ();
					sp_mask.graphics.beginFill (0xFFFFFF);
					sp_mask.graphics.drawRect (x, y, width, height);
					sp_mask.graphics.endFill ();
				target.parent.addChildAt (sp_mask, target.parent.getChildIndex(target));
				target.mask = sp_mask;
				_isSelfMask = true;
			} else {
				if ($mask is Sprite)
					$mask.cacheAsBitmap = true;
				target.mask = $mask;
			}
		}
		
		public function shift (shiftX:Number, shiftY:Number, dispatch:Boolean=false):void {
			target.x += shiftX;
			target.y += shiftY;
			
			if (dispatch)
				this.dispatchEvent (new Event (Event.CHANGE));
		}
		
		public function play ():void {
			_isPlaying = true;
			target.addEventListener (Event.ENTER_FRAME, move);
		}
		
		public function pause ():void {
			_isPlaying = false;
			target.removeEventListener (Event.ENTER_FRAME, move);
		}
		
		public function stop ():void {
			pause ();
			init ();
		}
		
		public function move (e=null):void {
			switch (direction) {
				case LEFT :
					target.x -= speed;
					if (alternate && target.x <= x) {
						direction = RIGHT;
						break;
					}
					if (target.x <= x - target.width) shift (target.width + width, 0, true);
					break;
					
				case RIGHT :
					target.x += speed;
					if (alternate && target.x >= x + width - target.width) {
						direction = LEFT;
						break;
					}
					if (target.x >= x + width) shift (-target.width - width, 0, true);
					break;
					
				case UP :
					target.y -= speed;
					if (alternate && target.y <= y) {
						direction = DOWN;
						break;
					}
					if (target.y <= y - target.height) shift (0, target.height + height, true);
					break;
					
				case DOWN :
					target.y += speed;
					if (alternate && target.y >= y + height - target.height) {
						direction = UP;
						break;
					}
					if (target.y >= y + height) shift (0, -target.height - height, true);
					break;
			}
		}
		
		public function get isPlaying ():Boolean {
			return _isPlaying;
		}
		
		public function destroy (e=null):void {
			if (target.mask && _isSelfMask)
				target.parent.removeChild (target.mask);
			
			target.mask = null;
			target.removeEventListener (Event.ENTER_FRAME, move);
			target.removeEventListener (Event.REMOVED_FROM_STAGE, destroy);
			target = null;
		}
	}
}