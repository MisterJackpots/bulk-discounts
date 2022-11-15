# require './app/poros/github_contributor_search'
require './app/poros/holiday_search'

class ApplicationController < ActionController::Base
  # before_action :get_info, only: %i[index show new edit]
  before_action :get_holidays, only: %i[index]

  def get_holidays
    @holidays = HolidaySearch.new.public_holidays
  end

  # def get_info
  #   @repo_name = GithubSearch.new.repo_information
  #   @contributors = GithubSearch.new.contributor_names
  #   @pull_requests = GithubSearch.new.pull_requests
  # end
end
