require_relative 'models_helper'

describe User do

  before do
    @user = User.new('Reginald', 'Fartswaith')
  end

  describe 'name convenience method' do

    it 'should return first and last names' do
      expect( @user.name ).to match 'Reginald Fartswaith'
    end

  end

end