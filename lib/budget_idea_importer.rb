require 'csv'

class BudgetIdeaImporter
  def initialize
    path = Rails.root.join('archives', 'budget_idea_import.csv')
    @csv = CSV.parse(File.read(path))
  end

  def perform
    @csv.each_with_index do |row, index|
      begin
        budget = budget_from_row(row)
        heading = heading_from_row(budget, row)
        author = author_from_row(row)

        options = {
          kind: 'idea',
          heading: heading,
          group: heading.group,
          title: row['Title'],
          description: row['Description'],
          author: author,
          terms_of_service: '1'
        }

        add_map(options, row)

        budget.investments.create!(options)
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace
        next
      end
    end
  end

  def self.perform
    new.perform
  end

  private

  def budget_from_row(row)
    Budget.find(row['ID'])
  end

  def heading_from_row(budget, row)
    group = budget.groups.find_by_name!(row['Group'])
    group.headings.find_by_name!(row['Heading'])
  end

  def author_from_row(row)
    User.find_by_username! row['Author username']
  end

  def add_map(options, row)
    lat = row['Latitude'].strip
    lng = row['Longitude'].strip

    if lat.empty? || lng.empty?
      options[:skip_map] = '1'
    else
      options[:map_location_attributes] = {
        latitude: lat,
        longitude: lng,
        zoom: 14
      }
    end
  end
end
