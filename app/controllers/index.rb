get '/' do
  # @home_tweets = Twitter.home_timeline
  # p @home_tweets

  if session[:user]
    @timeline = session[:user].home_timeline
    @timeline.each do |tweet|
      p tweet[:text]
    end

    # @user_timeline = Twitter.home_timeline
    # p @user_timeline
    # p username
    # @user_tweets = Twitter.user_timeline(username)
    # p @user_tweets
  end

  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

post '/statuses/update' do
  @tweet = params[:tweet]
  Twitter.update(@tweet)

  redirect '/'
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
  # p @access_token
  params = @access_token.params
  p params


  Twitter.configure do |config|
    config.oauth_token = params[:oauth_token]
    config.oauth_token_secret = params[:oauth_token_secret]
  end

  session[:user] = Twitter::Client.new(
    :oauth_token => params[:oauth_token],
    :oauth_token_secret => params[:oauth_token_secret]
  )

    # @user_timeline = Twitter.home_timeline
    # p @user_timeline

  # at this point in the code is where you'll need to create your user account and store the access token
  # p User.create(username: params[:screen_name], oauth_token: params[:oauth_token], oauth_secret: params[:oauth_token_secret])
  # erb :index
  redirect '/'
end
