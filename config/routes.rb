WebCrawler::Application.routes.draw do

  root 'crawler#index'
  post '/' => 'crawler#fetch'

end
