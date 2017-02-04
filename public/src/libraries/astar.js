// javascript-astar 0.3.0
// http://github.com/bgrins/javascript-astar
// Freely distributable under the MIT License.
// Implements the astar search algorithm in javascript using a Binary Heap.
// Includes Binary Heap (with modifications) from Marijn Haverbeke.
// http://eloquentjavascript.net/appendix2.html
// 'use strict'

(function(definition) {
    /* global module, define */
    if(typeof module === 'object' && typeof module.exports === 'object') {
        module.exports = definition();
    } else if(typeof define === 'function' && define.amd) {
        define([], definition);
    } else {
        var exports = definition();
        window.astar = exports.astar;
        window.Graph = exports.Graph;
    }
})(function() {

function pathTo(node){
    var curr = node,
        path = [];
    while(curr._parent) {
        path.push(curr);
        curr = curr._parent;
    }
    return path.reverse();
}

function getHeap() {
    return new BinaryHeap(function(node) {
        return node.f;
    });
}

var astar = {
    init: function(graph) {
        for (var key in graph.data) {
            var node = graph.data[key];
            node.f = 0;
            node.g = 0;
            node.h = 0;
            node.visited = false;
            node.closed = false;
            node._parent = null;
        }
        // foo = {}
        // for (var i = 0; i < graph.length; i++){
        //     var row = graph[i]
        //     for (var j = 0; j < row.length; j++){
        //         var node = row[j]
        //         foo[node.hash()] = {f:0, g:0, h:0, visited:false, closed:false, _parent:null}
        //         // console.log(node);

        //     }
        // }
        // return foo
    },

    /**
    * Perform an A* Search on a graph given a start and end node.
    * @param {Graph} graph
    * @param {GridNode} start
    * @param {GridNode} end
    * @param {Object} [options]
    * @param {Function} [options.heuristic] Heuristic function (see
    *          astar.heuristics).
	* @param {Function} [options.impassable] Impasssable function (returns
	*          true if impassable)
    */
    search: function(graph, start, end, heuristic, impassable) {
        // var graph = options.graph;
        // var start = options.start;
        // var end = options.end;
        astar.init(graph);
        // return graph
        // options = options || {};
        var unit = false;
        // var heuristic = options.heuristic;
        // var closest = options.closest || false;
        // var neighbors = options.neighbors;
        var impassable = impassable || function(){ return false };
        // var impassable = function(){ return false }

        var openHeap = getHeap();

        start.h = heuristic(start, end);
        openHeap.push(start);
        zz = 0
        while(openHeap.size() > 0) {
            zz += 1
            // Grab the lowest f(x) to process next.  Heap keeps this sorted for us.
            var current_node = openHeap.pop();

            // console.log('test');
            // End case -- result has been found, return the traced path.
            if(current_node.equal(end)) {
                return pathTo(current_node);
            }

            // Normal case -- move current_node from open to closed, process each of its neighbors.
            current_node.closed = true;

            // Find all neighbors for the current node.
            var neighbors = graph.get_neighbors(current_node);
            // console.log('neighbors', neighbors);
            for (var i = 0, il = neighbors.length; i < il; ++i) {
                var neighbor = neighbors[i];

                if (neighbor.closed || impassable(neighbor)) { // || impassable(neighbor, unit)// Not a valid node to process, skip to next neighbor.

                    continue; // Not a valid node to process, skip to next neighbor.
                }


                // console.log(current_node, neighbor, neighbor.visited, heuristic(neighbor, end));

                // The g score is the shortest distance from start to current node.
                // We need to check if the path we have arrived at this neighbor is the shortest one we have seen yet.
                var gScore = current_node.g + 1 //neighbor.getCost();
                // var gScore = current_node.g + neighbor.getCost();
                var beenVisited = neighbor.visited;

                if (!beenVisited || gScore < neighbor.g) {

                    // Found an optimal (so far) path to this node.  Take score for node to see how good it is.
                    neighbor.visited = true;
                    neighbor._parent = current_node;
                    neighbor.h = neighbor.h || heuristic(neighbor, end);
                    neighbor.g = gScore;
                    neighbor.f = neighbor.g + neighbor.h;

                    if (!beenVisited) {
                        // Pushing to heap will put it in proper place based on the 'f' value.
                        openHeap.push(neighbor);
                    }
                    else {
                        // Already seen the node, but since it has been rescored we need to reorder it in the heap
                        openHeap.rescoreElement(neighbor);
                    }
                }
            }
            // console.log('.');
        }
        return pathTo(end);
    }
};

function BinaryHeap(scoreFunction){
    this.content = [];
    this.scoreFunction = scoreFunction;
}

BinaryHeap.prototype = {
    push: function(element) {
        // Add the new element to the end of the array.
        this.content.push(element);

        // Allow it to sink down.
        this.sinkDown(this.content.length - 1);
    },
    pop: function() {
        // Store the first element so we can return it later.
        var result = this.content[0];
        // Get the element at the end of the array.
        var end = this.content.pop();
        // If there are any elements left, put the end element at the
        // start, and let it bubble up.
        if (this.content.length > 0) {
            this.content[0] = end;
            this.bubbleUp(0);
        }
        return result;
    },
    remove: function(node) {
        var i = this.content.indexOf(node);

        // When it is found, the process seen in 'pop' is repeated
        // to fill up the hole.
        var end = this.content.pop();

        if (i !== this.content.length - 1) {
            this.content[i] = end;

            if (this.scoreFunction(end) < this.scoreFunction(node)) {
                this.sinkDown(i);
            }
            else {
                this.bubbleUp(i);
            }
        }
    },
    size: function() {
        return this.content.length;
    },
    rescoreElement: function(node) {
        this.sinkDown(this.content.indexOf(node));
    },
    sinkDown: function(n) {
        // Fetch the element that has to be sunk.
        var element = this.content[n];

        // When at 0, an element can not sink any further.
        while (n > 0) {

            // Compute the parent element's index, and fetch it.
            var parentN = ((n + 1) >> 1) - 1,
                parent = this.content[parentN];
            // Swap the elements if the parent is greater.
            if (this.scoreFunction(element) < this.scoreFunction(parent)) {
                this.content[parentN] = element;
                this.content[n] = parent;
                // Update 'n' to continue at the new position.
                n = parentN;
            }
            // Found a parent that is less, no need to sink any further.
            else {
                break;
            }
        }
    },
    bubbleUp: function(n) {
        // Look up the target element and its score.
        var length = this.content.length,
            element = this.content[n],
            elemScore = this.scoreFunction(element);

        while(true) {
            // Compute the indices of the child elements.
            var child2N = (n + 1) << 1,
                child1N = child2N - 1;
            // This is used to store the new position of the element, if any.
            var swap = null,
                child1Score;
            // If the first child exists (is inside the array)...
            if (child1N < length) {
                // Look it up and compute its score.
                var child1 = this.content[child1N];
                child1Score = this.scoreFunction(child1);

                // If the score is less than our element's, we need to swap.
                if (child1Score < elemScore){
                    swap = child1N;
                }
            }

            // Do the same checks for the other child.
            if (child2N < length) {
                var child2 = this.content[child2N],
                    child2Score = this.scoreFunction(child2);
                if (child2Score < (swap === null ? elemScore : child1Score)) {
                    swap = child2N;
                }
            }

            // If the element needs to be moved, swap it, and continue.
            if (swap !== null) {
                this.content[n] = this.content[swap];
                this.content[swap] = element;
                n = swap;
            }
            // Otherwise, we are done.
            else {
                break;
            }
        }
    }
};

return {
    astar: astar
};

});
