# frozen_string_literal: true

require_relative '../lib/singleton_connection'

class Memo
  attr_reader :id, :title, :content

  class << self
    def all
      result = exec_query('SELECT id, title, content FROM memos ORDER BY id')

      result.map { |memo_hash| new(**memo_hash) }
    end

    def find(id)
      result    = exec_query('SELECT id, title, content FROM memos WHERE id = $1', [id])
      memo_hash = result.first

      new(**memo_hash) if memo_hash
    end

    def create(title:, content:)
      result      = exec_query('INSERT INTO memos (title, content) VALUES ($1, $2) RETURNING id', [title, content])
      assigned_id = result.first[:id]

      new(id: assigned_id, title: title, content: content)
    end

    def exec_query(sql, params = [])
      conn = SingletonConnection.instance.conn

      conn.exec_params(sql, params)
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

    self.class.exec_query('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, @id])
  end

  def destroy
    self.class.exec_query('DELETE FROM memos WHERE id = $1', [@id])
  end
end
