require "rubygems"
require "logger"
require "active_record"

namespace :db do
  def load_config
    conf = YAML.load(File.read(ENV["CONFIG"]))["db"]

    {
      "development" => {
        :adapter  => "mysql2",
        :encoding => "utf8",
        :database => conf["database"],
        :username => conf["username"],
        :password => conf["password"],
        :host     => conf["host"]
      }
    }
  end

  task :load_config do
    if !ENV["CONFIG"]
      abort("Set CONFIG env var to the location of a config file.")
    end

    RAILS_ROOT = File.expand_path("../", __FILE__)
    ActiveRecord::Base.configurations = load_config
  end

  task :create => :load_config do
    config     = load_config["development"]
    @charset   = ENV['CHARSET']   || 'utf8'
    @collation = ENV['COLLATION'] || 'utf8_unicode_ci'
    ActiveRecord::Base.establish_connection(config.merge(:database => nil))
    ActiveRecord::Base.connection.create_database(config[:database], :charset   => (config['charset'] || @charset), 
                                                                      :collation => (config['collation'] || @collation))
    ActiveRecord::Base.establish_connection(config)
  end

  task :drop => :load_config do
    config     = load_config["development"]
    @charset   = ENV['CHARSET']   || 'utf8'
    @collation = ENV['COLLATION'] || 'utf8_unicode_ci'
    ActiveRecord::Base.establish_connection(config.merge(:database => nil))
    ActiveRecord::Base.connection.drop_database(config[:database])
  end

  task :migrate => :load_config do
    RAILS_ENV = "development"
    ActiveRecord::Base.logger = Logger.new("/dev/null")
    config     = load_config["development"]
    @charset   = ENV['CHARSET']   || 'utf8'
    @collation = ENV['COLLATION'] || 'utf8_unicode_ci'
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate/", nil)
    Rake::Task["db:schema_dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end

  task :schema_dump => :load_config do
    require 'active_record/schema_dumper'
    File.open(ENV['SCHEMA'] || "#{RAILS_ROOT}/db/schema.rb", "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
    Rake::Task["db:schema_dump"].reenable
  end
end
