# frozen_string_literal: true

require 'csv'
require 'sinatra'
require 'sinatra/reloader' if development?

CSV_FILE_PATH = './memos.csv'

get %r{(/|/memos/index)} do
  @memos = CSV.read(CSV_FILE_PATH)[1..].sort

  haml :'memos/index'
end

get %r{/memos/(\d+)} do
  csv = CSV.read(CSV_FILE_PATH, encoding: 'bom|utf-8', headers: true, header_converters: :symbol)
  @memo = csv.find { |row| row[:id] == params['captures'].first }

  if @memo
    haml :'memos/show'
  else
    error 404
  end
end
