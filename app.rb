# encoding: utf-8
require 'sinatra/base'
require 'yaml'
require 'digest/md5'
require 'will_paginate/data_mapper'

class App < Sinatra::Base
  
  # Register Sinatra Flash
  register Sinatra::Flash
  
  # Include Session Cookie Module
  use Rack::Session::Cookie, :secret => "<secret>"
  
  # Development Specific configs
  configure :development do
    DataMapper::Logger.new($stdout, :debug)
  end

  # Production specific configs
  configure :production do
    YAML.load_file(File.dirname(__FILE__)+'/config/production.yaml').each do |k, v|
      set k, v
    end    
  end

  # General ENV configuration
  configure do

    dbconf = YAML.load_file(File.dirname(__FILE__)+'/config/database.yaml')

    case dbconf["adapter"]
      when "mysql"
        dbconf = dbconf[ENV['RACK_ENV']]
        DataMapper.setup(:default, "mysql://#{dbconf["username"]}:#{dbconf["password"]}@#{dbconf["host"]}/#{dbconf["database"]}")
      when "postgres"
        dbconf = dbconf[ENV['RACK_ENV']]
        DataMapper.setup(:postgres, "postgres://#{dbconf["username"]}:#{dbconf["password"]}@#{dbconf["host"]}/#{dbconf["database"]}")
      when "sqlite3"
        DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/application.db")
    end    

    # Enable sessions for all ENV's
    enable :sessions    
    
    # Set up our general configs
    set :root          , File.dirname(__FILE__)
    set :public_folder , File.dirname(__FILE__) + '/public'
    set :app_file      , __FILE__
    set :views         , File.dirname(__FILE__) + '/views'
    set :tests         , File.dirname(__FILE__) + '/tests'
    set :haml          , :format => :html5 
    set :dump_errors   , true
    set :logging       , true
    set :raise_errors  , true

    # Load general configs from the file
    YAML.load_file(File.dirname(__FILE__)+'/config/development.yaml').each do |k, v|
      set k, v
    end    
  end
  
  helpers do
    # Set an error in the flash and redirect
    def set_error(message, path)
      flash[:error] = message
      redirect path
    end

    # Set a notice in the flash and redirect
    def set_notice(message, path)
      flash[:notice] = message
      redirect path
    end
  end  
  
  # Log error and redirect
  error do
    logger.error env['sinatra.error'].message # log this to the output
    redirect to('500.html')
  end

  # Redirect to static 404 page
  not_found do
      redirect to('404.html')
  end  
end

# Load up all helpers first (NB)
Dir[File.dirname(__FILE__) + "/helpers/*.rb"].each do |file| 
  require file
end

# Load up all models next
Dir[File.dirname(__FILE__) + "/models/*.rb"].each do |file| 
  require file
end

DataMapper.finalize

# Load up all controllers last
Dir[File.dirname(__FILE__) + "/controllers/*.rb"].each do |file| 
  require file
end