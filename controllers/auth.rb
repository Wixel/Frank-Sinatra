class App < Sinatra::Base	
	# Display the auth login page
	get '/auth/login' do
		erb :login
	end

	# Handle the login post request
	post '/auth/login' do
		@user = User.first(:email => params[:email], :password => params[:password])
		if !@user
			flash[:error] = "Whoops! We could not find that account"
			redirect '/auth/login'
		else
			session[:user_id] = @user.id
			session[:authorized] = true
			redirect '/auth/dashboard'
		end
	end

	# Display the signup page
	get '/auth/signup' do
		redirect '/dashboard' if authorized?
		erb :signup
	end

	# Handle the signup request
	post '/auth/signup' do
		user = User.create(:email => params[:email], :password => params[:password], :created_at => Time.now)
		session[:user_id] = user.id
		session[:authorized] = true		
		
		# Notify the new user
		Pony.mail(:to => params[:email], :from => 'you@you.com', :subject => 'Welcome!', :body => 'Frank-Sinatra has spoken')
		
		redirect "/auth/dashboard"
	end	

	# Display the simple user dashboard
	get '/auth/dashboard' do
		@user = User.first(:id => session[:user_id])
		erb :dashboard
	end

	# Log the user out & clear the session
	get '/auth/logout' do
		session[:authorized] = false
		session.clear
		redirect '/'
	end

	# Prepare the DB for usage
	get '/auth/prepare_db' do
		User.auto_upgrade!
		redirect '/auth/login'
	end
end