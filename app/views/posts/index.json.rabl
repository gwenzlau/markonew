collection @posts

attributes :body, :lat, :lng

child :user do
extends "users/show"
end