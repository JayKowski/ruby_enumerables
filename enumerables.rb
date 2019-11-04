# rubocop:disable Style/CaseEquality
# frozen_string_literal: true

module Enumerables
  def my_each
    i = 0
    while i < self.size do yield(self[i]); i += 1 end
  end

  def my_each_with_index
    i = 0
    while i < self.size do yield(self[i], i) ; i += 1 end
  end

  def my_select
    i = 0
    array = []
    while i < self.size
    array << self[i] if yield(self[i])
    i += 1
    end
    array
  end

  def my_any?
    final = false
    self.my_each { |param| final = true if yield(param)}
    final
  end

  def my_all?
    final = false
    self.my_each { |value| yield(value) ?  final = true : final = false}
    final
  end

  def my_none?
    final = true
    self.my_each { |param| final = false if yield(param)}
    final
  end

  def my_count(arg = nil)
    counter = 0
    if arg
      self.my_each { |param| if param == arg then counter += 1 end}
    elsif block_given?
      self.my_each { |param| counter += 1 if yield(param)}
    else
      counter = self.size
    end
    counter
  end

  def my_map(arg = nil)
    arr = []
    if arg
      self.my_each_with_index { |elem, val| arr[val] = arr.call(elem)}
    else
      self.my_each_with_index { |elem, val| arr[val] = yield(elem)}
    end
    arr
  end

  def my_inject(starter = nil)
    starter == nil ? result = self[0] : result = starter
    self.my_each { |v| result = yield(result, y)}
    result
  end

  ############
end
