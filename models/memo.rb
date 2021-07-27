# frozen_string_literal: true

require 'pg'

class Memo
  @conn = PG.connect(dbname: 'simple_memo_app_development').tap { |conn| conn.field_name_type = :symbol }

  attr_reader :id, :title, :content

  class << self
    def all
      result = @conn.exec('SELECT id, title, content FROM memos ORDER BY id')

      result.map { |memo_hash| new(**memo_hash) }
    end

    def find(id)
      result    = @conn.exec_params('SELECT id, title, content FROM memos WHERE id = $1', [id])
      memo_hash = result.first

      new(**memo_hash) if memo_hash
    end

    def create(title:, content:)
      result      = @conn.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2) RETURNING id', [title, content])
      assigned_id = result.first[:id]

      new(id: assigned_id, title: title, content: content)
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

    conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, @id])
  end

  def destroy
    conn.exec_params('DELETE FROM memos WHERE id = $1', [@id])
  end

  private

  def conn
    self.class.instance_variable_get(:@conn)
  end
end
