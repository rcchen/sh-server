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

	# Get a user by email
	get '/api/users' do
		content_type :json
		user = User.first( :email => params[:email] )
		user.to_json
	end

	# Create a new user
	post '/api/users' do
		content_type :json
		user = User.first( :email => params[:email] )
		if user != nil
			user = User.create({
				:email => params[:email],
				:token => SecureRandom.urlsafe_base64(16)
			})
		end
		user.to_json
	end

	# Show photos. Will eventually be location-replaced
	get '/api/photos' do
		content_type :json
		radius = params[:radius] ? params[:radius].to_f * 0.015 : 5 * 0.015 # in miles
		latitude = params[:latitude] ? params[:latitude].to_f : 0
		longitude = params[:longitude] ? params[:longitude].to_f : 0
		photos = nil
		if params[:sort] == "hearts"
			photos = Photo.where(:latitude => { :$gte => latitude - radius, :$lte => latitude + radius }, :longitude => { :$gte => longitude - radius, :$lte => longitude + radius }).sort(:hearts_count.desc).limit(10)
		else
			photos = Photo.where(:latitude => { :$gte => latitude - radius, :$lte => latitude + radius }, :longitude => { :$gte => longitude - radius, :$lte => longitude + radius }).sort(:created_at.desc).limit(10)
		end
		photos.to_json
	end

	# Add photo
	post '/api/photos' do
		filename = "photos/#{SecureRandom.uuid}.jpeg"
		File.open("public/#{filename}", "w") do |f|
			f.write(params[:photo][:tempfile].read)
		end
		latitude = params[:latitude] ? params[:latitude].to_f : nil
		longitude = params[:longitude] ? params[:longitude].to_f : nil
		photo = Photo.create({ :url => filename, :latitude => params[:latitude], :longitude => params[:longitude], :hearts_count => 0 })
		user = User.first( :token => params[:token] )
		user.photos << photo
		photo.to_json
	end

	# Retrieve data for a specific photo
	get '/api/photos/:id' do
		content_type :json
		photo = Photo.first(:id => params[:id])
		photo.to_json
	end

	# Heart/unheart a photo
	post '/api/photos/:id/heart' do
		photo = Photo.first(:id => params[:id])
		user = User.first(:token => params[:token])
		status = true
		if photo[:hearts].include? user[:_id]
			photo[:hearts].delete(user[:_id])
			photo[:hearts_count] -= 1
			status = false
		else
			photo[:hearts] << user[:_id]
			photo[:hearts_count] += 1
		end
		photo.save!
		content_type :json
		{ :photo_id => params[:id], :heart_status => status, :heart_count => photo[:hearts_count] }.to_json
	end

	set :allow_origin, :any
end