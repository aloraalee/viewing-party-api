require "rails_helper"

RSpec.describe ViewingParty, type: :model do
  describe "relationships" do 
    it {should have_many :attendees}
  end
end