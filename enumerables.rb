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
  ############
end
