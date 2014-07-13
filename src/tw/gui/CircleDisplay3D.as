package tw.gui {
	/******************************************************\
	 * 3D旋轉展示效果
	 * Date: 2009.06.03
	 * Author: Bear
	\******************************************************/
	import flash.events.Event;
	
	import gs.*;
	import gs.easing.*;
	
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class CircleDisplay3D extends BasicView {
		
		public var transTime:Number = 0;
		public var transEase = Circ.easeOut;
		
		private var _movies:Array; // 儲存傳入的MovieClip
		private var _movie_width:Number; // plane的寬
		private var _movie_height:Number;
		private var _planes:Array;
		private var _radius:Number;
		private var _container:DisplayObject3D;
		private var _length:int;
		private var _angle_each:Number;
		
		public function CircleDisplay3D (movies:Array, movie_width:Number= 40, movie_height:Number= 40, radius:Number= 100) {
			_movies = movies;
			_movie_width = movie_width;
			_movie_height = movie_height;
			_radius = radius;
			
			super(400, 300, false);
			init ();
		}
		
		private function init ():void {
			
			_planes = [];
			_container = new DisplayObject3D ();
			
			camera.z = -_radius - 300;
			
			_length = _movies.length;
			_angle_each = 360 / _length;
			
			var _angle_each_radian:Number = _angle_each * Math.PI / 180;
			
			for (var i = 0; i < _length; i++) {
				var material:MovieMaterial = new MovieMaterial(_movies[i], true, true, true);
				var plane = new Plane (material, _movie_width, _movie_height, 1, 1);
					plane.x = _radius * Math.sin (_angle_each_radian * i);
					plane.z = -_radius * Math.cos (_angle_each_radian * i);
					plane.rotationY = -_angle_each * i;
				_container.addChild (plane);
				_planes.push (plane);
				
				_movies[i].visible = false;
			}
			scene.addChild (_container);
			
			startRendering();
			
			//addEventListener (Event.ENTER_FRAME, test_rotation);
		}
		
		private function test_rotation (e=null):void {
			_container.rotationY += 2;
		}
		// ------------------------------------------------------------------------
		
		public function goto (index:int):void {
			TweenMax.to (_container, transTime, {shortRotation:{rotationY:_angle_each * index}, ease:transEase});
		}
		// ------------------------------------------------------------------------
		
		public function get length ():int { return _length; }
		
		// ------------------------------------------------------------------------
		public function destroy (e=null):void {
			_movies = null;
			_planes = null;
		}
	}
}