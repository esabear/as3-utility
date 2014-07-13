/***************************************************************************\
Circle Splash 旋轉天女散花
2009.01.10
@ Bear
\***************************************************************************/
package tw.effect {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.geom.renderables.Particle;
	import org.papervision3d.core.geom.Particles;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.special.MovieAssetParticleMaterial;
	import org.papervision3d.materials.MovieAssetMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.DisplayObject3D;
	
	import caurina.transitions.Tweener; // 需使用Tweener
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class CircleSplash3D extends BasicView {
		
		private var _upSegment:Number = 0; // 上移間距/每Frame (可負值)
		private var _inSegment:Number = 0; // 內縮間距/每Frame (可負值)
		private var _angleSegment:Number = 0; // 轉動角度/每Frame (可負值)
		
		private var _dropAction:Boolean = true; // 是否開啟掉落動作
		private var _dropAmount:int; // 每次掉落最大數量
		private var _dropFrameSegment:int; // 掉落的Frame間隔
		private var _maxAmount:int; // 最大數量
		
		private var _startX:Number = 100; // 起點x座標
		private var _startY:Number = 0; // 起點y座標
		private var _startZ:Number = -100; // 起點z座標
		private var _ceilingY:Number = 200; // 所能到達的最高Y座標
		private var _floorY:Number = -100; // 進行彈跳的地板Y座標
		
		private var _heightLimit:Number = 0.001; // 最小反彈距離極值
		private var _energyReduceRatio:Number = 0.2; // 每次反彈的能量降低比
		
		private var _leaderMovie:Particles; // 帶頭的實體
		private var _normalMovieClips:Array = new Array(); // 會跟著scene移動的平面
		private var _staticMovieClips:Array = new Array(); // 不移動的平面 (永遠面對鏡頭)
		private var _particles:Array = new Array(); // 粒子陣列
		private var _particleContainer:DisplayObject3D = new DisplayObject3D();; // 存放粒子的容器
		private var _MovieClipContainer:DisplayObject3D = new DisplayObject3D();; // 存放一般MovieClip的容器
		
		private var _indexParticle:uint = 0; // 下一個可使用的粒子位置
		private var _countFramesTillDrop:uint = 0; // 記錄距上次落下的frame數
		
		public function CircleSplash3D (width:Number, height:Number, autoScaleToStage:Boolean = false):void {
			super(width, height, autoScaleToStage);
			
			scene.addChild(_particleContainer);
			scene.addChild(_MovieClipContainer);
			camera.z = -500; // 初始化設定, 可再變更
		}
		
		// 須傳入MovieClip"連結名稱"的字串 [按:Linkage至ActionScript]
		public function setLeaderMovie (leader:String = null, size:Number = 1, x:Number = 200, y:Number = -100, z:Number = 0):void {
			_startX = x;
			_startY = y;
			_startZ = z;
			
			var materialLeader:MovieAssetParticleMaterial = new MovieAssetParticleMaterial(leader, true);
			_leaderMovie = createParticle( materialLeader, size, "ParticleContainer_leader", false);
			_particleContainer.addChild(_leaderMovie); 
		}
		
		// 設定領航元件的參數
		public function setLeaderMovieAction (angleSegment:Number, upSegment:Number, inSegment:Number):void {
			_angleSegment = angleSegment;
			_upSegment = upSegment;
			_inSegment = inSegment;
		}
		
		// particleTypes 為MovieClip"連結名稱"的字串陣列
		public function setParticleMovie (particleTypes:Array, size:Number = 1, maxAmount:int=100, singleDropAmount:int=2, frameSegment:int=1):void { 
		
			if (_particles.length > 0) return; // 不允許執行二次
			
			_maxAmount = maxAmount;
			_dropAmount = singleDropAmount;
			_dropFrameSegment = frameSegment;
			
			var materials:Array = new Array();
			for (var i:int = 0; i < particleTypes.length; i++) {
				// 1.連結字串 2.透明
				var material:MovieAssetParticleMaterial = new MovieAssetParticleMaterial (particleTypes[i], true); 
				material.smooth = true;
				materials.push (material);
			}
			
			for (i = 0; i < _maxAmount; i++) {
				var particles:Particles = createParticle( materials[ Math.floor( Math.random()* materials.length ) ], size, "ParticleContainer_"+i, false);
 				_particleContainer.addChild(particles);
				_particles.push(particles); // 放進去的是 Particles 類別
			}
		}
		
		// 增加可隨場景、攝影機轉換而移動的MC
		public function addNormalMovieClip (linkage:String, width:Number, height:Number, x:Number = 0, y:Number = 0, z:Number = 0):Plane {
			var material:MovieAssetMaterial = new MovieAssetMaterial(linkage, true);
			var plane:Plane = new Plane(material, width, height, 1, 1); // 材質, 寬, 高, 3D格線數
			plane.x = x;
			plane.y = y;
			plane.z = z;
			
			_MovieClipContainer.addChild(plane);
			_normalMovieClips.push(plane);
			return plane;
		}
		
		// 增加不動的MC於3D空間中 (永遠面向螢幕)
		public function addStaticMovieClip (linkage:String, size:Number = 1, x:Number = 0, y:Number = 0, z:Number = 0):Particles {
			var material:MovieAssetParticleMaterial = new MovieAssetParticleMaterial(linkage, true);
			var particles:Particles = createParticle( material, size, "ParticleContainer_static#"+_staticMovieClips.length, true);
			
			_MovieClipContainer.addChild(particles); 
			_staticMovieClips.push(particles);
			return particles;
		}
		
		// 粒子產生器, 回傳粒子的容器:Particles類別
		private function createParticle (material:MovieAssetParticleMaterial, size:Number, name:String, visible:Boolean=false):Particles {
			var particles3D:Particles = new Particles (name);
			var p:Particle = new Particle (material, size,0,0,0); // 材質,size,x,y,z
			
			particles3D.addParticle(p); // Particle 要放在 Particles 裡
			particles3D.visible = visible;
			return particles3D;
		}
		
		// 模擬落下的重力效應
		private function fallDown(target:DisplayObject3D, time:Number, heightY:Number, speedX:Number = 0, energyReduceRatio:Number = 1) {
			Tweener.addTween(target, {x:target.x + speedX * time, time:time, transition:"linear"});
			Tweener.addTween(target, {y:target.y - heightY, time:time, transition:"easeInQuad", onComplete:goUp, onCompleteParams:[target, Math.sqrt(energyReduceRatio)*time, energyReduceRatio*heightY, speedX, energyReduceRatio]});
		}
		// 彈起
		private function goUp(target:DisplayObject3D, time:Number, heightY:Number, speedX:Number = 0, energyReduceRatio:Number = 1) {
			if (heightY < 0.001) { 
				//target.visible = false;
				return; 
			}
			Tweener.addTween(target, {x:target.x + speedX * time, time:time, transition:"linear"});
			Tweener.addTween(target, {y:target.y + heightY, time:time, transition:"easeOutQuad", onComplete:fallDown, onCompleteParams:[target, time, heightY, speedX, energyReduceRatio]});
		}
		
		// 移動與繪圖
		private function render(e:Event):void {
			if (!_leaderMovie) return;
			
			if ( (_leaderMovie.y > _ceilingY) || (_leaderMovie.y < _floorY) ) {
				_dropAction = false; // 停止粒子降落
				dispatchEvent(new Event(Event.COMPLETE));
			} else {
				// 位移
				_leaderMovie.translate (_inSegment, new Number3D(-_leaderMovie.x, 0, -_leaderMovie.z)); // 往中央Y軸內縮
				_leaderMovie.y += _upSegment;
				// 旋轉
				var angle:Number = _angleSegment * Math.PI/180;
				var cos:Number = Math.cos(angle);
				var sin:Number = Math.sin(angle);
				var nx:Number = cos * _leaderMovie.x - sin * _leaderMovie.z;
				var nz:Number = cos * _leaderMovie.z + sin * _leaderMovie.x;
				_leaderMovie.x = nx;
				_leaderMovie.z = nz;
			}
			
			// 釋放粒子
			if (_dropAction && (++_countFramesTillDrop > _dropFrameSegment) ) {
				_countFramesTillDrop = 0; // 歸零
				var amount:uint = 1 + Math.floor(_dropAmount * Math.random()); // 本次要落下的數量
				for (var i:int = 0; i < amount; i++) {
					var p:Particles = _particles[_indexParticle];
					p.visible = true;
					p.copyPosition(_leaderMovie); // 移到領航元件的位置
					
					fallDown(p, 0.5+0.5 * Math.random(), p.y - _floorY, -50+50 * Math.random(), _energyReduceRatio); // 落下
					
					_indexParticle++;
					if (_indexParticle >= _particles.length) _indexParticle = 0;
				}
			}
			
			singleRender(); 
		}
		
		// 動作開始
		public function start():void {
			_dropAction = true;
			_leaderMovie.visible = true;
			_leaderMovie.x = _startX;
			_leaderMovie.y = _startY;
			_leaderMovie.z = _startZ;
			addEventListener (Event.ENTER_FRAME, render);
		}
		
		public function stop():void {
			removeEventListener (Event.ENTER_FRAME, render);
		}
		
		public function hideParticles():void {
			for (var i:int = 0; i < _particles.length; i++)
				_particles[i].visible = false;
		}
		
		public function set energyReduceRatio(num:Number):void {
			_energyReduceRatio = num;
		}
		
		public function set ceiling(num:Number):void {
			_ceilingY = num;
		}
		
		public function set floor(num:Number):void {
			_floorY = num;
		}
	}
}