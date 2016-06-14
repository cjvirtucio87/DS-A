class List
  attr_accessor :head, :tail, :p1, :p2

  def initialize(link)
    @head = link
    @tail = link.next
    @p1 = Link.new(nil)
    @p2 = Link.new(nil)
    @p1.next = @head
    @p2.next = @head
  end

  def insertHead(link)
    link.next = @head
    @head = link
    @p1.next = @head
    @p2.next = @head
  end

  def getLength
    count = 1
    link = @head
    while link.next != nil
      count += 1
      link = link.next
    end
    count
  end

  #Remove duplicates in list.
  def removeDups
    self.eachLink do |link|
      if dup = link.findDup
        self.deleteLink link, dup
      end
    end
  end

  #Iterate through list.
  def eachLink
    p = Link.new(nil)
    p.next = @head
    while (p.next != nil) && (p.next.next != nil) 
      yield p.next
      p.next = p.next.next
    end
  end

  def deleteLink(start,target)
    p = Link.new(nil)
    p.next = start
    while p.next.next != target
      p.next = p.next.next
    end
    link = p.next
    link.next = link.next.next
  end

  def traverse(start,k)
    p = Link.new(nil)
    p.next = start
    i = 0
    while i < k
      return nil if p.next.next == nil
      p.next = p.next.next
      i += 1
    end
    p.next
  end

end

class Link
  attr_accessor :data, :next

  def initialize(data)
    @data = data
    @next = nil
  end

  def findDup
    p = Link.new(nil)
    p.next = self.next
    while p.next.next != nil
      return p.next if self.data == p.next.data
      p.next = p.next.next
    end
    nil
  end

end

#We just want to give p2 a headstart. Not have it jump two steps every iteration.
def initializePointers (list)
  count = 0
  while count < list.getLength/2
    list.p2.next = list.p2.next.next
    count += 1
  end
end

#Pair up the links.
def pairLinks (list)
  count = 0;
  while count < list.getLength/2
    p1_buffer = list.p1.next
    list.p1.next.next = list.p2.next
    list.p1.next = p1_buffer.next
    list.p2.next = list.p2.next.next
    count += 1
  end
end

#Find the kth to the last link.
def findToTheLast (k, list)
  p = Link.new(nil)
  list.eachLink do |link|
    p.next = list.traverse link, k
    return link if p.next.next == nil
  end
end

def testLink(input)
  link = Link.new(input)
  list = List.new(link)
  dataCheck = link.data == input
  nilCheck = link.next == nil

  #Constructor check.
  constructorCheck = (list.head.next == nil) && \
                     (list.head.data == input) && \
                     (list.tail == nil)

  #Insertion check.
  list.insertHead(Link.new(300))
  insertionCheck = (list.head.next != nil) && \
                   (list.head.data != input) && \
                   (list.head.next.next == nil) && \
                   (list.head.next.data == input)

  #New list with insertions.
  new_list = List.new(Link.new(2))

  5.times do
    new_list.insertHead Link.new(2 * new_list.head.data)
  end


  #Length check.
  lengthCheck = new_list.getLength == 6

  #Pointer check.
  initializePointers new_list
  pointerCheck = new_list.p2.next.data == 8

  #Pairing up links
  pairLinks new_list
  pairCheck = new_list.head.next.data == 8

  new_new_list = List.new(Link.new(2))

  5.times do
    new_new_list.insertHead Link.new(2 * new_new_list.head.data)
  end
  
  #Test iterator.
  new_new_list.eachLink { |link| link.data *= 10 }
  iteratorCheck = new_new_list.head.data == 640

  #Test deletion.
  before_len = new_new_list.getLength
  a = new_new_list.head.next.next
  new_new_list.deleteLink(new_new_list.head,a)
  deleteCheck = before_len != new_new_list.getLength

  #Test find duplicate.
  new_link = Link.new(new_new_list.head.next.next.data)
  new_new_list.insertHead new_link
  dupCheck = new_link.data == new_new_list.head.findDup.data

  #Remove duplicate.
  new_new_list.removeDups
  dupCheckAll = lambda do
    new_new_list.eachLink do |link|
      return false if link.findDup
    end
    return true
  end

  #Traversal check
  traversalCheck = !!new_new_list.traverse(new_new_list.head,4)
  puts new_new_list.traverse(new_new_list.head,2).data

  #Find kth to the last check
  toTheLastCheck = findToTheLast(2,new_new_list) == \
                   new_new_list.traverse(new_new_list.head,2)

  #Tests.
  return dataCheck && \
         nilCheck && \
         constructorCheck && \
         insertionCheck && \
         lengthCheck && \
         pointerCheck && \
         pairCheck && \
         iteratorCheck &&\
         deleteCheck && \
         dupCheckAll.() && \
         traversalCheck && \
         toTheLastCheck

end


puts testLink(500)