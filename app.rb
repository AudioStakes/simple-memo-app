# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require_relative './models/memo'

configure do
  set :haml, escape_html: true
end

helpers do
  def find_memo(id)
    @memo = Memo.find(id)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = Memo.all

  haml :'memos/index'
end

get %r{/memos/(\d+)} do |id|
  if find_memo(id)
    haml :'memos/show'
  else
    not_found
  end
end

get '/memos/new' do
  haml :'memos/new'
end

get %r{/memos/(\d+)/edit} do |id|
  if find_memo(id)
    haml :'memos/edit'
  else
    not_found
  end
end

post '/memos' do
  @memo = Memo.create(title: params[:title], content: params[:content])

  redirect to("/memos/#{@memo.id}")
end

patch %r{/memos/(\d+)} do |id|
  if find_memo(id)
    @memo.update(title: params[:title], content: params[:content])

    redirect to("/memos/#{id}")
  else
    not_found
  end
end

delete %r{/memos/(\d+)} do |id|
  if find_memo(id)
    @memo.destroy

    redirect to('/memos')
  else
    not_found
  end
end

not_found do
  'This is nowhere to be found.'
end
