require 'sinatra'
require 'geetar'

get '/' do
  haml :index
end

get '/results' do
  client = Geetar::Client.new
  options = { search_type: 'title', value: params[:query], page: params[:page] }
  results = client.search(options)
  haml :results, locals: {search_results: results, next_page: results.next_page }
end

get '/show' do
  tab = Geetar::Client.new.get_tab_content(params[:url])
  haml :show, locals: {tab: tab}, layout: false
end
