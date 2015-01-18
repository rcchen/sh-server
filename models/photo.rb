class Photo 
	include MongoMapper::Document

	# Every photo is associated with a URL
	key :url, String

	# Every photo stores a location
	key :latitude, Double
	key :longitude, Double

	# Photos have hearts
	key :hearts, Array

	# All photos belong to users
	belongs_to :user

	# Keep timestamps
	timestamps!

end