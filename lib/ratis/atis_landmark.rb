require 'ratis/atis_model'

class AtisLandmark
  extend AtisModel

  attr_accessor :type, :verbose, :location, :locality

  implement_soap_action 'Getlandmarks', 1.4

  def self.where(criteria)

    type = criteria.delete(:type).to_s.upcase
    raise ArgumentError.new('You must provide a type') if type.blank?
    all_criteria_used? criteria

    response = atis_request 'Getlandmarks', {'Type' => type}
    return [] unless response.success?

    response.to_array(:getlandmarks_response, :landmarks, :landmark).collect do |landmark|
      atis_landmark = AtisLandmark.new
      atis_landmark.type = landmark[:type]
      atis_landmark.verbose = landmark[:verbose]
      atis_landmark.location = landmark[:location]
      atis_landmark.locality = landmark[:locality]
      atis_landmark
    end

  end

end
