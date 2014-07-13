package tw.algorithm
{
	import flash.geom.Point;
	
	/**
	 * A* Algorithm for 2D grid map
	 * @author Bear
	 * Add START to OPEN list

		while OPEN not empty

		get node n from OPEN that has the lowest f(n)

		if n is GOAL then return path

		move n to CLOSED

		for each n' = CanMove(n, direction)

		g(n') = g(n) + 1

		calculate h(n')

		if new n' is not better, continue

		remove any n' from CLOSED

		add n as n's parent

		add n' to OPEN

		end for

		end while
	 */
	public class AStar 
	{
		const CLASS_NAME = "AStar";
		
		public var depth_weight:int = 1;
		public var direction_weight:int = 1;
		public var distance_weight:int = 1;
		public var max_depth:int = int.MAX_VALUE;
		
		private var _map:Array; // 2-dimension array
		private var _openList:Array;
		private var _closeList:Array;
		private var _mapPointCache:Array;
		private var _startPoint:mapPoint;
		private var _endPoint:mapPoint;
		private var _searchDirection:Array = [
			new Point(  0, -1), // up
			new Point( -1,  0), // left
			new Point(  1,  0), // right
			new Point(  0,  1)  // down
		];
		
		public function AStar() {
		}
		
		public function findPath (start:Point, end:Point):Array {
			_openList = copy2DArray(_map, true);
			_closeList = copy2DArray(_map, true);
			_mapPointCache = copy2DArray(_map, true);
				
			_startPoint = new mapPoint(start.x, start.y);
			_endPoint = new mapPoint(end.x, end.y);
			_openList[start.x][start.y] = _startPoint;
			
			var currentNode:mapPoint;
			var currentBestScore:int = 0;
			var currentDepth:uint = 0;
			
			while (currentNode = findMinCost(_openList)) {
				
				if (currentNode.equal(_endPoint) || currentDepth >= max_depth) {
					return buildPath(currentNode);
				}
				
				_openList[currentNode.x][currentNode.y] = 0;
				_closeList[currentNode.x][currentNode.y] = 1;
				
				var neighbors:Array = availableNodes(currentNode, _searchDirection);
				//var lastNode:mapPoint = currentNode;
				
				if (!neighbors) continue;
				
				currentNode.depth = currentDepth;
				currentBestScore = int.MAX_VALUE;
				currentDepth += 1;
				
				for each (var n in neighbors) {
					_openList[n.x][n.y] = n;
					
					if (!n.parent) n.parent = currentNode;
					n.costToSource = eval_costToSource(n, currentNode);
					n.costToTarget = eval_costToTarget(n, _endPoint);
					n.costTotal = n.costToSource + n.costToTarget;
					
					if (currentBestScore < n.costTotal)
						continue;
					
					//lastNode = n;
				}
				//currentNode = lastNode;
			}
			return null;
		}
		
		protected function findMinCost(ary:Array):mapPoint {
			var curMin:int = int.MAX_VALUE;
			var curChoice:mapPoint = null;
			var ary_len:uint = ary.length;
			var ary_len_in:uint = ary_len ? ary[0].length : 0;
			
			for (var i:uint = 0; i < ary_len; i++ ) {
				for (var j:uint = 0; j < ary_len_in; j++ )
					if (ary[i][j] && ary[i][j].costTotal < curMin) {
						curMin = ary[i][j].costTotal;
						curChoice = ary[i][j];
					}
			}
			return curChoice;
		}
		
		protected function availableNodes(p:mapPoint, direction:Array):Array {
			var nodes:Array = [];
			var dir_len:uint = direction.length;
			for (var i:uint = 0; i < dir_len; i++) {
				var dir = direction[i];
				var toX = p.x + dir.x;
				var toY = p.y + dir.y;
				if (toX < 0 || toX >= _map.length) continue;
				if (toY < 0 || toY >= _map[p.x].length) continue;
				if (_map[toX][toY]) continue;
				if (_closeList[toX][toY]) continue;
				
				var newPoint:mapPoint;
				if (_mapPointCache[toX][toY])
					newPoint = _mapPointCache[toX][toY];
				else {
					newPoint = new mapPoint(toX, toY);
					newPoint.direction = i;
					_mapPointCache[toX][toY] = newPoint;
				}
				nodes.push(newPoint);
			}
			return nodes.length ? nodes : null;
		}
		
		protected function eval_costToSource(n:mapPoint, parentNode:mapPoint):int {
			return parentNode.depth + depth_weight;
		}
		
		protected function eval_costToTarget(n:mapPoint, targetNode:mapPoint):int {
			var plus:uint = n.direction == targetNode.direction ? direction_weight : 0;
			return distance_weight * (Math.abs(n.x - targetNode.x) + Math.abs(n.y - targetNode.y)) + plus;
		}
		
		private function buildPath(p:mapPoint):Array {
			var result:Array = [];
			var curP:mapPoint = p;
			while (curP.parent) {
				result.unshift(curP.point.clone());
				curP = curP.parent;
			}
			return result;
		}
		
		/*protected function isNeighbor(n1, n2, direction:Array):Boolean {
			var dir_len:uint = direction.length;
			for (var i:uint = 0; i < dir_len; i++) {
				var dir = direction[i];
				var toX = n1.x + dir.x;
				var toY = n1.y + dir.y;
				if (n2.x == toX && n2.y == toY) return true;
			}
			return false;
		}*/
		
		public function set map(ary:Array):void {
			if (ary && ary.length && ary[0].length) {
				
				_map = copy2DArray(ary);
				_openList = copy2DArray(ary, true);
				_closeList = copy2DArray(ary, true);
			} else trace (CLASS_NAME+": invalid map!");
		}
		
		public function get map():Array {
			return copy2DArray(_map);
		}
		
		public function set searchDirection(ary:Array):void {
			_searchDirection = ary;
		}
		
		public function copy2DArray(ary:Array, clean:Boolean = false):Array {
			var ary_len:uint = ary.length;
			var ary_len_in:uint = ary_len ? ary[0].length : 0;
			var newArray:Array = new Array(ary_len);
			
			for (var i:uint = 0; i < ary_len; i++ ) {
				newArray[i] = new Array(ary_len_in);
				
				for (var j:uint = 0; j < ary_len_in; j++ ) {
					if (clean && ary[i][j] is mapPoint) ary[i][j].destroy();
					newArray[i][j] = clean ? 0 : ary[i][j];
				}
			}
			return newArray;
		}
		
		public function destroy(e:*= null):void {
			_map = null;
			_openList = null;
			_closeList = null;
			_mapPointCache = null;
		}
	}
	
}