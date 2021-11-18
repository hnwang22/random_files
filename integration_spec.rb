# location: spec/feature/integration_spec.rb
require 'rails_helper'


#test for selecting members
RSpec.describe 'test member priv: ', type: :feature do
	scenario 'valid non-admin' do
		visit new_member_path
		fill_in 'Name', with: 'Jack'
		select false, :from => 'member_isAdmin'
		select false, :from => 'member_isOwner'
		click_on 'Create Member'
		visit members_path
		expect(page).to have_content(false).twice
	end
	scenario 'valid admin' do
		visit new_member_path
		fill_in 'Name', with: 'John'
		select true, :from => 'member_isAdmin'
		select false, :from => 'member_isOwner'
		click_on 'Create Member'
		visit members_path
		expect(page).to have_content(false)
		expect(page).to have_content(true)
	end
	scenario 'valid owner' do
		visit new_member_path
		fill_in 'Name', with: 'Jen'
		select true, :from => 'member_isAdmin'
		select true, :from => 'member_isOwner'
		click_on 'Create Member'
		visit members_path
		expect(page).to have_content(true).twice
	end
end


RSpec.describe 'test points: ', type: :feature do
	scenario 'valid points' do
		visit new_member_path
		fill_in 'Name', with: 'Jacob'
		select false, :from => 'member_isAdmin'
		select false, :from => 'member_isOwner'
		fill_in 'member_totalPoints', with: '110'
		click_on 'Create Member'
		visit members_path
		expect(page).to have_content('110')
	end
	scenario 'invalid points' do
		visit members_path
		expect(page).not_to have_content('1000000')
	end
end

=begin
#FIXME - hardcoded so doesn't work with Oauth
RSpec.describe 'test likes', type: :feature do
	scenario 'valid inputs'do
		visit new_like_path
		fill_in 'member_id', with: '1'
		fill_in 'post_id', with: '1'
		click_on 'Create Like'
		visit likes_path
		expect(page).to have_content('1')
	end
end
=end

=begin
#test likes valid inputs
#modified 'Name', 'post_title', 'post_body'

#ActiveRecord::InvalidForeignKey:
       PG::ForeignKeyViolation: ERROR:  insert or update on table "posts" violates foreign key constraint "fk_rails_98586e02b8"
       DETAIL:  Key (member_id)=(1) is not present in table "members".

RSpec.describe 'test likes', type: :feature do
	scenario 'valid inputs'do
		visit new_member_path
		fill_in 'Name', with: 'Andrew'
		click_on 'Create Member'
		visit new_post_path
		fill_in 'post_title', with: 'test'
		fill_in 'post_body', with: 'this is a test'
		click_on 'Create Post'
		visit new_like_path
		#fill_in 'member_id', with: '1'
		#fill_in 'post_id', with: '1'
		click_on 'Create Like'
		visit post_path
		expect(page).to have_content('1')
	end
end
=end

RSpec.describe 'test announcements: ', type: :feature do
	scenario 'valid announcement' do
		visit announcements_path
		fill_in 'announcement_title', with: 'Hello World'
		fill_in 'announcement_message', with: 'Hello World is our message!'
		click_on 'Post'
		expect(page).to have_content('Hello World')
		expect(page).to have_content('Hello World is our message!')
	end
	scenario 'edit annnoucements' do
		visit announcements_path
		fill_in 'announcement_title', with: 'Temp123'
		fill_in 'announcement_message', with: 'Temp-message'
		click_on 'Post'
		expect(page).to have_content('Temp123')
		expect(page).to have_content('Temp-message')
		click_on 'edit'
		fill_in 'announcement_message', with: 'message123'
		click_on 'commit'
		visit announcements_path
		expect(page).to have_content('message123')
	end
	scenario 'delete announcement' do
		visit announcements_path
		fill_in 'announcement_title', with: 'Temp'
		fill_in 'announcement_message', with: 'Temp message'
		click_on 'Post'
		expect(page).to have_content('Temp')
		expect(page).to have_content('Temp message')
		click_on 'delete'
		click_on 'Confirm Delete'
		expect(page).not_to have_content('Temp')
		expect(page).not_to have_content('Temp message')
	end
end

RSpec.describe 'test events', type: :feature do
	scenario 'create new event' do
		visit new_event_path
		fill_in 'event_name', with: 'General Meeting'
		select '2021', :from => 'event_date_1i'
		select 'October', :from => 'event_date_2i'
		select '12', :from => 'event_date_3i'
		#select false, :from => 'event_status' #ERROR can't edit
		click_on 'Create Event'
		visit events_path
		expect(page).to have_content('General Meeting')
	end
end

=begin
#test posts create new post
#FIXME - can't make posts without member_id (need to function with Oauth)
RSpec.describe 'test posts', type: :feature do
	scenario 'create new post' do
		visit new_post_path
		fill_in 'post_title', with: 'Welcome New Members'
		fill_in 'post_body', with: 'We have some new members to introduce'
		click_on 'Create Post'
		visit posts_path
		expect(page).to have_content('Welcome New Members')
	end
end
=end

=begin
#test activities valid inputs
RSpec.describe 'test activities', type: :feature do
	scenario 'valid inputs' do
		visit new_activity_path
		fill_in 'name', with: 'Meeting'
		fill_in 'points', with: '10'
		click_on 'Create Activity'
		visit activity_path
		expect(page).to have_content('Meeting')
	end
end
=end


=begin
feature 'sign in', :omniauth do
	scenario 'invalid sign-in' do
		OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
		visit logins_path
		expect(page).to have_content('Sign In')
		click_link 'Sign In'
		expect(page).to have_content('Authentication error')
	end
end

#--------------------------------------
RSpec.describe 'signin process', type: :feature do
	before do
		puts user_omniauth_authorize_path(:google_oauth2)
		Capybara.current_driver = :selenium
		visit user_omniauth_authorize_path(:google_oauth2)
	end
	scenario 'valid non-admin' do
		visit new_member_path
		fill_in 'Name', with: 'Jack'
		click_on 'Create Member'
		visit members_path
		expect(page).to have_content(false) #fail if true
	end
end
=end
