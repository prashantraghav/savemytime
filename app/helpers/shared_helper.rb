module SharedHelper

  def filter_by
    @filter_params = []
    @filter_by = params[:filter_by] || "today"

    case @filter_by
    when "on_date"
      @filter_params = [parse_date(params[:filter_on_date])]
    when "between_date"
      @filter_params = [parse_date(params[:filter_from_date]), parse_date(params[:filter_to_date])]
    end
    return @filter_by, @filter_params
  end

  def parse_date(date)
    date = date.split("-")
    date.reverse!
    Date.new(date[0].to_i, date[1].to_i, date[2].to_i)
  end

end
