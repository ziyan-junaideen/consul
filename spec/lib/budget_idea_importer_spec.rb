require 'rails_helper'

RSpec.describe BudgetIdeaImporter do
  subject { described_class.new(heading, default_author).import(file_path) }

  let(:heading) { create(:budget_heading) }
  let(:default_author) { create(:user) }
  let(:file_path) { Rails.root.join('spec', 'fixtures', 'files', 'idea_import.csv') }

  describe '#import' do
    it 'creates budget investments (idea)' do
      expect { subject }.to change { heading.investments.idea.count }.by(3)
    end

    it 'assigns values' do
      subject
      investment = heading.investments.idea.first

      expect(investment.title).to eq('increase number of planted trees along')
      expect(investment.description).to eq('increase number of planted trees along 4th Avenue increase number of planted trees along 4th Avenue')
      expect(investment.location).to eq('Park Slope to Gowanus')
      expect(investment.map_location.latitude).to eq(40.672014)
      expect(investment.map_location.longitude).to eq(-73.987251)
      expect(investment.author.username).to eq('Rex Tang')
      expect(investment.author.email).to eq('rex.tang@gmail.com')
      expect(investment.author.phone_number).to eq('917-498-1234')
    end

    it 'creates map location if present' do
      expect { subject }.to change { MapLocation.count }.by(2)
    end

    it 'creates non existing users' do
      expect { subject }.to change { User.count }.by(2)
    end

    it 'when user not available, defaults to the provided user' do
      expect { subject }.to change { default_author.budget_investments.count }.by(1)
    end
  end
end
