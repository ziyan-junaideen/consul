class CensusCaller

  def call(document_type, document_number)
    if Setting['feature.census_api']
      response = CensusApi.new.call(document_type, document_number)
    elsif Setting['feature.local_census']
      response = LocalCensus.new.call(document_type, document_number)
    end

    response
  end
end
