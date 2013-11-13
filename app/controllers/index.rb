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
  @access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token
  @user = User.create(username: @access_token.params[:screen_name],
                      oauth_token: @access_token.token,
                      oauth_secret: @access_token.secret)

  erb :index

end

get '/tweet/:username/:message' do
  user = User.where("username = '#{params[:username]}'").first
  p user.username
  p user.oauth_token
  p user.oauth_secret

  p params[:message]

  twitter_client = Twitter::Client.new(
    consumer_key:       ENV['TWITTER_KEY'],
    consumer_secret:    ENV['TWITTER_SECRET'],
    oauth_token:        user.oauth_token,
    oauth_token_secret: user.oauth_secret
  )

  p twitter_client.update(params[:message])
  # p twitter_client.methods.sort - Object.methods #.update(params[:message])

  "success!  (i think)"
end
