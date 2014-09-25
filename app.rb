require 'sinatra/base'
require './config/environments' #database configuration

class App < Sinatra::Base

	register Sinatra::AssetPack

	configure do

		configure(:development) { set :session_secret, "something" }

		enable :sessions

		use OmniAuth::Builder do
			provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
		end
	end
		
	helpers do
	  	# define a current_user method, so we can be sure if an user is authenticated
	  	def current_user
	    	!session[:uid].nil?
	  	end
	end

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

	get '/login' do
		redirect to("/auth/twitter")
	end

	get '/logout' do
		session[:uid] = nil
		redirect to('/')
	end

	get '/auth/twitter/callback' do
	  	# probably you will need to create a user in the database too...
	  	session[:uid] = env['omniauth.auth']['uid']
	  	# this is the main endpoint to your application
	  	redirect to('/')
	end

	get '/auth/failure' do
	  	# omniauth redirects to /auth/failure when it encounters a problem
	  	# so you can implement this as you please
	  	@message = params
		slim :fail
	end

	get '/' do
		if current_user
			slim :dashboard
		else
			slim :index
		end
	end

end