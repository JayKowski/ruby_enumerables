# frozen_string_literal: true

module Enumerables # rubocop:disable Metrics/ModuleLength
  def my_each
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    i = 0
    array = []
    while i < size
      array << self[i] if yield(self[i])
      i += 1
    end
    array
  end

  def my_any?
    final = false
    my_each { |param| final = true if yield(param) }
    final
  end

  def my_all?
    # final = false
    my_each { |value| yield(value) ? true : false }
    # final
  end

  def my_none?
    final = true
    my_each { |param| final = false if yield(param) }
    final
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
    arr = []
    if arg
      my_each_with_index { |elem, val| arr[val] = arr.call(elem) }
    else
      my_each_with_index { |elem, val| arr[val] = yield(elem) }
    end
    arr
  end

  def my_inject(starter = nil)
    result = starter.nil? ? self[0] : starter
    my_each { |v| result = yield(result, v) }
    result
  end

  def multiply_els(arr)
    arr.my_inject { |mult, z| mult * z }
  end
end
