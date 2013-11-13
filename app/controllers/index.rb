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

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session

  session.delete(:request_token)

  @user = User.create(:username => @access_token.params[:screen_name], :oauth_token => @access_token.token, :oauth_secret => @access_token.secret)
  session[:user_id] = @user.id
  redirect '/tweet_time'
end

get '/tweet_time' do
  erb :tweet_time_yo
end

post '/tweet_time' do
  text_to_tweet = params[:tweet]
  @curr_user = User.find_by_id(session[:user_id])
  p @curr_user
  twitter_client = Twitter::Client.new(
    :oauth_token => @curr_user.oauth_token,
    :oauth_token_secret => @curr_user.oauth_secret
    ) 
  twitter_client.update(text_to_tweet)
  erb :tweet_time_yo
end
