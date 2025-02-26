

class QuadTreeNode {
  bool covered = false;
  final List<QuadTreeNode?> children = List<QuadTreeNode?>.filled(4, null);
}

class QuadTree {
  final QuadTreeNode root = QuadTreeNode();

  void coverTile(int z, int x, int y) {
    QuadTreeNode current = root;

    if (current.covered) return;

    for (int level = z - 1; level >= 0; level--) {
      if (current.covered) return;
      final int quad = (((y >> level) & 1) << 1) | ((x >> level) & 1);

      if (current.children[quad] == null) {
        current.children[quad] = QuadTreeNode();
      }
      current = current.children[quad]!;
    }
    current.covered = true;
    current.children.fillRange(0, 4, null);
  }

  bool isCovered(int z, int x, int y) {
    QuadTreeNode current = root;
    if (current.covered) return true;

    for (int level = z - 1; level >= 0; level--) {
      if (current.covered) return true;
      final int quad = (((y >> level) & 1) << 1) | ((x >> level) & 1);
      if (current.children[quad] == null) {
        return false;
      }
      current = current.children[quad]!;
    }
    return current.covered;
  }
}

