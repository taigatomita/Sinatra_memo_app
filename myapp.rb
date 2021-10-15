# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'

configure do
  set :connection, PG::Connection.open(dbname: 'memo_app')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def fetch_memo_status(id)
    memo_stat = settings.connection.exec_params('SELECT title,content FROM memos WHERE id = $1', [id])
    @memo_title = memo_stat.to_a[0]['title']
    @content = memo_stat.to_a[0]['content']
  end
end

get '/' do
  @memos_data = settings.connection.exec('SELECT * FROM memos')
  @title = 'メモ一覧'
  erb :index
end

get '/new' do
  @title = 'メモ作成'
  erb :new
end

get '/:id' do |n|
  fetch_memo_status(n)
  @id = n
  @title = 'メモ詳細'
  erb :show
end

get '/:id/edit' do |n|
  fetch_memo_status(n)
  @id = n
  @title = '編集'
  erb :edit
end

patch '/:id' do |n|
  settings.connection.exec('UPDATE memos SET (title, content) = ($1, $2) WHERE id = $3', [params[:title], params[:content], n])
  redirect '/'
end

post '/' do
  settings.connection.exec('INSERT INTO memos (title, content) VALUES ($1, $2)', [params[:title], params[:content]])
  redirect '/'
end

delete '/:id' do |n|
  settings.connection.exec('DELETE FROM memos WHERE id = $1', [n])
  redirect '/'
end
