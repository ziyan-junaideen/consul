require 'csv'

class BudgetIdeaImporter
  attr_accessor :heading, :default_author

  delegate :budget, :group, to: :heading

  def initialize(heading, default_author)
    @heading = heading
    @default_author = default_author
  end

  def import(file_path)
    load_data(file_path)

    @csv.each_with_index do |row, index|
      author = author_from_row(row) || default_author

      options = {
        kind: 'idea',
        heading: heading,
        group: group,
        title: row['Title'],
        description: row['Description'],
        author: author,
        terms_of_service: '1',
        location: row['Location']
      }

      add_map(options, row)

      budget.investments.create!(options)
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
end
