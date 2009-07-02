require 'rubygems'
require 'active_support'
require 'active_support/test_case'

# workaround for rails being on crack (maybe?)
require 'test/unit'
require 'test/unit/testcase'
require 'active_support/testing/setup_and_teardown'
#require 'active_support/testing/assertions'

# load up the plugin in question
require 'active_record'
require 'active_record/fixtures'
require 'sanitizes_html'
require 'hpricot'

ActiveRecord::Base.class_eval do
  extend SanitizesHtml::ClassMethods
end

root_dir = File.dirname(__FILE__)

# do cocaine to make ActiveRecord happy
ActiveRecord::Base.configurations = YAML::load(File.open(File.join(root_dir, 'database.yml')))

# bring up some database stuff
ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :dbfile => ':memory:'
})

def build_schema
  # define a crude schema
  ActiveRecord::Schema.define do
    create_table "pages", :force => true do |t|
      t.column :body, :text
    end
  end

end


class ActiveSupport::TestCase
  begin
    include ActiveRecord::TestFixtures
  rescue NameError
    puts "You appear to be using a pre-2.3 version of Rails. No need to include ActiveRecord::TestFixtures..."
  end

  # compute dirname
  self.fixture_path = File.join(File.dirname(__FILE__), 'fixtures')

  build_schema

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false

  # load up fixtures
  fixtures :all
end

