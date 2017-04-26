require 'pry'

class BinaryTreeNode

  attr_accessor :value
  attr_reader :left, :right

  def initialize(value)
    @value = value
    @left  = nil
    @right = nil
  end

  def insert_left(value)
    @left = BinaryTreeNode.new(value)
    return @left
  end

  def insert_right(value)
    @right = BinaryTreeNode.new(value)
    return @right
  end
end

def superbalanced?(binary_tree)
  nodes_to_test = [binary_tree]
  superbalanced = true
  depth_flag = false

  while nodes_to_test.length > 0 && superbalanced == true
    new_nodes_to_test = []
    found_leaf = false
    nodes_to_test.each do |node|
      no_left_node = false
      [node.left, node.right].each do |child_node|
        if child_node
          new_nodes_to_test.push(child_node)
          superbalanced = false if depth_flag
        end
      end
      found_leaf = true if !node.right && !node.left
    end
    nodes_to_test = new_nodes_to_test
    depth_flag = true if found_leaf
  end

  return superbalanced
end

def is_balanced(tree_root)

    # a tree with no nodes is superbalanced, since there are no leaves!
    if !tree_root
        return true
    end

    depths = [] # we short-circuit as soon as we find more than 2

    # we'll treat this array as a stack that will store pairs [node, depth]
    nodes = []
    nodes.push([tree_root, 0])

    while !nodes.empty?

        # pop a node and its depth from the top of our stack
        node, depth = nodes.pop

        # case: we found a leaf
        if !node.left && !node.right

            # we only care if it's a new depth
            if !depths.include? depth
                depths.push(depth)

                # two ways we might now have an unbalanced tree:
                #   1) more than 2 different leaf depths
                #   2) 2 leaf depths that are more than 1 apart
                if (depths.length > 2) || \
                        (depths.length == 2 && (depths[0] - depths[1]).abs > 1)
                    return false
                end
            end

        # case: this isn't a leaf - keep stepping down
        else
            if node.left
                nodes.push([node.left, depth + 1])
            end
            if node.right
                nodes.push([node.right, depth + 1])
            end
        end
    end

    return true
end

nodes_to_fill = [BinaryTreeNode.new("T")]

iterations = 0
while nodes_to_fill.length > 0 || iterations > 5000
  current_node = nodes_to_fill.pop
  nodes_to_fill.push(current_node.insert_left("#{current_node.value}_1")) if rand(1..10) > 2
  nodes_to_fill.push(current_node.insert_right("#{current_node.value}_0")) if rand(1..10) > 2
  iterations += 1
end

puts "Tree built"

# test_tree_0 = test_tree.insert_left("0")
# test_tree_0_0 = test_tree_0.insert_left("0_0")
# test_tree_0_0_0 = test_tree_0_0.insert_left("0_0_0")
# test_tree_0_1 = test_tree_0.insert_right("0_1")

# test_tree_1 = test_tree.insert_right("1")
# test_tree_1_0 = test_tree_1.insert_left("1_0")
# test_tree_1_0_0 = test_tree_1_0.insert_left("1_0_0")
# test_tree_1_1 = test_tree_1.insert_right("1_1")
# test_tree_1_1_1 = test_tree_1_1.insert_right("1_1_1")
# test_tree_1_1_1_1 = test_tree_1_1_1.insert_right("1_1_1_1")

puts superbalanced?(test_tree)



