# frozen_string_literal: true

require 'json'

class Memo
  JSON_PATH = File.expand_path('../memos.json', __dir__)

  attr_reader :id, :title, :content

  class << self
    def all
      JSON.load_file(JSON_PATH, symbolize_names: true)
          .sort_by { |h| h[:id] }
          .map { |memo_hash| new(**memo_hash) }
    end

    def find(id)
      memo_hash = JSON.load_file(JSON_PATH, symbolize_names: true).find { |hash| hash[:id] == id.to_i }

      new(**memo_hash) if memo_hash
    end

    def create(title:, content:)
      memo_hash = { title: title, content: content }

      File.open(JSON_PATH, 'r') do |file|
        file.flock(File::LOCK_EX)

        memo_hashes    = JSON.load_file(JSON_PATH, symbolize_names: true)
        max_id         = memo_hashes.max_by { |hash| hash[:id] }[:id]
        memo_hash[:id] = max_id + 1

        memo_hashes << memo_hash

        File.write(JSON_PATH, JSON.dump(memo_hashes))
      end

      new(**memo_hash)
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

    File.open(JSON_PATH, 'r') do |file|
      file.flock(File::LOCK_EX)

      memo_hashes = JSON.load_file(JSON_PATH, symbolize_names: true)
      target_hash = memo_hashes.find { |hash| hash[:id] == @id }

      target_hash[:title] = title
      target_hash[:content] = content

      File.write(JSON_PATH, JSON.dump(memo_hashes))
    end
  end

  def destroy
    File.open(JSON_PATH, 'r') do |file|
      file.flock(File::LOCK_EX)

      memo_hashes = JSON.load_file(JSON_PATH, symbolize_names: true)
      memo_hashes = memo_hashes.delete_if { |hash| hash[:id] == @id }

      File.write(JSON_PATH, JSON.dump(memo_hashes))
    end
  end
end
