module IdeasHelper
  def idea_phases?(phase)
    %w[ideas_collection project_forming].include? phase
  end
end
