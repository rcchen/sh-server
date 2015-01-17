#### Endpoints

* `POST /api/users/` - create a new user. Requires an `email` parameter. Returns the created User object.
* `GET /api/photos/` - retrieves all photos. Returns an Array of all Photo objects retrieved.
* `POST /api/photos` - upload a photo to the system. Photo is uploaded as the `photo` parameter. Requires the user token with `token` and `latitude` and `longitude` parameters as well. Returns the created Photo object.
* `POST /api/photos/:id/like` - likes the specified photo. 
