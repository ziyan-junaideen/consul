class Verification::Management::ManagedUser
  include ActiveModel::Model

  def self.find(document_type, document_number)
    return User.find_by_username(document_number) || User.new if document_type == 'username'

    User.where('document_number is not null').
    find_or_initialize_by(document_type:   document_type,
                          document_number: document_number)
  end

end