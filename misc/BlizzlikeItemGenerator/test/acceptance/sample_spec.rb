require_relative 'acceptance_helper'

describe('Start page', :type => :feature) do

  before do
    visit '/'
  end

  it 'responds with successful status' do
    expect( page.status_code ).to eq 200
  end

  it 'shows the welcome message', :driver => :selenium do
    expect( page ).to have_content 'Hello Sinatra Skeleton!'
  end

end