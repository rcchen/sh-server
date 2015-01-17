require 'json'
require 'mongo'
require 'mongo_mapper'
require 'sinatra'

require './models/user'
require './models/photo'

MongoMapper.connection = Mongo::Connection.new('localhost')
MongoMapper.database = 'selfiehero'

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
	filename = "public/#{SecureRandom.uuid}.jpeg"
	File.open(filename, "w") do |f|
		f.write(params[:photo][:tempfile].read)
	end
	photo = Photo.create({ :url => filename, :latitude => latitude, :longitude => longitude })
	user = User.first( :token => params[:token] )
	user.photos << photo
	photo.to_json
end

# Heart/unheart a photo
post '/api/photos/:id/like' do
	photo = Photo.first(:id => params[:id])
	user = User.first(:token => params[:token])
	if photo[:hearts].include? user[:_id]
		photo[:hearts].delete(user[:_id])
	else
		photo[:hearts] << user[:_id]
	end
	photo.save!
end
