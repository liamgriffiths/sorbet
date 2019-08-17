# typed: __STDLIB_INTERNAL

# The `Enumerable` mixin provides collection classes with several
# traversal and searching methods, and with the ability to sort. The class
# must provide a method `each`, which yields successive members of the
# collection. If `Enumerable#max`, `#min`, or `#sort` is used, the
# objects in the collection must also implement a meaningful `<=>`
# operator, as these methods rely on an ordering between members of the
# collection.
module Enumerable
  extend T::Generic
  Elem = type_member(:out)

  abstract!

  sig do
    abstract.
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T.untyped)
  end
  sig {returns(T.self_type)}
  def each(&blk); end

  # Passes each element of the collection to the given block. The method
  # returns `true` if the block never returns `false` or `nil` . If the
  # block is not given, Ruby adds an implicit block of `{ |obj| obj }` which
  # will cause [all?](Enumerable.downloaded.ruby_doc#method-i-all-3F) to
  # return `true` when none of the collection members are `false` or `nil` .
  #
  # If instead a pattern is supplied, the method returns whether `pattern
  # === element` for every collection member.
  #
  #     %w[ant bear cat].all? { |word| word.length >= 3 } #=> true
  #     %w[ant bear cat].all? { |word| word.length >= 4 } #=> false
  #     %w[ant bear cat].all?(/t/)                        #=> false
  #     [1, 2i, 3.14].all?(Numeric)                       #=> true
  #     [nil, true, 99].all?                              #=> false
  #     [].all?                                           #=> true
  sig {returns(T::Boolean)}
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Boolean)
  end
  def all?(&blk); end

  # Passes each element of the collection to the given block. The method
  # returns `true` if the block ever returns a value other than `false` or
  # `nil` . If the block is not given, Ruby adds an implicit block of `{
  # |obj| obj }` that will cause
  # [any?](Enumerable.downloaded.ruby_doc#method-i-any-3F) to return `true`
  # if at least one of the collection members is not `false` or `nil` .
  #
  # If instead a pattern is supplied, the method returns whether `pattern
  # === element` for any collection member.
  #
  # ```ruby
  # %w[ant bear cat].any? { |word| word.length >= 3 } #=> true
  # %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
  # %w[ant bear cat].any?(/d/)                        #=> false
  # [nil, true, 99].any?(Integer)                     #=> true
  # [nil, true, 99].any?                              #=> true
  # [].any?                                           #=> false
  # ```
  sig {returns(T::Boolean)}
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Boolean)
  end
  def any?(&blk); end

  # Returns a new array with the results of running *block* once for every
  # element in *enum* .
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # (1..4).map { |i| i*i }      #=> [1, 4, 9, 16]
  # (1..4).collect { "cat"  }   #=> ["cat", "cat", "cat", "cat"]
  # ```
  sig do
    type_parameters(:U).params(
        blk: T.proc.params(arg0: Elem).returns(T.type_parameter(:U)),
    )
    .returns(T::Array[T.type_parameter(:U)])
  end
  sig {returns(T::Enumerator[Elem])}
  def collect(&blk); end

  # Returns a new array with the concatenated results of running *block*
  # once for every element in *enum* .
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # [1, 2, 3, 4].flat_map { |e| [e, -e] } #=> [1, -1, 2, -2, 3, -3, 4, -4]
  # [[1, 2], [3, 4]].flat_map { |e| e + [100] } #=> [1, 2, 100, 3, 4, 100]
  # ```
  sig do
    type_parameters(:U).params(
        blk: T.proc.params(arg0: Elem).returns(T::Enumerator[T.type_parameter(:U)]),
    )
    .returns(T::Array[T.type_parameter(:U)])
  end
  def collect_concat(&blk); end

  # Returns the number of items in `enum` through enumeration. If an
  # argument is given, the number of items in `enum` that are equal to
  # `item` are counted. If a block is given, it counts the number of
  # elements yielding a true value.
  #
  # ```ruby
  # ary = [1, 2, 4, 2]
  # ary.count               #=> 4
  # ary.count(2)            #=> 2
  # ary.count{ |x| x%2==0 } #=> 3
  # ```
  sig {returns(Integer)}
  sig do
    params(
        arg0: BasicObject,
    )
    .returns(Integer)
  end
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(Integer)
  end
  def count(arg0=T.unsafe(nil), &blk); end

  sig do
    params(
        n: Integer,
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(NilClass)
  end
  sig do
    params(
        n: Integer,
    )
    .returns(T::Enumerator[Elem])
  end
  def cycle(n=T.unsafe(nil), &blk); end

  sig do
    params(
        ifnone: Proc,
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T.nilable(Elem))
  end
  sig do
    params(
        ifnone: Proc,
    )
    .returns(T::Enumerator[Elem])
  end
  def detect(ifnone=T.unsafe(nil), &blk); end

  # Drops first n elements from *enum* , and returns rest elements in an
  # array.
  #
  # ```ruby
  # a = [1, 2, 3, 4, 5, 0]
  # a.drop(3)             #=> [4, 5, 0]
  # ```
  sig do
    params(
        n: Integer,
    )
    .returns(T::Array[Elem])
  end
  def drop(n); end

  # Drops elements up to, but not including, the first element for which the
  # block returns `nil` or `false` and returns an array containing the
  # remaining elements.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # a = [1, 2, 3, 4, 5, 0]
  # a.drop_while { |i| i < 3 }   #=> [3, 4, 5, 0]
  # ```
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Array[Elem])
  end
  sig {returns(T::Enumerator[Elem])}
  def drop_while(&blk); end

  sig do
    params(
        n: Integer,
        blk: T.proc.params(arg0: T::Array[Elem]).returns(BasicObject),
    )
    .returns(NilClass)
  end
  sig do
    params(
        n: Integer,
    )
    .returns(T::Enumerator[T::Array[Elem]])
  end
  def each_cons(n, &blk); end

  # Calls *block* with two arguments, the item and its index, for each item
  # in *enum* . Given arguments are passed through to each().
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # hash = Hash.new
  # %w(cat dog wombat).each_with_index { |item, index|
  #   hash[item] = index
  # }
  # hash   #=> {"cat"=>0, "dog"=>1, "wombat"=>2}
  # ```
  sig do
    params(
        blk: T.proc.params(arg0: Elem, arg1: Integer).returns(BasicObject),
    )
    .returns(T::Enumerable[Elem])
  end
  sig {returns(T::Enumerator[[Elem, Integer]])}
  def each_with_index(&blk); end

  # TODO: the arg1 type in blk should be `T.type_parameter(:U)`, but because of
  # issue #38, this won't work.
  # Iterates the given block for each element with an arbitrary object
  # given, and returns the initially given object.
  #
  # If no block is given, returns an enumerator.
  #
  # ```ruby
  # evens = (1..10).each_with_object([]) { |i, a| a << i*2 }
  # #=> [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
  # ```
  sig do
    type_parameters(:U).params(
        arg0: T.type_parameter(:U),
        blk: T.proc.params(arg0: Elem, arg1: T.untyped).returns(BasicObject),
    )
    .returns(T.type_parameter(:U))
  end
  sig do
    type_parameters(:U).params(
        arg0: T.type_parameter(:U),
    )
    .returns(T::Enumerator[[Elem, T.type_parameter(:U)]])
  end
  def each_with_object(arg0, &blk); end

  # Returns an array containing the items in *enum* .
  #
  # ```ruby
  # (1..7).to_a                       #=> [1, 2, 3, 4, 5, 6, 7]
  # { 'a'=>1, 'b'=>2, 'c'=>3 }.to_a   #=> [["a", 1], ["b", 2], ["c", 3]]
  #
  # require 'prime'
  # Prime.entries 10                  #=> [2, 3, 5, 7]
  # ```
  sig {returns(T::Array[Elem])}
  def entries(); end

  # Returns an array containing all elements of `enum` for which the given
  # `block` returns a true value.
  #
  # If no block is given, an
  # [Enumerator](https://ruby-doc.org/core-2.6.3/Enumerator.html) is
  # returned instead.
  #
  # ```ruby
  # (1..10).find_all { |i|  i % 3 == 0 }   #=> [3, 6, 9]
  #
  # [1,2,3,4,5].select { |num|  num.even?  }   #=> [2, 4]
  #
  # [:foo, :bar].filter { |x| x == :foo }   #=> [:foo]
  # ```
  #
  # See also [\#reject](Enumerable.downloaded.ruby_doc#method-i-reject).
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Array[Elem])
  end
  sig {returns(T::Enumerator[Elem])}
  def find_all(&blk); end

  # Compares each entry in *enum* with *value* or passes to *block* .
  # Returns the index for the first for which the evaluated value is
  # non-false. If no object matches, returns `nil`
  #
  # If neither block nor argument is given, an enumerator is returned
  # instead.
  #
  # ```ruby
  # (1..10).find_index  { |i| i % 5 == 0 and i % 7 == 0 }  #=> nil
  # (1..100).find_index { |i| i % 5 == 0 and i % 7 == 0 }  #=> 34
  # (1..100).find_index(50)                                #=> 49
  # ```
  sig do
    params(
        value: BasicObject,
    )
    .returns(T.nilable(Integer))
  end
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T.nilable(Integer))
  end
  sig {returns(T::Enumerator[Elem])}
  def find_index(value=T.unsafe(nil), &blk); end

  # Returns the first element, or the first `n` elements, of the enumerable.
  # If the enumerable is empty, the first form returns `nil`, and the
  # second form returns an empty array.
  #
  # ```ruby
  # %w[foo bar baz].first     #=> "foo"
  # %w[foo bar baz].first(2)  #=> ["foo", "bar"]
  # %w[foo bar baz].first(10) #=> ["foo", "bar", "baz"]
  # [].first                  #=> nil
  # [].first(10)              #=> []
  # ```
  sig {returns(T.nilable(Elem))}
  sig do
    params(
        n: Integer,
    )
    .returns(T.nilable(T::Array[Elem]))
  end
  def first(n=T.unsafe(nil)); end

  # Returns an array of every element in *enum* for which `Pattern ===
  # element` . If the optional *block* is supplied, each matching element is
  # passed to it, and the block’s result is stored in the output array.
  #
  # ```ruby
  # (1..100).grep 38..44   #=> [38, 39, 40, 41, 42, 43, 44]
  # c = IO.constants
  # c.grep(/SEEK/)         #=> [:SEEK_SET, :SEEK_CUR, :SEEK_END]
  # res = c.grep(/SEEK/) { |v| IO.const_get(v) }
  # res                    #=> [0, 1, 2]
  # ```
  sig do
    params(
        arg0: BasicObject,
    )
    .returns(T::Array[Elem])
  end
  sig do
    type_parameters(:U).params(
        arg0: BasicObject,
        blk: T.proc.params(arg0: Elem).returns(T.type_parameter(:U)),
    )
    .returns(T::Array[T.type_parameter(:U)])
  end
  def grep(arg0, &blk); end

  # Groups the collection by result of the block. Returns a hash where the
  # keys are the evaluated result from the block and the values are arrays
  # of elements in the collection that correspond to the key.
  #
  # If no block is given an enumerator is returned.
  #
  # ```ruby
  # (1..6).group_by { |i| i%3 }   #=> {0=>[3, 6], 1=>[1, 4], 2=>[2, 5]}
  # ```
  sig do
    type_parameters(:U).params(
        blk: T.proc.params(arg0: Elem).returns(T.type_parameter(:U)),
    )
    .returns(T::Hash[T.type_parameter(:U), T::Array[Elem]])
  end
  sig {returns(T::Enumerator[Elem])}
  def group_by(&blk); end

  # Returns `true` if any member of *enum* equals *obj* . Equality is tested
  # using `==` .
  #
  # ```ruby
  # IO.constants.include? :SEEK_SET          #=> true
  # IO.constants.include? :SEEK_NO_FURTHER   #=> false
  # IO.constants.member? :SEEK_SET          #=> true
  # IO.constants.member? :SEEK_NO_FURTHER   #=> false
  # ```
  sig do
    params(
        arg0: BasicObject,
    )
    .returns(T::Boolean)
  end
  def include?(arg0); end

  # Combines all elements of *enum* by applying a binary operation,
  # specified by a block or a symbol that names a method or operator.
  #
  # The *inject* and *reduce* methods are aliases. There is no performance
  # benefit to either.
  #
  # If you specify a block, then for each element in *enum* the block is
  # passed an accumulator value ( *memo* ) and the element. If you specify a
  # symbol instead, then each element in the collection will be passed to
  # the named method of *memo* . In either case, the result becomes the new
  # value for *memo* . At the end of the iteration, the final value of
  # *memo* is the return value for the method.
  #
  # If you do not explicitly specify an *initial* value for *memo* , then
  # the first element of collection is used as the initial value of *memo* .
  #
  # ```ruby
  # # Sum some numbers
  # (5..10).reduce(:+)                             #=> 45
  # # Same using a block and inject
  # (5..10).inject { |sum, n| sum + n }            #=> 45
  # # Multiply some numbers
  # (5..10).reduce(1, :*)                          #=> 151200
  # # Same using a block
  # (5..10).inject(1) { |product, n| product * n } #=> 151200
  # # find the longest word
  # longest = %w{ cat sheep bear }.inject do |memo, word|
  #    memo.length > word.length ? memo : word
  # end
  # longest                                        #=> "sheep"
  # ```
  sig do
    type_parameters(:Any).params(
        initial: T.type_parameter(:Any),
        arg0: Symbol,
    )
    .returns(T.untyped)
  end
  sig do
    params(
        arg0: Symbol,
    )
    .returns(T.untyped)
  end
  sig do
    params(
        initial: Elem,
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Elem),
    )
    .returns(Elem)
  end
  sig do
    params(
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Elem),
    )
    .returns(T.nilable(Elem))
  end
  def inject(initial=T.unsafe(nil), arg0=T.unsafe(nil), &blk); end

  # Returns the object in *enum* with the maximum value. The first form
  # assumes all objects implement `Comparable` ; the second uses the block
  # to return *a \<=\> b* .
  #
  # ```ruby
  # a = %w(albatross dog horse)
  # a.max                                   #=> "horse"
  # a.max { |a, b| a.length <=> b.length }  #=> "albatross"
  # ```
  #
  # If the `n` argument is given, maximum `n` elements are returned as an
  # array, sorted in descending order.
  #
  # ```ruby
  # a = %w[albatross dog horse]
  # a.max(2)                                  #=> ["horse", "dog"]
  # a.max(2) {|a, b| a.length <=> b.length }  #=> ["albatross", "horse"]
  # [5, 1, 3, 4, 2].max(3)                    #=> [5, 4, 3]
  # ```
  sig {returns(T.nilable(Elem))}
  sig do
    params(
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Integer),
    )
    .returns(T.nilable(Elem))
  end
  sig do
    params(
        arg0: Integer,
    )
    .returns(T::Array[Elem])
  end
  sig do
    params(
        arg0: Integer,
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Integer),
    )
    .returns(T::Array[Elem])
  end
  def max(arg0=T.unsafe(nil), &blk); end

  sig {returns(T::Enumerator[Elem])}
  # The block returning T::Array[BasicObject] is just a stopgap solution to get better
  # signatures. In reality, it should be recursively defined as an Array of elements of
  # the same T.any
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(T.any(Comparable, T::Array[BasicObject])),
    )
    .returns(T.nilable(Elem))
  end
  sig do
    params(
        arg0: Integer,
    )
    .returns(T::Enumerator[Elem])
  end
  # The block returning T::Array[BasicObject] is just a stopgap solution to get better
  # signatures. In reality, it should be recursively defined as an Array of elements of
  # the same T.any
  # Returns the object in *enum* that gives the maximum value from the given
  # block.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # a = %w(albatross dog horse)
  # a.max_by { |x| x.length }   #=> "albatross"
  # ```
  #
  # If the `n` argument is given, maximum `n` elements are returned as an
  # array. These `n` elements are sorted by the value from the given block,
  # in descending order.
  #
  # ```ruby
  # a = %w[albatross dog horse]
  # a.max_by(2) {|x| x.length } #=> ["albatross", "horse"]
  # ```
  #
  # enum.max\_by(n) can be used to implement weighted random sampling.
  # Following example implements and use Enumerable\#wsample.
  #
  # ```ruby
  # module Enumerable
  #   # weighted random sampling.
  #   #
  #   # Pavlos S. Efraimidis, Paul G. Spirakis
  #   # Weighted random sampling with a reservoir
  #   # Information Processing Letters
  #   # Volume 97, Issue 5 (16 March 2006)
  #   def wsample(n)
  #     self.max_by(n) {|v| rand ** (1.0/yield(v)) }
  #   end
  # end
  # e = (-20..20).to_a*10000
  # a = e.wsample(20000) {|x|
  #   Math.exp(-(x/5.0)**2) # normal distribution
  # }
  # # a is 20000 samples from e.
  # p a.length #=> 20000
  # h = a.group_by {|x| x }
  # -10.upto(10) {|x| puts "*" * (h[x].length/30.0).to_i if h[x] }
  # #=> *
  # #   ***
  # #   ******
  # #   ***********
  # #   ******************
  # #   *****************************
  # #   *****************************************
  # #   ****************************************************
  # #   ***************************************************************
  # #   ********************************************************************
  # #   ***********************************************************************
  # #   ***********************************************************************
  # #   **************************************************************
  # #   ****************************************************
  # #   ***************************************
  # #   ***************************
  # #   ******************
  # #   ***********
  # #   *******
  # #   ***
  # #   *
  # ```
  sig do
    params(
        arg0: Integer,
        blk: T.proc.params(arg0: Elem).returns(T.any(Comparable, T::Array[BasicObject])),
    )
    .returns(T::Array[Elem])
  end
  def max_by(arg0=T.unsafe(nil), &blk); end

  # Returns the object in *enum* with the minimum value. The first form
  # assumes all objects implement `Comparable` ; the second uses the block
  # to return *a \<=\> b* .
  #
  # ```ruby
  # a = %w(albatross dog horse)
  # a.min                                   #=> "albatross"
  # a.min { |a, b| a.length <=> b.length }  #=> "dog"
  # ```
  #
  # If the `n` argument is given, minimum `n` elements are returned as a
  # sorted array.
  #
  # ```ruby
  # a = %w[albatross dog horse]
  # a.min(2)                                  #=> ["albatross", "dog"]
  # a.min(2) {|a, b| a.length <=> b.length }  #=> ["dog", "horse"]
  # [5, 1, 3, 4, 2].min(3)                    #=> [1, 2, 3]
  # ```
  sig {returns(T.nilable(Elem))}
  sig do
    params(
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Integer),
    )
    .returns(T.nilable(Elem))
  end
  sig do
    params(
        arg0: Integer,
    )
    .returns(T::Array[Elem])
  end
  sig do
    params(
        arg0: Integer,
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Integer),
    )
    .returns(T::Array[Elem])
  end
  def min(arg0=T.unsafe(nil), &blk); end

  sig {returns(T::Enumerator[Elem])}
  # The block returning T::Array[BasicObject] is just a stopgap solution to get better
  # signatures. In reality, it should be recursively defined as an Array of elements of
  # the same T.any
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(T.any(Comparable, T::Array[BasicObject])),
    )
    .returns(T.nilable(Elem))
  end
  sig do
    params(
        arg0: Integer,
    )
    .returns(T::Enumerator[Elem])
  end
  # The block returning T::Array[BasicObject] is just a stopgap solution to get better
  # signatures. In reality, it should be recursively defined as an Array of elements of
  # the same T.any
  # Returns the object in *enum* that gives the minimum value from the given
  # block.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # a = %w(albatross dog horse)
  # a.min_by { |x| x.length }   #=> "dog"
  # ```
  #
  # If the `n` argument is given, minimum `n` elements are returned as an
  # array. These `n` elements are sorted by the value from the given block.
  #
  # ```ruby
  # a = %w[albatross dog horse]
  # p a.min_by(2) {|x| x.length } #=> ["dog", "horse"]
  # ```
  sig do
    params(
        arg0: Integer,
        blk: T.proc.params(arg0: Elem).returns(T.any(Comparable, T::Array[BasicObject])),
    )
    .returns(T::Array[Elem])
  end
  def min_by(arg0=T.unsafe(nil), &blk); end

  # Returns a two element array which contains the minimum and the maximum
  # value in the enumerable. The first form assumes all objects implement
  # `Comparable` ; the second uses the block to return *a \<=\> b* .
  #
  # ```ruby
  # a = %w(albatross dog horse)
  # a.minmax                                  #=> ["albatross", "horse"]
  # a.minmax { |a, b| a.length <=> b.length } #=> ["dog", "albatross"]
  # ```
  sig {returns([T.nilable(Elem), T.nilable(Elem)])}
  sig do
    params(
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Integer),
    )
    .returns([T.nilable(Elem), T.nilable(Elem)])
  end
  def minmax(&blk); end

  sig {returns([T.nilable(Elem), T.nilable(Elem)])}
  # The block returning T::Array[BasicObject] is just a stopgap solution to get better
  # signatures. In reality, it should be recursively defined as an Array of elements of
  # the same T.any
  # Returns a two element array containing the objects in *enum* that
  # correspond to the minimum and maximum values respectively from the given
  # block.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # a = %w(albatross dog horse)
  # a.minmax_by { |x| x.length }   #=> ["dog", "albatross"]
  # ```
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(T.any(Comparable, T::Array[BasicObject])),
    )
    .returns(T::Enumerator[Elem])
  end
  def minmax_by(&blk); end

  # Passes each element of the collection to the given block. The method
  # returns `true` if the block never returns `true` for all elements. If
  # the block is not given, `none?` will return `true` only if none of the
  # collection members is true.
  #
  # If instead a pattern is supplied, the method returns whether `pattern
  # === element` for none of the collection members.
  #
  # ```ruby
  # %w{ant bear cat}.none? { |word| word.length == 5 } #=> true
  # %w{ant bear cat}.none? { |word| word.length >= 4 } #=> false
  # %w{ant bear cat}.none?(/d/)                        #=> true
  # [1, 3.14, 42].none?(Float)                         #=> false
  # [].none?                                           #=> true
  # [nil].none?                                        #=> true
  # [nil, false].none?                                 #=> true
  # [nil, false, true].none?                           #=> false
  # ```
  sig {returns(T::Boolean)}
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Boolean)
  end
  def none?(&blk); end

  # Passes each element of the collection to the given block. The method
  # returns `true` if the block returns `true` exactly once. If the block is
  # not given, `one?` will return `true` only if exactly one of the
  # collection members is true.
  #
  # If instead a pattern is supplied, the method returns whether `pattern
  # === element` for exactly one collection member.
  #
  # ```ruby
  # %w{ant bear cat}.one? { |word| word.length == 4 }  #=> true
  # %w{ant bear cat}.one? { |word| word.length > 4 }   #=> false
  # %w{ant bear cat}.one? { |word| word.length < 4 }   #=> false
  # %w{ant bear cat}.one?(/t/)                         #=> false
  # [ nil, true, 99 ].one?                             #=> false
  # [ nil, true, false ].one?                          #=> true
  # [ nil, true, 99 ].one?(Integer)                    #=> true
  # [].one?                                            #=> false
  # ```
  sig {returns(T::Boolean)}
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Boolean)
  end
  def one?(&blk); end

  # Returns two arrays, the first containing the elements of *enum* for
  # which the block evaluates to true, the second containing the rest.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # (1..6).partition { |v| v.even? }  #=> [[2, 4, 6], [1, 3, 5]]
  # ```
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns([T::Array[Elem], T::Array[Elem]])
  end
  sig {returns(T::Enumerator[Elem])}
  def partition(&blk); end

  # Returns an array for all elements of `enum` for which the given `block`
  # returns `false` .
  #
  # If no block is given, an
  # [Enumerator](https://ruby-doc.org/core-2.6.3/Enumerator.html) is
  # returned instead.
  #
  # ```ruby
  # (1..10).reject { |i|  i % 3 == 0 }   #=> [1, 2, 4, 5, 7, 8, 10]
  #
  # [1, 2, 3, 4, 5].reject { |num| num.even? } #=> [1, 3, 5]
  # ```
  #
  # See also [\#find\_all](Enumerable.downloaded.ruby_doc#method-i-find_all)
  # .
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Array[Elem])
  end
  sig {returns(T::Enumerator[Elem])}
  def reject(&blk); end

  # Builds a temporary array and traverses that array in reverse order.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # (1..3).reverse_each { |v| p v }
  # ```
  #
  # produces:
  #
  # ```ruby
  # 3
  # 2
  # 1
  # ```
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Enumerator[Elem])
  end
  sig {returns(T::Enumerator[Elem])}
  def reverse_each(&blk); end

  # Returns an array containing the items in *enum* sorted.
  #
  # Comparisons for the sort will be done using the items’ own `<=>`
  # operator or using an optional code block.
  #
  # The block must implement a comparison between `a` and `b` and return an
  # integer less than 0 when `b` follows `a`, `0` when `a` and `b` are
  # equivalent, or an integer greater than 0 when `a` follows `b` .
  #
  # The result is not guaranteed to be stable. When the comparison of two
  # elements returns `0`, the order of the elements is unpredictable.
  #
  # ```ruby
  # %w(rhea kea flea).sort           #=> ["flea", "kea", "rhea"]
  # (1..10).sort { |a, b| b <=> a }  #=> [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
  # ```
  #
  # See also [\#sort\_by](Enumerable.downloaded.ruby_doc#method-i-sort_by).
  # It implements a Schwartzian transform which is useful when key
  # computation or comparison is expensive.
  sig {returns(T::Array[Elem])}
  sig do
    params(
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Integer),
    )
    .returns(T::Array[Elem])
  end
  def sort(&blk); end
  # The block returning T::Array[BasicObject] is just a stopgap solution to get better
  # signatures. In reality, it should be recursively defined as an Array of elements of
  # the same T.any
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(T.any(Comparable, T::Array[BasicObject])),
    )
    .returns(T::Array[Elem])
  end
  sig {returns(T::Enumerator[Elem])}
  def sort_by(&blk); end

  # Returns first n elements from *enum* .
  #
  # ```ruby
  # a = [1, 2, 3, 4, 5, 0]
  # a.take(3)             #=> [1, 2, 3]
  # a.take(30)            #=> [1, 2, 3, 4, 5, 0]
  # ```
  sig do
    params(
        n: Integer,
    )
    .returns(T.nilable(T::Array[Elem]))
  end
  def take(n); end

  # Passes elements to the block until the block returns `nil` or `false`,
  # then stops iterating and returns an array of all prior elements.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # a = [1, 2, 3, 4, 5, 0]
  # a.take_while { |i| i < 3 }   #=> [1, 2]
  # ```
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Array[Elem])
  end
  sig {returns(T::Enumerator[Elem])}
  def take_while(&blk); end

  # Implemented in C++
  # Returns the result of interpreting *enum* as a list of `[key, value]`
  # pairs.
  #
  #     %i[hello world].each_with_index.to_h
  #       # => {:hello => 0, :world => 1}
  #
  # If a block is given, the results of the block on each element of the
  # enum will be used as pairs.
  #
  # ```ruby
  # (1..5).to_h {|x| [x, x ** 2]}
  #   #=> {1=>1, 2=>4, 3=>9, 4=>16, 5=>25}
  # ```
  sig {returns(T::Hash[T.untyped, T.untyped])}
  def to_h(); end

  sig do
    params(
        n: Integer,
        blk: T.proc.params(arg0: T::Array[Elem]).returns(BasicObject),
    )
    .returns(NilClass)
  end
  sig do
    params(
        n: Integer,
    )
    .returns(T::Enumerator[T::Array[Elem]])
  end
  def each_slice(n, &blk); end

  sig do
    params(
        ifnone: Proc,
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T.nilable(Elem))
  end
  sig do
    params(
        ifnone: Proc,
    )
    .returns(T::Enumerator[Elem])
  end
  def find(ifnone=T.unsafe(nil), &blk); end

  # N.B. this signature is wrong; Our generic method implementation
  # cannot model the correct signature, so we pass through the return
  # type of the block and then fix it up in an ad-hoc way in Ruby. A
  # more-correct signature might be:
  #   sig do
  #     type_parameters(:U).params(
  #       blk: T.proc.params(arg0: Elem).returns(T.any(T::Array[T.type_parameter(:U)], T.type_parameter(:U)),
  #     )
  #     .returns(T.type_parameter(:U))
  #   end
  #
  # But that would require a lot more sophistication from our generic
  # method inference.
  # Returns a new array with the concatenated results of running *block*
  # once for every element in *enum* .
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # [1, 2, 3, 4].flat_map { |e| [e, -e] } #=> [1, -1, 2, -2, 3, -3, 4, -4]
  # [[1, 2], [3, 4]].flat_map { |e| e + [100] } #=> [1, 2, 100, 3, 4, 100]
  # ```
  sig do
    type_parameters(:U).params(
        blk: T.proc.params(arg0: Elem).returns(T.type_parameter(:U)),
    )
    .returns(T.type_parameter(:U))
  end
  sig {returns(T::Enumerator[Elem])}
  def flat_map(&blk); end

  # Returns a new array with the results of running *block* once for every
  # element in *enum* .
  #
  # If no block is given, an enumerator is returned instead.
  #
  # ```ruby
  # (1..4).map { |i| i*i }      #=> [1, 4, 9, 16]
  # (1..4).collect { "cat"  }   #=> ["cat", "cat", "cat", "cat"]
  # ```
  sig do
    type_parameters(:U).params(
        blk: T.proc.params(arg0: Elem).returns(T.type_parameter(:U)),
    )
    .returns(T::Array[T.type_parameter(:U)])
  end
  sig {returns(T::Enumerator[Elem])}
  def map(&blk); end

  # Returns `true` if any member of *enum* equals *obj* . Equality is tested
  # using `==` .
  #
  # ```ruby
  # IO.constants.include? :SEEK_SET          #=> true
  # IO.constants.include? :SEEK_NO_FURTHER   #=> false
  # IO.constants.member? :SEEK_SET          #=> true
  # IO.constants.member? :SEEK_NO_FURTHER   #=> false
  # ```
  sig do
    params(
        arg0: BasicObject,
    )
    .returns(T::Boolean)
  end
  def member?(arg0); end

  # Combines all elements of *enum* by applying a binary operation,
  # specified by a block or a symbol that names a method or operator.
  #
  # The *inject* and *reduce* methods are aliases. There is no performance
  # benefit to either.
  #
  # If you specify a block, then for each element in *enum* the block is
  # passed an accumulator value ( *memo* ) and the element. If you specify a
  # symbol instead, then each element in the collection will be passed to
  # the named method of *memo* . In either case, the result becomes the new
  # value for *memo* . At the end of the iteration, the final value of
  # *memo* is the return value for the method.
  #
  # If you do not explicitly specify an *initial* value for *memo* , then
  # the first element of collection is used as the initial value of *memo* .
  #
  # ```ruby
  # # Sum some numbers
  # (5..10).reduce(:+)                             #=> 45
  # # Same using a block and inject
  # (5..10).inject { |sum, n| sum + n }            #=> 45
  # # Multiply some numbers
  # (5..10).reduce(1, :*)                          #=> 151200
  # # Same using a block
  # (5..10).inject(1) { |product, n| product * n } #=> 151200
  # # find the longest word
  # longest = %w{ cat sheep bear }.inject do |memo, word|
  #    memo.length > word.length ? memo : word
  # end
  # longest                                        #=> "sheep"
  # ```
  sig do
    type_parameters(:Any).params(
        initial: T.type_parameter(:Any),
        arg0: Symbol,
    )
    .returns(T.untyped)
  end
  sig do
    params(
        arg0: Symbol,
    )
    .returns(T.untyped)
  end
  sig do
    params(
        initial: Elem,
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Elem),
    )
    .returns(Elem)
  end
  sig do
    params(
        blk: T.proc.params(arg0: Elem, arg1: Elem).returns(Elem),
    )
    .returns(T.nilable(Elem))
  end
  def reduce(initial=T.unsafe(nil), arg0=T.unsafe(nil), &blk); end

  # Returns an array containing all elements of `enum` for which the given
  # `block` returns a true value.
  #
  # If no block is given, an
  # [Enumerator](https://ruby-doc.org/core-2.6.3/Enumerator.html) is
  # returned instead.
  #
  # ```ruby
  # (1..10).find_all { |i|  i % 3 == 0 }   #=> [3, 6, 9]
  #
  # [1,2,3,4,5].select { |num|  num.even?  }   #=> [2, 4]
  #
  # [:foo, :bar].filter { |x| x == :foo }   #=> [:foo]
  # ```
  #
  # See also [\#reject](Enumerable.downloaded.ruby_doc#method-i-reject).
  sig do
    params(
        blk: T.proc.params(arg0: Elem).returns(BasicObject),
    )
    .returns(T::Array[Elem])
  end
  sig {returns(T::Enumerator[Elem])}
  def select(&blk); end

  # Returns an array containing the items in *enum* .
  #
  # ```ruby
  # (1..7).to_a                       #=> [1, 2, 3, 4, 5, 6, 7]
  # { 'a'=>1, 'b'=>2, 'c'=>3 }.to_a   #=> [["a", 1], ["b", 2], ["c", 3]]
  #
  # require 'prime'
  # Prime.entries 10                  #=> [2, 3, 5, 7]
  # ```
  sig {returns(T::Array[Elem])}
  def to_a(); end

  # Returns a lazy enumerator, whose methods map/collect,
  # flat\_map/collect\_concat, select/find\_all, reject, grep,
  # [\#grep\_v](Enumerable.downloaded.ruby_doc#method-i-grep_v), zip, take,
  # [\#take\_while](Enumerable.downloaded.ruby_doc#method-i-take_while),
  # drop, and
  # [\#drop\_while](Enumerable.downloaded.ruby_doc#method-i-drop_while)
  # enumerate values only on an as-needed basis. However, if a block is
  # given to zip, values are enumerated immediately.
  #
  #
  # The following program finds pythagorean triples:
  #
  # ```ruby
  # def pythagorean_triples
  #   (1..Float::INFINITY).lazy.flat_map {|z|
  #     (1..z).flat_map {|x|
  #       (x..z).select {|y|
  #         x**2 + y**2 == z**2
  #       }.map {|y|
  #         [x, y, z]
  #       }
  #     }
  #   }
  # end
  # # show first ten pythagorean triples
  # p pythagorean_triples.take(10).force # take is lazy, so force is needed
  # p pythagorean_triples.first(10)      # first is eager
  # # show pythagorean triples less than 100
  # p pythagorean_triples.take_while { |*, z| z < 100 }.force
  # ```
  sig { returns(Enumerator::Lazy[Elem])}
  def lazy(); end
end