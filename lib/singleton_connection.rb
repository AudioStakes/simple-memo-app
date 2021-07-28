# frozen_string_literal: true

require 'pg'
require 'singleton'

class SingletonConnection
  include Singleton

  DB_NAME = 'simple_memo_app_development'

  attr_reader :conn

  def initialize
    @conn = PG.connect(dbname: DB_NAME)
    @conn.field_name_type = :symbol
  end
end
