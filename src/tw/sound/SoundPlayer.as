package tw.sound {
	/******************************************************\
	 * 音效撥放器
	 * Date: 2009/04/06
	 * Author: Bear
	\******************************************************/
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.errors.IOError;
	
	public class SoundPlayer extends EventDispatcher {
		
		public static const _NONE_ = 0;
		public static const _PLAYING_ = 1;
		public static const _PAUSE_ = 2;
		public static const _STOP_ = 3;
		public static const _END_ = 4;
		
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
		private var _position:Number = 0;
		private var _loops:uint = 0;
		private var _trans:SoundTransform = null;
		private var _curLoop:uint = 0;
		private var _status = _NONE_;
		
		public function SoundPlayer (music:*=null) {
			if (music == null) return;
			if (music is Class) loadClass (music);
			else loadFile (music);
		}
		
		// 依類別產生
		public function loadClass (className):void {
			_sound = new className ();
		}
		
		// 依檔案產生 (僅支援mp3)
		public function loadFile (fileName):void {
			var request:URLRequest = new URLRequest (fileName);
			
			_sound = new Sound();
			_sound.addEventListener(Event.COMPLETE, completeHandler);
			_sound.addEventListener(Event.ID3, id3Handler);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//_sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_sound.load(request);
		}
		
		public function play (loops:int=1, trans:SoundTransform=null):void {
			if (!_sound) return;
			if (loops >= 0) { // 負值:resume, 0:無限次, 1+:次數
				_loops = loops;
				_trans = trans;
			}
			if (_status == _PLAYING_) return;
			
			_channel = _sound.play (_position, 1, _trans);
			_channel.addEventListener (Event.SOUND_COMPLETE, replay);
			
			_status = _PLAYING_;
		}
		
		public function pause ():void {
			if (!_sound || !_channel) return;
			_position = _channel.position;
			_channel.stop ();
			
			_status = _PAUSE_;
		}
		
		public function resume ():void {
			play (-1);
		}
		
		public function stop ():void {
			if (!_sound || !_channel) return;
			_position = 0;
			_channel.stop ();
			
			_status = _STOP_;
		}
		
		public function jump ($percent:Number):void {
			if (!_sound || !_channel) return;
			stop ();
			_position = $percent * length;
			play (-1);
		}
		
		public function get position ():Number { return _channel.position ? _channel.position : 0; }
		public function get length ():Number { return _sound.length ? _sound.length : 0; }
		public function get percent ():Number { return _sound.length ? (position / length) : 0; }
		public function get isPlaying ():Boolean { return (_status == _PLAYING_) ? true : false; }
		
		public function destroy (e=null):void {
			if (!_sound) return;
			try {
				_sound.close();
			} catch (error:IOError) {}
			
			_sound.removeEventListener(Event.COMPLETE, completeHandler);
			_sound.removeEventListener(Event.ID3, id3Handler);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//_sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			if (!_channel) return;
			
			_channel.stop();
			_channel.removeEventListener (Event.SOUND_COMPLETE, replay);
			_channel = null;
			
			_sound = null;
			_status = _NONE_;
		}
		
		// event handlers ----------------------------------------------------
		private function replay (e=null):void {
			_channel.removeEventListener (Event.SOUND_COMPLETE, replay);
			
			_curLoop ++;
			_position = 0;
			
			_status = _END_;
			
			if ((_loops == 0) || (_curLoop < _loops))
				play (-1);
		}
		
		private function completeHandler (e):void {}
		private function id3Handler (e):void {}
		private function ioErrorHandler (e):void { trace ("SoundPlayer: 音效檔案不存在! "+e.text); }
		//private function progressHandler (e):void {}
	}
}