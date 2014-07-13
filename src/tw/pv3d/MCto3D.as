package tw.pv3d {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2009/07/27
	 * 穿透力平面轉3D模組
	 * 將平面的MovieClip轉為3D化
	\*************************************************************************/
	
	import tw.utils.EventManager;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.geom.renderables.Particle;
	import org.papervision3d.core.geom.Particles;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.special.MovieAssetParticleMaterial;
	import org.papervision3d.events.InteractiveScene3DEvent;
	
	public class MCto3D extends BasicView {
		
		public var position_scale:Number = 1; // z值會再乘上此值
		
		public var obj3d:DisplayObject3D;
		
		private var _planes:Array;
		private var _particles:Array;
		
		public function MCto3D (viewportWidth:Number = 640, viewportHeight:Number = 480, scaleToStage:Boolean = true, interactive:Boolean = false, cameraType:String = "Target") {
			super (viewportWidth, viewportHeight, scaleToStage, interactive, cameraType);
			
			obj3d = new DisplayObject3D ();
			_planes = new Array ();
			_particles = new Array ();
			
			viewport.interactive = interactive;
			scene.addChild (obj3d);
			// zoom * focus = Math.abs (z);
			camera.focus = 8;
			camera.zoom = 88;
			camera.z = - camera.focus * camera.zoom;
		}
		
		public function build_plane (target, positions, rotations, rollOverFunc=null, rollOutFunc=null, clickFunc=null, clickParams=null):Plane {

			var material:MovieMaterial = new MovieMaterial (target, true, (target.totalFrames > 1) ? true : false, true);
				material.animated = true;
				//material.smooth = true;
			var plane:Plane = new Plane (material, target.width, target.height, 3, 3);
				//plane.useOwnContainer = true;
				plane.name = target.name;
				plane.rotationX = rotations.x;
				plane.rotationY = rotations.y;
				plane.rotationZ = rotations.z;
				plane.x = (positions.x === null) ? target.x - target.stage.stageWidth * 0.5 : positions.x * position_scale;
				plane.y = (positions.y === null) ? - (target.y - target.stage.stageHeight * 0.5) : positions.y * position_scale;
				plane.z =  positions.z * position_scale;
				
			obj3d.addChild (plane);
			_planes.push (plane);
				
			//target.visible = false;
			
			if (rollOverFunc || rollOutFunc || clickFunc) {
				material.interactive = true;
				EventManager.add (plane, InteractiveScene3DEvent.OBJECT_OVER, rollOverFunc);
				EventManager.add (plane, InteractiveScene3DEvent.OBJECT_OUT, rollOutFunc);
				EventManager.add (plane, InteractiveScene3DEvent.OBJECT_PRESS, clickFunc, clickParams);
			}
			return plane;
		}
		
		public function build_particle (target, linkId:String, positions):void {
			
			var spm:MovieAssetParticleMaterial = new MovieAssetParticleMaterial (linkId, true); 
				//spm.smooth = true; 
				
			var particles3D:Particles = new Particles("ParticleContainer#" + _particles.length);
			var p:Particle = new Particle (spm, 1, 0, 0, 0);
 
			particles3D.addParticle (p);
			particles3D.x = (positions.x === null) ? target.x - target.stage.stageWidth * 0.5 : positions.x;
			particles3D.y = (positions.y === null) ? - (target.y - target.stage.stageHeight * 0.5) : positions.y;
			particles3D.z =  positions.z * position_scale;
			//particles3D.useOwnContainer = true;
				
			obj3d.addChild (particles3D);
			_particles.push (particles3D);
			
			target.visible = false;
		}
		
		public function destroy (e=null):void {
			var len:uint;
			while (len = _planes.length) {
				var plane = _planes.pop ();
				
				obj3d.removeChild (plane);
				
				EventManager.remove (plane);
				plane.material.interactive = false; 
				plane.material.animated = false; 
				plane.material.bitmap.dispose(); 
				plane.material.destroy();
				plane = null;
			}
			scene.removeChild (obj3d);
			obj3d = null;
			viewport.destroy ();
		}
	}
}