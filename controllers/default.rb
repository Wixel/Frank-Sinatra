class App < Sinatra::Base
	# Show the index.erb page
	get '/' do
		erb :index
	end
end