module ApplicationHelper

  def options_for_rating_star
    options_for_select((1..5).to_a.reverse.map { |number| [ pluralize(number, "Start"), number] })
  end
end
