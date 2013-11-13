get '/' do


  @user = session[:user_data][:username] if session[:user_data]
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


user_data = {username: @access_token.params[:screen_name],
             oauth_token: @access_token.params[:oauth_token],
             oauth_secret: @access_token.params[:oauth_token_secret]}

@user = User.find_by_username(@access_token.params[:screen_name])

if @user.nil?
  User.create user_data
end

session[:user_data] = user_data

# session[:oauth_token] = @access_token.params[:oauth_token]
# session[:oauth_secret] = @access_token.params[:oauth_token_secret]

  redirect '/member'
end

get '/member' do
  erb :member
end

post '/member' do

  Twitter.configure do |config|
    config.consumer_key = '9TDviFo0TFWqPwcBQ3O0tA'
    config.consumer_secret = 'H3Jikhp8lrHgVw7Y78njB0ZFLordTjijdXSJknZoZg'
    config.oauth_token = session[:user_data][:oauth_token]
    config.oauth_token_secret = session[:user_data][:oauth_secret]
  end

  Twitter.update(params[:status])

  redirect '/'
end
