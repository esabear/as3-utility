package tw.effect {
	/******************************************************\
	 * 落星效果
	 * Date:2009/02/17
	 * Author: Bear
	\******************************************************/
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.events.Event;
	import caurina.transitions.Tweener;
	
	public class fallingParticle extends Sprite {
		// particle info
		private var _classParticle:Array; // 粒子來源類別
		private var _pointParticle:Array; // 粒子實體
		private var _totalParticle:uint = 0; // 所有產生的粒子數
		private var _curParticleIndex:uint = 0; // 目前所使用的粒子
		// motion control
		private var _isDrop:Boolean = false; // 是否繼續落下
		private var _dropTime:Number; // 掉落時間
		private var _alphaTime:Number = 0; // 自動消失時間 (0表示不消失)
		private var _maxframeSeg:uint = 4; // 每次落下之間的frame間隔
		private var _curFrameSeg:uint = 0; // 目前已累積的frame間隔
		private var _energyRatio:Number = 0.2; // 能量剩餘比率
		// positions
		private var _startRect:Rectangle; // 起點的矩形範圍
		private var _endRect:Rectangle; // 終點設定 [x:x向量基速, y:y目標, width:x速度增減範圍, height:y目標增減範圍]
		
		public function fallingParticle (startRect:Rectangle, endRect:Rectangle, dropTime = 1) {
			_startRect = startRect;
			_endRect = endRect;
			_dropTime = dropTime;
		}
		
		// 粒子初始化 (允許執行一次) repeat:強制粒子依順序出現,不採用亂數
		public function initPoints (num:uint, classes:Array, repeat:Boolean=false):void {
			if (_totalParticle) return;
			
			_totalParticle = num;
			_classParticle = classes;
			
			_pointParticle = new Array();
			
			for (var i:int = 0; i < _totalParticle; i++) {
				var index:uint = repeat ? (i % _classParticle.length) : Math.floor( Math.random()* _classParticle.length );
				var pClass:Class = Class(_classParticle[index]); //getDefinitionByName(linkageID))
				var p = new pClass();
				addChild(p);
				p.alpha = 0;
				_pointParticle.push(p);
			}
		}
		// 移除所有粒子
		public function removePoints ():void {
			stop ();
			for (var i:int = _totalParticle-1; i >=0 ; i--) {
				removeChild (_pointParticle[i]);
				_pointParticle[i] = null;
				_pointParticle.pop ();
			}
			_pointParticle = null;
			_classParticle = null;
			_totalParticle = 0;
			_curParticleIndex = 0;
		}
		
		private function redraw (e:Event = null):void {
			if (!_isDrop) return;
			if (!_totalParticle) return;
			
			_curFrameSeg = ++_curFrameSeg % _maxframeSeg;
			if (_curFrameSeg < _maxframeSeg-1) return;
			
			moveParticle ( _pointParticle[_curParticleIndex] );
			_curParticleIndex = ++_curParticleIndex % _pointParticle.length;
		}
		
		// 彈跳控制
		public function moveParticle (p):void {
			p.x = _startRect.x + _startRect.width * Math.random();
			p.y = _startRect.y + _startRect.height * Math.random();
			p.alpha = 1;
			
			var speedX:Number = _endRect.x - _endRect.width/2 + _endRect.width * Math.random();
			var toY:Number = _endRect.y - p.y + _endRect.height * Math.random();
			fallDown (p, _dropTime, toY, speedX, _energyRatio);
			
			if (_alphaTime)
				Tweener.addTween(p, {alpha:0, time:_alphaTime, transition:"easeInQuint"});
		}
		
		
		function fallDown(target:Object, time:Number, heightY:Number, speedX:Number = 0, energyReduceRatio:Number = 0) {
			Tweener.addTween(target, {x:target.x + speedX * time, time:time, transition:"linear"});
			Tweener.addTween(target, {y:target.y + heightY, time:time, transition:"easeInQuad", onComplete:goUp, onCompleteParams:[target, Math.sqrt(energyReduceRatio)*time, energyReduceRatio*heightY, speedX, energyReduceRatio]});
		}

		function goUp(target:Object, time:Number, heightY:Number, speedX:Number = 0, energyReduceRatio:Number = 0) {
			if (Math.abs(heightY) < 0.01) return; // 不加此行會發生堆疊溢位
			Tweener.addTween(target, {x:target.x + speedX * time, time:time, transition:"linear"});
			Tweener.addTween(target, {y:target.y - heightY, time:time, transition:"easeOutQuad", onComplete:fallDown, onCompleteParams:[target, time, heightY, speedX, energyReduceRatio]});
		}
		
		// motion control
		public function play ():void {
			_isDrop = true;
			
			addEventListener(Event.ENTER_FRAME, redraw);
		}
		
		public function stop ():void {
			removeEventListener(Event.ENTER_FRAME, redraw);
			
			for (var i:int = 0; i < _totalParticle; i++)
				Tweener.removeTweens (_pointParticle[i]);
		}
		
		public function pause ():void {
			removeEventListener(Event.ENTER_FRAME, redraw);
			
			for (var i:int = 0; i < _totalParticle; i++)
				Tweener.pauseTweens (_pointParticle[i]);
		}
		
		public function resume ():void {
			for (var i:int = 0; i < _totalParticle; i++)
				Tweener.resumeTweens (_pointParticle[i]);
			play ();
		}
		
		public function hide (time:Number = 0, delay:Number = 0):void {
			for (var i:int = 0; i < _totalParticle; i++)
				Tweener.addTween (_pointParticle[i], {alpha:0, time:time, delay:delay, onComplete:pause});
		}
		
		public function stopDrop ():void {
			_isDrop = false;
		}
		
		// getter & setter
		public function set startRect (rect:Rectangle):void {
			_startRect = rect;
		}
		public function set endRect (rect:Rectangle):void {
			_endRect = rect;
		}
		public function set dropTime (t:Number):void {
			_dropTime = Math.abs (t);
		}
		public function set alphaTime (t:Number):void {
			_alphaTime = Math.abs (t);
		}
		public function set maxframeSeg (u:uint):void {
			_maxframeSeg = Math.abs (u);
		}
		public function set energyRatio (r:Number):void {
			r = Math.abs (r);
			if (r >= 1) r = 0.99999; // 小於1才能收斂
			_energyRatio = r;
		}
		// 取得目前可視的粒子數 (debug用)
		public function get countVisibleParticles ():uint {
			var count:uint = 0;
			for (var i:int = 0; i < _totalParticle; i++)
				if (_pointParticle[i].alpha > 0) count++
			return count;
		}
		
		// destroy
		public function destroy ():void {
			removePoints ();
			_startRect = null;
			_endRect = null;
		}
	}
}