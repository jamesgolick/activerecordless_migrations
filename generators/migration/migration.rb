require "active_support/all"

module Generate
  class Migration < Thor::Group
    include Thor::Actions

    source_root File.dirname(__FILE__)

    argument :name

    def create_source_file
      date = Time.now.strftime("%Y%m%d%H%M%S")
      template("templates/migration.rb.erb", "db/migrate/#{date}_#{name}.rb")
    end
  end
end
