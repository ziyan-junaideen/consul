require 'csv'

class BudgetIdeaImporter
  attr_accessor :heading, :default_author, :success, :error

  delegate :budget, :group, to: :heading

  def initialize(heading, default_author)
    @heading = heading
    @default_author = default_author
    @error = []
    @success = []
  end

  def import(file_path)
    load_data(file_path)

    @csv.each_with_index do |row, index|
      author = author_from_row(row) || default_author
      title = title_from_row(row)
      description = description_from_row(row)

      options = {
        kind: 'idea',
        heading: heading,
        group: group,
        title: title,
        description: description,
        author: author,
        terms_of_service: '1',
        location: row['Location'],
        tag_list: row['Categories']
      }

      add_map(options, row)

      investment = budget.investments.create(options)

      if investment.persisted?
        @success << investment
      else
        @error << investment
      end
    end
  end

  def self.import(heading, default_author, file_path)
    new.import(file_path)
  end

  private

  def load_data(file_path)
    @csv = CSV.parse(File.read(file_path), headers: true)
  end

  def author_from_row(row)
    username = row['Author Username']
    email = row['Email']
    phone = row['Phone Number']

    return unless username || email

    existing = User.find_by_username(username) || User.find_by_email(email)
    return existing if existing

    user = User.create(
      username: username,
      email: email,
      phone_number: phone,
      terms_of_service: '1',
      skip_password_validation: '1'
    )

    user.persisted? ? user : nil
  end

  def add_map(options, row)
    lat = row['Latitude']
    lng = row['Longitude']

    if lat.nil? || lng.nil?
      options[:skip_map] = '1'
    else
      options[:map_location_attributes] = {
        latitude: lat,
        longitude: lng,
        zoom: 14
      }
    end
  end

  def title_from_row(row)
    row['Idea'].split(' ')[0..5].join(' ')
  end

  def description_from_row(row)
    row['Idea']
  end
end
