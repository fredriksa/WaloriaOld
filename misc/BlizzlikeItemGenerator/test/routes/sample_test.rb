require_relative 'routes_helper'

describe 'Base routes' do

  it 'should allow access to /' do
    get '/'
    expect( last_response).to be_ok
  end



end