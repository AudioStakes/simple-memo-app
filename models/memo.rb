# frozen_string_literal: true

require 'csv'

class Memo
  CSV_PATH = File.expand_path('../memos.csv', __dir__)

  attr_reader :id, :title, :content

  class << self
    def all
      CSV.read(CSV_PATH)[1..].map { |id, title, content| new(id: id, title: title, content: content) }
    end

    def find(id)
      memo_array = CSV.read(CSV_PATH).find { |row| row[0] == id.to_s }

      new(id: memo_array[0], title: memo_array[1], content: memo_array[2]) if memo_array
    end

    def create(title:, content:)
      memo_arrays = CSV.read(CSV_PATH)
      max_id      = memo_arrays.transpose[0].map(&:to_i).max

      memo = new(id: max_id + 1, title: title, content: content)

      memo_arrays << [memo.id, memo.title, memo.content]
      Memo.save(memo_arrays)

      memo
    end

    def save(memo_arrays)
      memo_arrays = memo_arrays.sort_by { |row| row[0].to_i }

      File.write(CSV_PATH, memo_arrays.map(&:to_csv).join)
    end
  end

  def initialize(id: nil, title: nil, content: nil)
    @id      = id
    @title   = title
    @content = content
  end

  def update(title:, content:)
    @title   = title
    @content = content

    memo_arrays  = CSV.read(CSV_PATH)
    target_index = memo_arrays.index { |row| row[0] == @id.to_s }

    memo_arrays[target_index] = [@id, @title, @content]

    Memo.save(memo_arrays)
  end

  def destroy
    memo_arrays = CSV.read(CSV_PATH)
    memo_arrays = memo_arrays.delete_if { |row| row[0] == @id.to_s }

    Memo.save(memo_arrays)
  end
end
