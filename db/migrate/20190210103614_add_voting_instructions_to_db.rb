class AddVotingInstructionsToDb < ActiveRecord::Migration
  def up
    Setting['pb-input.voting_instructions'] = 'Click on your district to see the proposed projects.'
  end

  def down
    Setting.where(key: 'pb-input.voting_instructions').delete_all
  end
end
