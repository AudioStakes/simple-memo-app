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

get '/memos/new' do
  @memo ||= []

  haml :'memos/new'
end

post '/memos' do
  title = request['title']
  content = request['content']

  if title && content
    CSV.open(CSV_FILE_PATH, File::Constants::RDWR, encoding: 'bom|utf-8', headers: true, header_converters: :symbol) do |csv|
      max_id = csv.max_by { |row| row[:id].to_i }[:id].to_i

      csv << [max_id + 1, title, content]
    end

    redirect :'memos/index'
  else
    error 400
  end
end

get %r{/memos/(\d+)/edit} do
  target_id = params['captures'].first
  csv = CSV.read(CSV_FILE_PATH, encoding: 'bom|utf-8', headers: true, header_converters: :symbol)
  @memo = csv.find { |row| row[:id] == target_id }

  if @memo
    haml :'memos/edit'
  else
    error 404
  end
end

patch %r{/memos/(\d+)} do
  target_id = params['captures'].first
  title = request['title']
  content = request['content']

  if title && content
    csv = CSV.read(CSV_FILE_PATH, encoding: 'bom|utf-8', headers: true, header_converters: :symbol)

    if (target_row = csv.find { |row| row[:id] == target_id })
      csv.delete_if { |row| row[:id] == target_id }

      target_row[:title] = title
      target_row[:content] = content

      csv << target_row

      # sort した方が良いかも？

      File.open(CSV_FILE_PATH, 'w') do |f|
        f.write(csv.to_csv)
      end
    end

    redirect :'memos/index'
  else
    error 400 # より適したステータスコードがあるかも？
  end
end

delete %r{/memos/(\d+)} do
  csv = CSV.read(CSV_FILE_PATH, encoding: 'bom|utf-8', headers: true, header_converters: :symbol)

  if (target_index = csv.find_index { |row| row[:id] == params['captures'].first })
    csv.delete(target_index)

    File.open(CSV_FILE_PATH, 'w') do |f|
      f.write(csv.to_csv)
    end

    redirect :'memos/index'
  else
    error 400 # より適したステータスコードがあるかも？
  end
end
