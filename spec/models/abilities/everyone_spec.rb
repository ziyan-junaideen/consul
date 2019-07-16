require "rails_helper"
require "cancan/matchers"

describe Abilities::Everyone do
  subject(:ability) { Ability.new(user) }

  let(:user) { nil }
  let(:debate) { create(:debate) }
  let(:proposal) { create(:proposal) }

  it { should be_able_to(:index, Debate) }
  it { should be_able_to(:show, debate) }
  it { should_not be_able_to(:edit, Debate) }
  it { should_not be_able_to(:vote, Debate) }
  it { should_not be_able_to(:flag, Debate) }
  it { should_not be_able_to(:unflag, Debate) }

  it { should be_able_to(:index, Proposal) }
  it { should be_able_to(:show, proposal) }
  it { should_not be_able_to(:edit, Proposal) }
  it { should_not be_able_to(:vote, Proposal) }
  it { should_not be_able_to(:flag, Proposal) }
  it { should_not be_able_to(:unflag, Proposal) }

  it { should be_able_to(:show, Comment) }

  it { should be_able_to(:index, Budget) }

  it { should_not be_able_to(:manage, Dashboard::Action) }

  context "when accessing poll results" do
    let(:results_enabled) { true }
    let(:poll) { create(:poll, :expired, results_enabled: results_enabled) }

    it { should be_able_to(:results, poll) }

    context "and results disabled" do
      let(:results_enabled) { false }

      it { should_not be_able_to(:results, poll) }
    end

    context "and not expired" do
      let(:poll) { create(:poll, :current, results_enabled: true) }

      it { should_not be_able_to(:results, poll) }
    end
  end

  context "when accessing poll stats" do
    let(:stats_enabled) { true }
    let(:poll) { create(:poll, :expired, stats_enabled: stats_enabled) }

    it { should be_able_to(:stats, poll) }

    context "and stats disabled" do
      let(:stats_enabled) { false }

      it { should_not be_able_to(:stats, poll) }
    end

    context "and not expired" do
      let(:poll) { create(:poll, :current, stats_enabled: true) }

      it { should_not be_able_to(:stats, poll) }
    end
  end

  context "when accessing budget results" do
    context "budget is not finished" do
      let(:budget) { create(:budget, phase: "reviewing_ballots", results_enabled: true) }

      it { should_not be_able_to(:read_results, budget) }
    end

    context "budget is finished" do
      let(:budget) { create(:budget, :finished) }

      it { should be_able_to(:read_results, budget) }
    end

    context "results disabled" do
      let(:budget) { create(:budget, :finished, results_enabled: false) }

      it { should_not be_able_to(:read_results, budget) }
    end
  end

  context "when accessing budget stats" do
    context "supports phase is not finished" do
      let(:budget) { create(:budget, phase: "selecting", stats_enabled: true) }

      it { should_not be_able_to(:read_stats, budget) }
    end

    context "supports phase is finished" do
      let(:budget) { create(:budget, phase: "valuating", stats_enabled: true) }

      it { should be_able_to(:read_stats, budget) }
    end

    context "stats disabled" do
      let(:budget) { create(:budget, phase: "valuating", stats_enabled: false) }

      it { should_not be_able_to(:read_stats, budget) }
    end
  end
end
