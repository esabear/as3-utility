package tw.setstage 
{
	import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
	/**
	 * ...
	 * @author Jones Yu
	 */
	public class Fullscreen extends Sprite 
	{
		public var limitWidth = 400;//設定寬度限制
		public var limitHeight = 400;//設定高度限制
		private var pary:Array = new Array();
		private var _stageWidth;
		private var _stageHeight;
		public function Fullscreen(stageWidth:Number,stageHeight:Number) {
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			for (var i = 0; i < 13; i++ ) {
				pary[i] = new Array();//13種方位
				pary[i][0] = new Array();//MC名稱
				pary[i][1] = new Array();//X軸與邊邊的差距
				pary[i][2] = new Array();//Y軸與邊邊的差距
			}
			if (!stage) {
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			} else {
				init();
		    }
		}
		private function init(evt:Event = null ):void {
			this.removeEventListener( Event.ADDED_TO_STAGE, init );
			stage.scaleMode = StageScaleMode.NO_SCALE;
		//	stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		//變動STAGE時的工作
		private function resizeHandler(event:Event):void {
			for (var i = 0; i < 13; i++ ) {
				for (var j in pary[i][0]) {
					if (pary[i][1][j] && stage.stageWidth > limitWidth) {
						if(i==0||i==1||i==2||i==9){
						    pary[i][0][j].x = int(-((stage.stageWidth / 2)-(_stageWidth/2)) + pary[i][1][j]);
						}else if (i == 3 || i == 4 || i == 5) {
						    pary[i][0][j].x = int((_stageWidth/2)+ pary[i][1][j]);
					    }else if (i == 6 || i == 7 || i == 8|| i == 11) {
					        pary[i][0][j].x = int(_stageWidth+(stage.stageWidth / 2)-(_stageWidth/2))- pary[i][1][j];
						}
					}
					if (pary[i][2][j] && stage.stageHeight > limitHeight) {
						if(i==0||i==3||i==6||i==10){
						    pary[i][0][j].y = int(-((stage.stageHeight / 2)-(_stageHeight/2)) + pary[i][2][j]);
						}else if (i == 1 || i == 4 || i == 7) {
						    pary[i][0][j].y = int((_stageHeight/2)+ pary[i][2][j]);
					    }else if (i == 2 || i == 5 || i == 8|| i == 12) {
					        pary[i][0][j].y = int(_stageHeight+(stage.stageHeight / 2)-(_stageHeight/2))- pary[i][2][j];
						}
					}
				}
			}
			
			//stage.stageWidth; 
			//stage.stageHeight;
		}
		public function setLU(... mc) {
			for (var i in mc) {
			pary[0][0][i] = mc[i];
			pary[0][1][i] = mc[i].x;
			pary[0][2][i] = mc[i].y;
			}
		}
		public function setLM(... mc) {
			for (var i in mc) {
			pary[1][0][i] = mc[i];
			pary[1][1][i] = mc[i].x;
			}
		}
		public function setLD(... mc) {
			for (var i in mc) {
			pary[2][0][i] = mc[i];
			pary[2][1][i] = mc[i].x;
			pary[2][2][i] = _stageHeight-mc[i].y;
			}
		}
		public function setMU(... mc) {
			for (var i in mc) {
			pary[3][0][i] = mc[i];
			pary[3][1][i] = (_stageWidth / 2) - mc[i].x;
			pary[3][2][i] = mc[i].y;
			}
		}
		public function setMM(... mc) {
			for (var i in mc) {
			pary[4][0][i] = mc[i];
			pary[4][1][i]= (_stageWidth/2)-mc[i].x;
			}
			
		}
		public function setMD(... mc) {
			for (var i in mc) {
			pary[5][0][i] = mc[i];
			pary[5][1][i]= (_stageWidth/2)-mc[i].x;
			pary[5][2][i] = _stageHeight - mc[i].y;
			}
		}
		public function setRU(... mc) {
			for (var i in mc) {
			pary[6][0][i] = mc[i];
			pary[6][1][i] = _stageWidth-mc[i].x;
			pary[6][2][i] = mc[i].y;
			}
		}

		public function setRM(... mc) {
			for (var i in mc) {
			pary[7][0][i] = mc[i];
			pary[7][1][i] = _stageWidth - mc[i].x;
			}
		}
		public function setRD(... mc) {
			for (var i in mc) {
			pary[8][0][i] = mc[i];
			pary[8][1][i] = _stageWidth-mc[i].x;
			pary[8][2][i] = _stageHeight - mc[i].y;
			}
		}
		public function setL(... mc) {
			for (var i in mc) {
			pary[9][0][i] = mc[i];
			pary[9][1][i] = mc[i].x;
			}
		}
		public function setU(... mc) {
			for (var i in mc) {
			pary[10][0][i] = mc[i];
			pary[10][2][i] = mc[i].y;
			}
		}
		public function setR(... mc) {
			for (var i in mc) {
			pary[11][0][i] = mc[i];
			pary[11][2][i] = _stageHeight - mc[i].y;
			}
		}
		public function setD(... mc) {
			for (var i in mc) {
			pary[12][0][i] = mc[i];
			pary[12][1][i] = _stageWidth - mc[i].x;
			}
		
		}	

		
    }
}