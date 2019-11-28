# frozen_string_literal: true

# rubocop:disable ModuleLength
module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    if is_a? Array
      while i < size
        yield(self[i])
        i += 1
      end
    elsif is_a? Hash
      while i < size
        yield(key[i], value[i])
        i += 1
      end
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    if is_a? Array
      while i < size
        yield(self[i], i)
        i += 1
      end
    elsif is_a? Hash
      while i < size
        yield([keys[i], values[i]], i)
        i += 1
      end
    end
  end

  def my_select
    return to_enum unless block_given?

    my_array = []
    my_each do |element|
      next unless yield element
      
      my_array << element
    end
    my_array
  end

  def my_all?(expr = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    if block_given?
      my_each do |arg|
        next if yield arg

        return false
      end
    elsif !expr
      my_each do |arg|
        next if arg

        return false
      end
    elsif expr.is_a? Regexp
      my_each do |arg|
        next if arg.match(expr)

        return false
      end
    elsif expr.class == Class
      my_each do |arg|
        next if arg.is_a?(expr)

        return false
      end
    else
      my_each do |arg|
        next if arg == expr

        return false
      end
    end
    true
  end

  def my_any?(expr = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    if block_given?
      my_each do |arg|
        next unless yield arg

        return true
      end
    elsif !expr
      my_each do |arg|
        next unless arg

        return true
      end
    elsif expr.is_a? Regexp
      my_each do |arg|
        next if arg.match(expr).nil?

        return true
      end
    elsif expr.class == Class
      my_each do |arg|
        next unless arg.is_a?(expr)

        return true
      end
    else
      my_each do |arg|
        next unless arg == expr

        return true
      end
    end
    false
  end

  def my_none?(expr = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    if block_given?
      my_each do |arg|
        next unless yield arg

        return false
      end
    elsif !expr
      my_each do |arg|
        next unless arg

        return false
      end
    elsif expr.is_a? Regexp
      my_each do |arg|
        next if arg.match(expr).nil?

        return false
      end
    elsif expr.class == Class
      my_each do |arg|
        next unless arg.is_a?(expr)

        return false
      end
    else
      my_each do |arg|
        next unless arg == expr

        return false
      end
    end
    true
  end

  def my_count(arg = nil)
    counter = 0
    if arg
      my_each { |param| counter += 1 if param == arg }
    elsif block_given?
      my_each { |param| counter += 1 if yield(param) }
    else
      counter = size
    end
    counter
  end

  def my_map(arg = nil)
    return to_enum unless block_given?

    arr = []
    if arg
      my_each_with_index { |elem, val| arr[val] = arr.call(elem) }
    else
      my_each_with_index { |elem, val| arr[val] = yield(elem) }
    end
    arr
  end

  def my_inject(initial = nil, sym = nil, &block) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    sum = initial || first
    sum = first if initial.class == Symbol
    sum = initial if !initial.class == Symbol
    sum -= sum if sum != initial && sum.class != String
    my_each { |e| sum = block.call(sum, e) } if block_given?
    my_each { |e| sum = sum.send(sym, e) } if initial && sym
    my_each { |e| sum = sum.send(initial, e) } if initial.class == Symbol
    sum
  end

  def multiply_els(arr)
    arr.my_inject { |mult, z| mult * z }
  end
end

# rubocop:enable ModuleLength
