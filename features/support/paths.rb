# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      begin
      #  p "page name: " + page_name
        '/movies'
      end
    when /^Find Movies With Same Director$/
      begin
        '/search_movies_director'
      end


    when /^the edit page for \"(.*)\"$/
      begin
        task =  page_name.split( /the (.*) page for \"(.*)\"$/)[1]
        title =  page_name.split( /the (.*) page for \"(.*)\"$/)[2]

        movie = Movie.where("title like ? ", title)

        '/movies/' + movie[0].id.to_s + '/edit'

        end
      when /^the details page for \"(.*)\"$/
      begin
        task =  page_name.split( /the (.*) page for \"(.*)\"$/)[1]
        title =  page_name.split( /the (.*) page for \"(.*)\"$/)[2]

        movie = Movie.where("title like ? ", title)

        '/movies/' + movie[0].id.to_s
      end

      when /^the Similar Movies page for "Star Wars"/
      begin
        '/search_movies_director'
      end

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
