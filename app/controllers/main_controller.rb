class MainController < ApplicationController
  def index
  	render stream: true
  end
end
