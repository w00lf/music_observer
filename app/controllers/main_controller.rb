class MainController < ApplicationController
  layout 'side_bar'
  def index
  	concerts = current_user.concerts.is_show.actual_concerts(params[:date_interval])
  	prev = ''
  	@shedule = {}
  	concerts.each do |con|
  		if prev == get_formated_date(con.start_date)
  			@shedule[prev].push(con)
  		else
  			@shedule[get_formated_date(con.start_date)] = [con]
  		end
  		prev = get_formated_date(con.start_date)
  	end
  	render stream: true
  end

  private

  def get_formated_date date
    I18n.localize(date, :format => "%e %B %Y")
  end
end
