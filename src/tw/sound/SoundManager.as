package tw.sound {
	/******************************************************\
	 * 音效管理員
	 * Date: 2009/04/06
	 * Author: Bear
	\******************************************************/
	import flash.events.EventDispatcher;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	public class SoundManager extends EventDispatcher {
		
		private static var _lastVolume:Number = 1;
		private static var _soundList:Dictionary = null;
		
		// 取得頻譜
		public static function getSpectrum (FFTMode:Boolean=false, stretchFactor:int=0):ByteArray {
			var byte:ByteArray = new ByteArray();
			SoundMixer.computeSpectrum (byte, FFTMode, stretchFactor);
			
			return byte;
		}
		
		// 聲道平衡 (左 -1 ~ 1 右)
		public static function set pan (value:Number):void {
			if (value >  1) value =  1;
			if (value < -1) value = -1;
			
			SoundMixer.soundTransform = new SoundTransform(SoundMixer.soundTransform.volume, value);
		}
		public static function get pan ():Number { return SoundMixer.soundTransform.pan; }
		public static function set balance (value:Number):void { pan = value; }
		public static function get balance ():Number { return pan; }
		
		// 音量 (0~1)
		public static function set volume (value:Number):void {
			if (value > 1) value = 1;
			if (value < 0) value = 0;
			
			SoundMixer.soundTransform = new SoundTransform(value, SoundMixer.soundTransform.pan);
		}
		public static function get volume ():Number { return SoundMixer.soundTransform.volume; }
		
		public static function set soundTransform (st:SoundTransform):void { SoundMixer.soundTransform = st; }
		public static function get soundTransform ():SoundTransform { return SoundMixer.soundTransform; }
		
		// 靜音
		public static function mute (flag:Boolean=true):void {
			if (flag) {
				_lastVolume = SoundMixer.soundTransform.volume;
				SoundMixer.soundTransform = new SoundTransform(0, SoundMixer.soundTransform.pan);
			}
			else
				SoundMixer.soundTransform = new SoundTransform(_lastVolume, SoundMixer.soundTransform.pan);
		}
		
		// 停止所有聲音, 直到下一個聲音被觸發
		public static function stopAll ():void { SoundMixer.stopAll (); }
		
		public static function add (music:*, id:String):Boolean {
			if (_soundList == null)
				_soundList = new Dictionary ();
			if (_soundList [id]) return false; // do not override
			
			var sp:SoundPlayer = new SoundPlayer (music);
			_soundList [id] = sp;
			
			return true;
		}
		
		public static function get (id:String):SoundPlayer {
			return (_soundList && _soundList [id] ? _soundList [id] : null);
		}
		
		public static function remove (id:String):void {
			if (_soundList == null) return;
			if (_soundList [id] == undefined) return;
			
			_soundList [id].destroy ();
			delete _soundList [id];
		}
		
		public static function removeAll ():void {
			if (_soundList == null) return;

			for (var id in _soundList) {
				remove (id);
			}
			_soundList = null;
		}
		
		public static function destroy ():void {
			removeAll ();
			pan = 0;
			volume = 1;
		}
	}
}