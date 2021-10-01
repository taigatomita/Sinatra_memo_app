# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

before do
  json_str = File.open('memo_data.json', &:read)
  return if json_str.empty?

  @memo_data = JSON.parse(json_str, symbolize_names: true)
end

get '/' do
  @title = 'メモ一覧'
  erb :index
end

get '/new' do
  @title = 'メモ作成'
  erb :new
end

get '/:id' do |n|
  @memo_title = @memo_data[n.to_i - 1][:title]
  @content = @memo_data[n.to_i - 1][:message]
  @id = n
  @title = 'メモ詳細'
  erb :show
end

get '/:id/edit' do |n|
  @memo_title = @memo_data[n.to_i - 1][:title]
  @content = @memo_data[n.to_i - 1][:message]
  @id = n
  @title = '編集'
  erb :edit
end

patch '/:id' do |n|
  @memo_data[n.to_i - 1][:title] = params[:title]
  @memo_data[n.to_i - 1][:message] = params[:message]
  File.open('memo_data.json', 'w+') { |file| JSON.dump(@memo_data, file) }
  redirect "/#{n}"
end

post '/' do
  @memo_data ||= []
  @memo_data << params
  @memo_data.each_with_index do |hash, idx|
    hash[:id] = (idx + 1).to_s unless hash.key?(:id)
  end
  File.open('memo_data.json', 'w+') { |file| JSON.dump(@memo_data, file) }
  redirect '/'
end

delete '/:id' do
  @memo_data.delete_at(params[:id].to_i - 1)
  @memo_data.each_with_index do |hash, idx|
    hash[:id] = (idx + 1).to_s
  end
  File.open('memo_data.json', 'w+') { |file| JSON.dump(@memo_data, file) }
  redirect '/'
end
