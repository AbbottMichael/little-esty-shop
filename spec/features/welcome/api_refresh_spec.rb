require 'rails_helper'

RSpec.describe 'Github API Statistics' do
  before :each do
    visit '/'
    @repo_name = API.repo_name
    @user_names = API.user_names
    @commits = API.contributions[:defaults][:commits]
    @pulls = API.contributions[:defaults][:pulls]
  end

  # As a visitor or an admin user
    # When I visit any page on the site
    # I see the number of commits next to each Github username
    # This number is updated as each member of the team contributes more commits
    # I see the number of merged PRs across all team members
    # This number is updated as each member of the team merges more PRs
  it 'displays the navbar dropdown for API statistics' do
    expect(current_path).to eq('/')
    expect(page).to have_content('Github Stats')

    click_on('Github Stats')

    within "#dropdownmenu-github" do
      expect(page).to have_link(@repo_name)
      expect(page).to have_content("Total Commits:")
      expect(page).to have_content("Pull Requests:")
      @user_names.values.each do |user_name|
        expect(page).to have_content("#{user_name}: #{@commits[user_name]}")
        expect(page).to have_content("#{user_name}: #{@pulls[user_name]}")
      end
    end

  end

  it 'can refresh API statistics with a redirect back to the current page' do
    click_on('Github Stats')
    click_on('Refresh Stats 🔄')

    # save_and_open_page

    expect(current_path).to eq('/')
  end

  it 'can display default statistics with a redirect back to the current page if the API rate limit is hit' do
    allow(ApplicationController).to receive(:commits).and_return(@commits)
    allow(ApplicationController).to receive(:pulls).and_return(@pulls)

    click_on('Github Stats')
    click_on('Refresh Stats 🔄')

    click_on('Github Stats')
    within "#dropdownmenu-github" do
      @user_names.values.each do |user_name|
        expect(page).to have_content("#{user_name}: #{@commits[user_name]}")
        expect(page).to have_content("#{user_name}: #{@pulls[user_name]}")
      end
    end
  end

end
