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
      max_id = 0

      CSV.open(CSV_PATH, 'a+') do |csv|
        csv.flock(File::LOCK_EX)

        memo_arrays = csv.read
        max_id      = memo_arrays.transpose[0].map(&:to_i).max

        csv << [max_id + 1, title, content]
      end

      new(id: max_id + 1, title: title, content: content)
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

    CSV.open(CSV_PATH, 'r') do |csv|
      csv.flock(File::LOCK_EX)

      memo_arrays  = csv.read
      target_index = memo_arrays.index { |row| row[0] == @id.to_s }

      memo_arrays[target_index] = [@id, title, content]

      File.write(CSV_PATH, memo_arrays.map(&:to_csv).join)
    end
  end

  def destroy
    CSV.open(CSV_PATH, 'r') do |csv|
      csv.flock(File::LOCK_EX)

      memo_arrays = csv.read
      memo_arrays = memo_arrays.delete_if { |row| row[0] == @id.to_s }

      File.write(CSV_PATH, memo_arrays.map(&:to_csv).join)
    end
  end
end
