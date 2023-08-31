# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :events, dependent: :destroy
  has_many :event_attendances, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :attend_events, through: :event_attendances, class_name: 'Event', source: :event
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_events, through: :bookmarks, class_name: 'Event', source: :event
  has_many :notifications, foreign_key: :receiver_id, dependent: :destroy, inverse_of: :sender
  has_many :user_notification_timings, dependent: :destroy
  has_many :notification_timings, through: :user_notification_timings
  has_one_attached :avatar

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  scope :allowing_created_event_notification,
        -> { joins(:notification_timings).merge(NotificationTiming.created_event) }
  scope :allowing_commented_to_event_notification,
        -> { joins(:notification_timings).merge(NotificationTiming.commented_to_event) }
  scope :allowing_attended_to_event_notification,
        -> { joins(:notification_timings).merge(NotificationTiming.attended_to_event) }
  scope :allowing_liked_event_notification,
        -> { joins(:notification_timings).merge(NotificationTiming.liked_event) }

  enum gender: {other: 0 , man: 1, woman: 2}

  def owner?(event)
    event.user_id == id
  end

  def attend(event)
    event_attendances.find_or_create_by(event_id: event.id)
  end

  def attend?(event)
    attend_events.include?(event)
  end

  def cancel_attend(event)
    attend_events.destroy(event)
  end

  def bookmark(event)
    bookmarks.find_or_create_by(event_id: event.id)
  end

  def unbookmark(event)
    bookmark_events.destroy(event)
  end

  def bookmarked?(event)
    event.bookmarks.pluck(:user_id).include?(id)
  end

  def own?(event)
    event.user_id == id
  end

  def allow_created_event_notification?
    notification_timings.created_event.present?
  end

  def allow_commented_to_event_notification?
    notification_timings.commented_to_event.present?
  end

  def allow_attended_to_event_notification?
    notification_timings.attended_to_event.present?
  end

  def allow_liked_event_notification?
    notification_timings.liked_event.present?
  end
end
