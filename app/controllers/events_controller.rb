class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def near
    @events = Event.near([params[:latitude], params[:longitude]], 3).limit(1)
  end

  def index
    @events = current_user.events.all
    respond_with(@events)
  end

  def show
    respond_with(@event)
  end

  def new
    @event = current_user.events.new
    respond_with(@event)
  end

  def edit
  end

  def create
    @event = current_user.events.new(event_params)
    @event.save
    respond_with(@event)
  end

  def update
    @event.update(event_params)
    respond_with(@event)
  end

  def destroy
    @event.destroy
    respond_with(@event)
  end

  private
    def set_event
      @event = current_user.events.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :address, :latitude, :longitude)
    end
end
