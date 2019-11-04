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
  ############
end
