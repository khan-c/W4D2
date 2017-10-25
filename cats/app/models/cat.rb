class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper
  COLORS = ["black", "white", "brown", "orange"].freeze
  SEX = ["M", "F"].freeze

  def self.COLORS
    COLORS
  end

  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: { in: COLORS }
  validates :sex, inclusion: { in: SEX }

  has_many :rental_requests,
  class_name: :CatRentalRequest,
  primary_key: :id,
  foreign_key: :cat_id,
  dependent: :destroy


  def age
    time_ago_in_words(birth_date)
  end

end
