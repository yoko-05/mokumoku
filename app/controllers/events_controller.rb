# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @q = Event.future.ransack(params[:q])
    @events = @q.result(distinct: true).includes(:bookmarks, :prefecture, user: { avatar_attachment: :blob })
                .order(created_at: :desc).page(params[:page])
  end

  def future
    @q = Event.future.ransack(params[:q])
    @events = @q.result(distinct: true).includes(:bookmarks, :prefecture, user: { avatar_attachment: :blob })
                .order(held_at: :asc).page(params[:page])
    @search_path = future_events_path
    render :index
  end

  def past
    @q = Event.past.ransack(params[:q])
    @events = @q.result(distinct: true).includes(:bookmarks, :prefecture, user: { avatar_attachment: :blob })
                .order(held_at: :desc).page(params[:page])
    @search_path = past_events_path
    render :index
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)

    if current_user.woman? && params[:event][:only_woman] == "1"
      @event.only_woman = true
    end

    if @event.save
      User.all.find_each do |user|
        NotificationFacade.created_event(@event, user)
      end

      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    @event = current_user.events.find(params[:id])
    if @event.update(event_params)
      redirect_to event_path(@event)
    else
      render :edit
    end
  end

  private

  def event_params
    params.require(:event).permit(:only_woman, :title, :content, :held_at, :prefecture_id, :thumbnail)
  end
end
