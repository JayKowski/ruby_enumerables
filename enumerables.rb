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

  def my_inject(*args) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    arr = to_a.dup
    if args[0].nil?
      operation = arr.shift
    elsif args[1].nil? && !block_given?
      symbol = args[0]
      operation = arr.shift
    elsif args[1].nil? && block_given?
      operation = args[0]
    else
      operation = args[0]
      symbol = args[1]
    end
    arr[0..-1].my_each do |elem|
      operation = if symbol
                    operation.send(symbol, elem)
                  else
                    yield(operation, elem)
                  end
    end
    operation
  end
end

def multiply_els(arr)
  arr.my_inject { |mult, z| mult * z }
end

# rubocop:enable ModuleLength
