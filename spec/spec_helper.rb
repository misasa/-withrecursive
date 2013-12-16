
require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
end

require "active_support"
require "with_recursive"
Dir.glob(File.expand_path("../support/**/*.rb", __FILE__)) { |f| require f }

database = "with_recursive_test"
ActiveRecord::Base.establish_connection(adapter: "postgresql", user: "postgres", pasword: "postgres")

RSpec.configure do |config|
  migrations = ActiveRecord::Migration.descendants
  config.before(:suite) do
    ActiveRecord::Base.connection.recreate_database(database)
    migrations.each { |m| m.suppress_messages { m.migrate(:up) } }
  end
  config.after(:suite) do
    migrations.each { |m| m.suppress_messages { m.migrate(:down) } }
  end
  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
