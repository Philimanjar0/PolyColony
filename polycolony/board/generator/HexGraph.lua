local GraphUtils = require('board.generator.GraphUtils')

HexGraph = {}

setmetatable(HexGraph, {
    __call = function()
        self = {}

        -- The collection of nodes in the graph.
        -- Maps a node to its neighbors.
        self.nodes = {}

        -- Add a node to the graph. Will automatically connect to adjacent nodes that are also in the graph.
        -- @param x The x value of the node to add in axial hex coordinates.
        -- @param y The y value of the node ot add in axial hex coordinates.
        function self.addNode(x, y)
            node = GraphUtils.getKeyForNode(x, y)
            --print(node)
            self.nodes[node] = {}
            for _,neighbor in pairs(GraphUtils.getAllNeighbors(x, y)) do
                neighborKey = GraphUtils.getKeyForNode(neighbor[1], neighbor[2])
                if self.nodes[neighborKey] then
                    table.insert(self.nodes[node], neighbor)
                    table.insert(self.nodes[neighborKey], {x, y})
                end
            end
        end

        -- Remove a node from the graph. Will automatically remove all edges.
        -- @param x The x value of the node to remove in axial hex coordinates.
        -- @param y The y value of the node ot remove in axial hex coordinates.
        function self.removeNode(x, y)
            for _,neighbor in pairs(GraphUtils.getAllNeighbors(x, y)) do
                nKey = GraphUtils.getKeyForNode(neighbor[1], neighbor[2])
                if self.nodes[nKey] then
                    for i,node in pairs(self.nodes[nKey]) do
                        if node[1] == x and node[2] == y then
                            table.remove(self.nodes[nKey], i)
                        end
                    end
                end
            end
            self.nodes[{x,y}] = nil
        end

        -- Get actual neighbors of given node.
        -- @param x The x value of given node in axial hex coordinates.
        -- @param y The y value of the given node in axial hex coordinates.
        -- @return list of neighbors. Returns as a list of a list of keys in the form of strings returned by GraphUtils.getKeyForNode.
        function self.getNeighbors(node)
            return self.nodes[node]
        end

        -- Get all nodes in the graph.
        -- @return list of all nodes. Returns as a list of a list of integers.
        function self.getNodeTuples()
            local nodes = {}
            for node,_ in pairs(self.nodes) do
                table.insert(nodes, {tonumber(GraphUtils.split(node, ";")[1]), tonumber(GraphUtils.split(node, ";")[2])})
            end
            return nodes
        end

        function self.getNodes()
            return self.nodes
        end
        
        return self
    end,
})

return HexGraph
