class User 
	include MongoMapper::Document

	# Users are identified by an email
	key :email, String

	# Token is used for requests by the user to the server
	key :token, String

	# Every user has many photos
	many :photos

end