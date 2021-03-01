class Node:
  def __init__(self,data=None):
    self.data = data
    self.next = None


class linked_list:
  def __init__(self):
    self.head = Node()
  
  def append(self,data):
    new_node = Node(data)
    current = self.head
    while current.next != None:
      current = current.next
    current.next = new_node
    
  def length(self):
    cur = self.head
    total = 0 
    while cur.next != None:
      total += 1 
      cur = cur.next
    return total

  def display(self):
    cur = self.head
    elements = []
    while cur.next != None:
      cur = cur.next
      elements.append(cur.data)
      cur = cur.next
    elements.append(cur.data)
    return elements

