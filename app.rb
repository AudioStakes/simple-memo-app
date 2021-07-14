# frozen_string_literal: true

require 'csv'
require 'sinatra'
require 'sinatra/reloader' if development?

CSV_FILE_PATH = './memos.csv'

get %r{(/|/memos/index)} do
  @memos = CSV.read(CSV_FILE_PATH)[1..].sort

  haml :'memos/index'
end
