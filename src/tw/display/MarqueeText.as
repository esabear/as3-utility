package tw.display {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2009/05/12
	 * 文字走馬燈模組
	 * 使用範例:
	\*************************************************************************/
	
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	public class MarqueeText extends Marquee {
		
		private var _targetTextField:TextField = null;
		private var _scale:Number = 2;
		
		private var _bitmapDataFrom:BitmapData;
		private var _bitmapDataTo:BitmapData;
		private var _bitmap:Bitmap;
		private var _container:Sprite;
		
		public function MarqueeText ($target:TextField, $scale:Number = 2) {
			_targetTextField = $target;
			_targetTextField.visible = false;
			_scale = $scale;
			
			var displayObject:Sprite = new Sprite ();
			_targetTextField.parent.addChildAt (displayObject, _targetTextField.parent.getChildIndex(_targetTextField));
			
			buildBitmap (displayObject, _targetTextField, _scale);
			
			super (displayObject, displayObject.x, displayObject.y, displayObject.width, displayObject.height);
			
			_targetTextField.addEventListener (Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function set text (str:String):void {
			_targetTextField.text = str;
			rebuildBitmap ();
		}
		
		public function get text ():String {
			return _targetTextField.text;
		}
		
		public function appendText (str):void {
			_targetTextField.appendText (str);
			rebuildBitmap ();
		}
		
		public function rebuildBitmap ():void {
			var isPlayed:Boolean = isPlaying;
			
			if (isPlayed) pause ();
			
			buildBitmap (target as Sprite, _targetTextField, _scale);
			
			if (isPlayed) play ();
		}
		
		private function buildBitmap (container:Sprite, txt:TextField, scale:Number):void {
			if (scale <= 0) return;
			
			txt.width = txt.textWidth + 4;
			txt.height = txt.textHeight + 4;
			txt.antiAliasType = AntiAliasType.NORMAL;
			//txt.multiline = false;
	
			if (_bitmapDataFrom) _bitmapDataFrom.dispose ();
			_bitmapDataFrom = new BitmapData (txt.width, txt.height, true, 0x0);
			_bitmapDataFrom.draw (txt);
			
			if (_bitmapDataTo) _bitmapDataTo.dispose ();
			_bitmapDataTo = new BitmapData (txt.width * scale, txt.height * scale, true, 0x0);
			
			for (var i = 0; i < _bitmapDataFrom.width; i ++) {
				for (var j = 0; j < _bitmapDataFrom.height; j ++) {
					var dot = _bitmapDataFrom.getPixel32 (i, j);
					if (dot)
						_bitmapDataTo.setPixel32 (i * scale, j * scale, dot);
				}
			}
			
			_bitmap = new Bitmap (_bitmapDataTo);
			_bitmap.smoothing = true;
			
			while (container.numChildren) container.removeChildAt (0);
			container.addChild (_bitmap);
			container.x = txt.x;
			container.y = txt.y;
		}
		override public function destroy (e=null):void {
			_targetTextField.removeEventListener (Event.REMOVED_FROM_STAGE, destroy);
			
			if (_bitmapDataFrom) _bitmapDataFrom.dispose ();
			if (_bitmapDataTo) _bitmapDataTo.dispose ();
			
			while ((target as Sprite).numChildren) (target as Sprite).removeChildAt (0);
			
			var formalTarget = target;
			super.destroy ();
			
			_targetTextField.parent.removeChild (formalTarget);
		}
	}
}

