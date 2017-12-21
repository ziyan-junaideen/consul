require 'rails_helper'

describe RelatedContentScore do

  let(:user) { create(:user) }
  let(:parent_relationable) { create([:proposal, :debate].sample) }
  let(:child_relationable) { create([:proposal, :debate].sample) }
  let(:related_content) { build(:related_content, parent_relationable: parent_relationable, child_relationable: child_relationable, author: build(:user)) }

  it "should not allow empty user or empty related_content" do
    expect(build(:related_content_score)).not_to be_valid
    expect(build(:related_content_score, related_content: related_content)).not_to be_valid
    expect(build(:related_content_score, user: user)).not_to be_valid
  end

  it "should not allow repeated related content scores" do
    score = create(:related_content_score, related_content: related_content, user: user)
    new_score = build(:related_content_score, related_content: related_content, user: user)
    expect(new_score).not_to be_valid
  end

end
