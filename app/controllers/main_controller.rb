class MainController < ApplicationController
  def index
  	concerts = Concert.actual_concerts(params[:date_interval])
  	prev = ''
  	@shedule = {}
  	concerts.each do |con|
  		if prev == con.start_date.strftime("%e %B %Y")
  			@shedule[prev].push(con)
  		else
  			@shedule[con.start_date.strftime("%e %B %Y")] = [con]
  		end
  		prev = con.start_date.strftime("%e %B %Y")
  	end
  	render stream: true
  end
end
