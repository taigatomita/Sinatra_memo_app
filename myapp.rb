# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

before do
  @connection = PG::Connection.open(dbname: 'memo_app')
  @connection.internal_encoding = 'UTF-8'
end

after do
  @connection.finish
end

get '/' do
  @memo_data = @connection.exec('SELECT * FROM memos')
  @title = 'メモ一覧'
  erb :index
end

get '/new' do
  @title = 'メモ作成'
  erb :new
end

get '/:id' do |n|
  @memo_title = @connection.exec_params('SELECT title FROM memos WHERE id = $1', [n]).to_a[0]['title']
  @content = @connection.exec_params('SELECT content FROM memos WHERE id = $1', [n]).to_a[0]['content']
  @id = n
  @title = 'メモ詳細'
  erb :show
end

get '/:id/edit' do |n|
  @memo_title = @connection.exec_params('SELECT title FROM memos WHERE id = $1', [n]).to_a[0]['title']
  @content = @connection.exec_params('SELECT content FROM memos WHERE id = $1', [n]).to_a[0]['content']
  @id = n
  @title = '編集'
  erb :edit
end

patch '/:id' do |n|
  @connection.exec('UPDATE memos SET (title, content) = ($1, $2) WHERE id = $3', [params[:title], params[:content], n])
  redirect '/'
end

post '/' do
  @connection.exec('INSERT INTO memos (title, content) VALUES ($1, $2)', [params[:title], params[:content]])
  redirect '/'
end

delete '/:id' do |n|
  @connection.exec('DELETE FROM memos WHERE id = $1', [n])
  redirect '/'
end
