require 'cucumber/rails'
require 'uri'
require 'cgi'
require 'factory_bot_rails'

module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n"
      end
    end
  end
end
World(NavigationHelpers)


Given("the following administrators exist:") do |administrators|
  administrators.hashes.each do | current_admin |
    FactoryBot.create(:administrator, current_admin)
  end      
end