#### Endpoints

* `POST /api/users/` - create a new user. Requires an `email` parameter. Returns the created User object.
* `GET /api/photos/` - retrieves all photos. Returns an Array of all Photo objects retrieved.
* `POST /api/photos` - upload a photo to the system. Photo is uploaded as the `photo` parameter. Requires the user token with `token` and `latitude` and `longitude` parameters as well. Returns the created Photo object.
```
{
	"photo": file
	"token": "YreIoA-nX26yqbOrAz45CA",
	"latitude": "39.9500",
	"longitude": "75.1900"
}
```
* `POST /api/photos/:id/heart` - hearts the specified photo. Requires the user token with `token`. Returns the photo ID and the current user's like status for that photo.
```
{
	"token": "YreIoA-nX26yqbOrAz45CA"
}
```
