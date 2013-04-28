# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|

  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    #Movie.create :title => movie["title"], :rating => movie["rating"], :release_date => movie["release_date"]
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

Then /the director of \"(.*)\" should be \"(.*)\"/ do |title, director|
  p "<<<<<<<<" + title.to_s + "- ---  -" + director.to_s
  movie = Movie.where("title like ?",  title)
  movie[0].update_attribute(:director, director)
end
