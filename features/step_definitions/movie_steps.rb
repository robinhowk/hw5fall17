# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these   

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date])
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
    selected_ratings = arg1.split(', ')
    Movie.all_ratings.each do |rating|
        if !selected_ratings.include? rating
            uncheck("ratings_#{rating}")
        end
    end
    click_button 'Refresh'
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    ratings = arg1.split(', ')
    value = 0
    ratings.each do |rating|
        value = value + Movie.where(:rating => rating).count
    end
    
    rows = page.all("table#movies tr").count
    rows.should == value + 1
end

Then /^I should see all of the movies$/ do
    value = Movie.count
    rows = page.all("table#movies tr").count.should
    rows.should == value + 1 
end

When /^I click on "(.*?)"$/ do |arg1|
    click_link(arg1)
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |arg1, arg2|
    arg1_found = false
    arg2_found = false
    result = false
    all("tr").each do |tr|
        if tr.has_content?(arg1)
            arg1_found = true
            if arg2_found == false
                result = true
                break
            end
        elsif tr.has_content?(arg2)
            arg2_found = true
        end
    end
    expect(result).to be_truthy
end