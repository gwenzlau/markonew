class ApplicationController < ActionController::Base
 # commenting this out skips the csrf token authentication - the app is insecure - setup api keys later
  protect_from_forgery
end
