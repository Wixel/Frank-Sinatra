# Hello, Frank - Sinatra

A simplistic, modular-MVC style [Sinatra](http://www.sinatrarb.com/) boilerplate for rapid application prototyping. A blazingly fast way to get your app up and running in no time (most batteries included). Deployment to [Heroku](http://heroku.com) is painless too, that helps.

The is a starting point and is by no means a complete application. You should be able to use this to kick the fire for your own applications relatively fast. We use this over at [Wixel](http://wixelhq.com) for fast prototyping. 

I assume you have Git installed and understand how to use it via the command line. HTML5 Boilerplate has been included by default to help you speed up your front-end creation.

## Installation ##

### Requirements ###

  * [Ruby](http://www.ruby-lang.org/) 1.9.2 and up
  * [Rubygems](http://rubygems.org/)
  * [Git](http://git-scm.com/)
  * [Bundler](http://rubygems.org/gems/bundler)

### Clone from Github ###

    $ git clone https://github.com/Wixel/Frank-Sinatra.git <your app name>
    $ cd <your app name>
    
### Install Required Gems ###

To check your dependencies and install, type:

	$ bundle check
    $ bundle install

This will install all the dependencies and create the Gemfile.lock file. This process could take some time to complete. 

### Running Locally ###

When running locally, a sqlite3 database file will be created in the /db directory. 

To start up your application using shotgun, type:

	$ shotgun

The shotgun command will dynamically load and reload your application code when you change things. You can now access your app at: [http://localhost:9393](http://localhost:9393)

To start up your application using rackup, type:

	$ rackup
	
The rackup command will load your app once and not reload each time you change code. You can access your app at: [http://localhost:9292](http://localhost:9292)

You can also start your app using [Foreman](https://github.com/ddollar/foreman) as follows:

	$ foreman start
	
You can now access your app at [http://localhost:5000](http://localhost:5000)

#### Installed Components ####
	
  * [Rack](http://rack.github.io/)
  * [Sinatra 1.4.3](http://www.sinatrarb.com/)
  * [Builder](https://github.com/jimweirich/builder)
  * [Sqlite3](https://github.com/luislavena/sqlite3-ruby)
  * [BSON](http://bsonspec.org/)
  * [Sinatra-flash](https://github.com/SFEley/sinatra-flash)
  * [Logger](https://github.com/nahi/logger)
  * [Pony](https://github.com/benprew/pony)
  * [Omniauth](https://github.com/intridea/omniauth)
  * [Mime-types](http://mime-types.rubyforge.org/)
  * [Fog](http://fog.io/)
  * [Will Paginate](https://github.com/mislav/will_paginate)
  * [Data Mapper](http://datamapper.org/)
  * [Awesome Print](https://github.com/michaeldv/awesome_print)
  * [Shotgun](https://github.com/rtomayko/shotgun) 
  * [Foreman](https://github.com/ddollar/foreman)
  * [Cucumber](http://cukes.info/)
  * [Resque](https://github.com/resque/resque)

Feel free to add and remove from your Gemfile as needed.

## Usage & Modifying ##

### General Setup ###

Before running your application successfully, you will need to do the following:

1) Create a session cookie secret (app.rb - line 13):
  
	$ use Rack::Session::Cookie, :secret => "random string here" 
	
2) Define your database and runtime settings:

	File: config/database.yaml
	File: config/development.yaml
	File: config/production.yaml
	
Your database defaults to sqlite3 until you manually change the Adapter setting in `database.yaml`

### Databases/Models ###

You can use any database abstraction layer, but we prefer [DataMapper](http://datamapper.org/) and we'll use it by default in Frank-Sinatra. 

If you've come this far, DataMapper should already be installed along side your project (`bundle install`). 

You define models in the `models` directory. We've created one called `user.rb` for demonstration purposes. 

Read more about DataMapper in their [excellent documentation](http://datamapper.org/docs/).

Here's an example of a very simple User model (yes, it's that simple):

	class User
    	include DataMapper::Resource
	    property :id, Serial
	    property :name, String
	    property :email, Text
	    property :password, Text    
	    property :created_at, DateTime
	end

##### Trouble installing dm-mysql-adapter? #####

You probably need to install MySQL. You can try one of the following options:

With MacPorts:

	$ sudo port install mysql5
	
With RPM:

	$ sudo yum install mysql-devel
	
With Homebrew:

	$ brew install mysql
	
##### Working with PostgreSQL #####

If you have chosen PostgreSQL as your database backend and you use OS-X, I highly recommend that you take a look at [PostgresApp](postgresapp.com).

Uncomment the `gem dm-postgres-adapter` line in your Gemfile and set your database access credentials in `config/database.yaml`.

You also need to change the adapter setting to `adapter:postgres` in the above mentioned database config.

### Controllers ###

Your controllers are simply extending your base App class. Controllers do not reserve specific urls segments. 

Best practice is to prepend your mount-point with the logical controller->url namespace as follows:
	
auth.rb mounts to '/auth/ using:

	class App < Sinatra::Base	
		get '/auth/login' do
			erb :login
		end
		post '/auth/login' do
			# Perform login action
		end
	end

Going to http://host/auth/login renders controllers -> auth.rb

### Helpers ###

Helpers are simple [Sinatra Helpers](http://www.sinatrarb.com/intro.html#Helpers) defined in external files for separation.

### Views ###

Views are simple Sinatra views. You can use any rendering engine as per usual.

## Deploying to Heroku ##

[Sign up](https://api.heroku.com/signup/devcenter) for your Heroku account (if you don't have one already).

Then go ahead and install the [Heroku Toolbelt](https://toolbelt.heroku.com/), a CLI tool used to manage your applications.

#### Login to Heroku CLI ####

Log in to your Heroku account via the CLI toolbelt:

	$ heroku login
	Enter your Heroku credentials.
	Email: you@you.com
	Password:
	Could not find an existing public key.
	Would you like to generate one? [Yn] 
	Generating new SSH public key
	Uploading ssh public key /Users/adam/.ssh/id_rsa.pub
	
#### Create your Heroku app ####

	$ heroku create
	Creating blazing-galaxy-997... done, stack is cedar
	http://blazing-galaxy-997.herokuapp.com/ | git@heroku.com:blazing-galaxy-997.git
	Git remote heroku added
	
### Deploy your code to Heroku ###

	$ git push heroku master
	
	Counting objects: 6, done.
	Delta compression using up to 4 threads.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (6/6), 660 bytes, done.
	Total 6 (delta 0), reused 0 (delta 0)
	
	-----> Heroku receiving push
	-----> Ruby app detected
	-----> Installing dependencies using Bundler version 1.1
	       Checking for unresolved dependencies.
	       Unresolved dependencies detected.
	       Running: bundle install --without development:test --path vendor/bundle --deployment
	       Fetching source index for https://rubygems.org/
	       Installing rack (1.2.2)
	       Installing tilt (1.3)
	       Installing sinatra (1.1.0)
	       Using bundler (1.1)
	       Your bundle is complete! It was installed into ./vendor/bundle
	-----> Discovering process types
	       Procfile declares types -> web
	       Default types for Ruby  -> console, rake
	-----> Compiled slug size is 6.3MB
	-----> Launching... done, v4
	       http://blazing-galaxy-997.herokuapp.com deployed to Heroku
	
	To git@heroku.com:blazing-galaxy-997.git
	 * [new branch]      master -> master

#### Visit your app online ####

	$ heroku open

#### Keep an eye on the logs ####

	$ heroku logs

You can find more info on the official [Heroku Dev Center](https://devcenter.heroku.com/articles/ruby) page.

# TODO #

* Integrating test coverage or a template to build test from
* Wire up some of the other Gems to show how they can be used
