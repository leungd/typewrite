class App < Sinatra::Base
  register Sinatra::AssetPack
  assets do
	serve '/js', from: 'js'
	serve '/bower_components', from: 'bower_components'

	js :libs, [
	'/bower_components/jquery/dist/jquery.js',
	'/bower_components/bootstrap-sass-official/assets/javascripts/bootstrap-sprockets.js',
	'/bower_components/bootstrap-sass-official/assets/javascripts/bootstrap.js'
	]

	js :application, [
	'/js/app.js'
	]

	js_compression :jsmin
  end
  
  get '/' do
  	slim :default
  end

end