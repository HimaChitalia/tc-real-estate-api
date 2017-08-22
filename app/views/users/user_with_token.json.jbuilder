json.user do
  json.(@user, :id, :email, :username)
end
json.token(Auth.create_token(@user.id))