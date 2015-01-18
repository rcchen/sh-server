require './models/user'
require './models/photo'

require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

class Server < Sinatra::Base

	MongoMapper.connection = Mongo::Connection.new('localhost')
	MongoMapper.database = 'selfiehero'

	# Basic route
	get '/' do
		erb :index
	end

	# Create a new user
	post '/api/users' do
		content_type :json
		user = User.create({
			:email => params[:email],
			:token => SecureRandom.urlsafe_base64(16)
		})
		user.to_json
	end

	# Show photos
	get '/api/photos' do
		content_type :json
		Photo.all.to_json
	end

	# Add photo
	post '/api/photos' do
		filename = "photos/#{SecureRandom.uuid}.jpeg"
		File.open("public/#{filename}", "w") do |f|
			f.write(params[:photo][:tempfile].read)
		end
		photo = Photo.create({ :url => filename, :latitude => params[:latitude], :longitude => params[:longitude] })
		user = User.first( :token => params[:token] )
		user.photos << photo
		photo.to_json
	end

	# Heart/unheart a photo
	post '/api/photos/:id/heart' do
		photo = Photo.first(:id => params[:id])
		user = User.first(:token => params[:token])
		status = true
		if photo[:hearts].include? user[:_id]
			photo[:hearts].delete(user[:_id])
			status = false
		else
			photo[:hearts] << user[:_id]
		end
		photo.save!
		content_type :json
		{ :photo_id => params[:id], :heart_status => status }.to_json
	end

	set :allow_origin, :any
end