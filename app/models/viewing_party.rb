class ViewingParty < ApplicationRecord
  has_many :attendees
  has_many :users, through: :attendees
  has_many :invitees, through: :attendees, source: :user
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true
  validates :movie_title, presence: true
end