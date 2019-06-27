require "rails_helper"

describe "Votes" do
    
  let(:manuela) { create(:user, verified_at: Time.current) }

  context "Investments - Knapsack" do
    let(:budget)  { create(:budget, phase: "selecting") }
    let(:group)   { create(:budget_group, budget: budget) }
    let(:heading) { create(:budget_heading, group: group) }

    before { login_as(manuela) }

    describe "Index" do

      scenario "Index shows user votes on proposals" do
        investment1 = create(:budget_investment, heading: heading)
        investment2 = create(:budget_investment, heading: heading)
        investment3 = create(:budget_investment, heading: heading)
        create(:vote, voter: manuela, votable: investment1, vote_flag: true)

        visit budget_investments_path(budget, heading_id: heading.id)

        within("#budget-investments") do
          within("#budget_investment_#{investment1.id}_votes") do
            expect(page).to have_content "You have already supported this investment project. "\
                                         "Share it!"
          end

          within("#budget_investment_#{investment2.id}_votes") do
            expect(page).not_to have_content "You have already supported this investment project. "\
                                             "Share it!"
          end

          within("#budget_investment_#{investment3.id}_votes") do
            expect(page).not_to have_content "You have already supported this investment project. "\
                                             "Share it!"
          end
        end
      end

      scenario "Create from investments' index", :js do
        create(:budget_investment, heading: heading, budget: budget)

        visit budget_investments_path(budget, heading_id: heading.id)

        within(".supports") do
          find(".in-favor a").click

          expect(page).to have_content "1 support"
          expect(page).to have_content "You have already supported this investment project. "\
                                       "Share it!"
        end
      end
    end

    describe "Single investment" do
      let(:investment) { create(:budget_investment, budget: budget, heading: heading)}

      scenario "Show no votes" do
        visit budget_investment_path(budget, investment)
        expect(page).to have_content "No supports"
      end

      scenario "Trying to vote multiple times", :js do
        visit budget_investment_path(budget, investment)

        within(".supports") do
          find(".in-favor a").click
          expect(page).to have_content "1 support"

          expect(page).not_to have_selector ".in-favor a"
        end
      end

      scenario "Create from investment show", :js do
        visit budget_investment_path(budget, investment)

        within(".supports") do
          find(".in-favor a").click

          expect(page).to have_content "1 support"
          expect(page).to have_content "You have already supported this investment project. "\
                                       "Share it!"
        end
      end
    end

    scenario "Disable voting on investments", :js do
      manuela = create(:user, verified_at: Time.current)

      login_as(manuela)

      budget.update(phase: "reviewing")
      investment = create(:budget_investment, budget: budget, heading: heading)

      visit budget_investments_path(budget, heading_id: heading.id)

      within("#budget_investment_#{investment.id}") do
        expect(page).not_to have_css("budget_investment_#{investment.id}_votes")
      end

      visit budget_investment_path(budget, investment)

      within("#budget_investment_#{investment.id}") do
        expect(page).not_to have_css("budget_investment_#{investment.id}_votes")
      end
    end

    context "Voting in multiple headings of a single group" do

      let(:new_york) { heading }
      let(:san_francisco) { create(:budget_heading, group: group) }
      let(:third_heading) { create(:budget_heading, group: group) }

      let!(:new_york_investment) { create(:budget_investment, heading: new_york) }
      let!(:san_francisco_investment) { create(:budget_investment, heading: san_francisco) }
      let!(:third_heading_investment) { create(:budget_investment, heading: third_heading) }

      before do
        group.update(max_votable_headings: 2)
      end

      scenario "From Index", :js do
        visit budget_investments_path(budget, heading_id: new_york.id)

        within("#budget_investment_#{new_york_investment.id}") do
          accept_confirm { find(".in-favor a").click }

          expect(page).to have_content "1 support"
          expect(page).to have_content "You have already supported this investment project. "\
                                       "Share it!"
        end

        visit budget_investments_path(budget, heading_id: san_francisco.id)

        within("#budget_investment_#{san_francisco_investment.id}") do
          find(".in-favor a").click

          expect(page).to have_content "1 support"
          expect(page).to have_content "You have already supported this investment project. "\
                                       "Share it!"
        end

        visit budget_investments_path(budget, heading_id: third_heading.id)

        within("#budget_investment_#{third_heading_investment.id}") do
          find(".in-favor a").click

          expect(page).to have_content "You can only support investment projects in 2 districts. "\
                                       "You have already supported investments in"

          participation = find(".participation-not-allowed")
          headings = participation.text
                     .match(/You have already supported investments in (.+) and (.+)\./)&.captures

          expect(headings).to match_array [new_york.name, san_francisco.name]

          expect(page).not_to have_content "1 support"
          expect(page).not_to have_content "You have already supported this investment project. "\
                                           "Share it!"
        end
      end

      scenario "From show", :js do
        visit budget_investment_path(budget, new_york_investment)

        accept_confirm { find(".in-favor a").click }
        expect(page).to have_content "1 support"
        expect(page).to have_content "You have already supported this investment project. Share it!"

        visit budget_investment_path(budget, san_francisco_investment)

        find(".in-favor a").click
        expect(page).to have_content "1 support"
        expect(page).to have_content "You have already supported this investment project. Share it!"

        visit budget_investment_path(budget, third_heading_investment)

        find(".in-favor a").click
        expect(page).to have_content "You can only support investment projects in 2 districts. "\
                                     "You have already supported investments in"

        participation = find(".participation-not-allowed")
        headings = participation.text
                   .match(/You have already supported investments in (.+) and (.+)\./)&.captures

        expect(headings).to match_array [new_york.name, san_francisco.name]

        expect(page).not_to have_content "1 support"
        expect(page).not_to have_content "You have already supported this investment project. "\
                                         "Share it!"
      end

    end
  end

  context "Investments - Approval" do
    # Includes only Approval Voting related tests

    let(:budget)  { create(:budget, :balloting, :approval) }

    context "Voting restrictions" do

      before { login_as(manuela) }

      scenario "Restricted voting", :js do
        group = create(:budget_group, budget: budget)
        heading = create(:budget_heading, group: group, max_votes: 2)

        investment1 = create(:budget_investment, :selected_with_price, heading: heading,
          price: heading.price)
        investment2 = create(:budget_investment, :selected_with_price, heading: heading,
          price: heading.price)

        visit budget_investments_path(budget, heading_id: heading.id)

        within "#budget_investment_#{investment1.id}_ballot" do
          click_link "Vote"
        end

        expect(page).to have_content("Remove vote")

        within("#budget_investment_#{investment2.id}") do
          find("div.ballot").hover
          expect(page).to have_content("You have already assigned the available budget")
        end

        budget.update_attribute(:money_bounded, false)

        visit budget_investments_path(budget, heading_id: heading.id)

        within("#budget_investment_#{investment2.id}") do
          find("div.ballot").hover
          expect(page).not_to have_content("You have already assigned the available budget")
        end
      end

      scenario "Unrestricted voting", :js do
        budget.update_attribute(:money_bounded, false)
        group = create(:budget_group, budget: budget)
        heading = create(:budget_heading, group: group, max_votes: 2)

        investment1 = create(:budget_investment, :selected_with_price, heading: heading,
          price: heading.price)
        investment2 = create(:budget_investment, :selected_with_price, heading: heading,
          price: heading.price)

        visit budget_investments_path(budget, heading_id: heading.id)

        within "#budget_investment_#{investment1.id}_ballot" do
          click_link "Vote"
        end

        expect(page).to have_content("Remove vote")

        within("#budget_investment_#{investment2.id}") do
          find("div.ballot").hover
          expect(page).not_to have_content("You have already assigned the available budget")
        end
      end
    end
  end
end
