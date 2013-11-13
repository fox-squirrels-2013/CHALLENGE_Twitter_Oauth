get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end


#TODO create a way to let the current user tweet from this app
post '/something'
  if @current_user
end

#TODO create helper method to find @current_user and refactor
#TODO enable sessions to avoid creating so many fucking users

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    # our request token is only valid until we use it to get an access token, so let's delete it from our session
  brent = User.create(:username => @access_token.params[:screen_name], :oauth_token => @access_token.params[:oauth_token], :oauth_secret => @access_token.params[:oauth_token_secret])
Twitter.configure do |config|
  config.oauth_token = brent.oauth_token
  config.oauth_token_secret = brent.oauth_secret
end
  Twitter.update("Fuckin' programming man. More tweets from the command line.")
  session.delete(:request_token)
  erb :index
end


