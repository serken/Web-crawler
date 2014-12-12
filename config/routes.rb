WebCrawler::Application.routes.draw do

  root 'crawler#index'
  post '/' => 'crawler#fetch'
  get '(:file_name)' => 'crawler#download', :file_name => /.*/

end
