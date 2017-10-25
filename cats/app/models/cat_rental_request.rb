class CatRentalRequest < ApplicationRecord
  STATUS = ["PENDING", "APPROVED", "DENIED"]
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: STATUS}
  validate :does_not_overlap_approved_request

  belongs_to :cat,
  class_name: :Cat,
  primary_key: :id,
  foreign_key: :cat_id


  def overlapping_requests
    CatRentalRequest.where("start_date BETWEEN ? AND ? OR end_date BETWEEN ? AND ? AND cat_id = ?",
                            self.start_date, self.end_date, self.start_date, self.end_date, self.cat_id)
                    .where.not(id: self.id)

  end

  def overlapping_approved_requests
    overlapping_requests.where("status = ?", 'APPROVED')
  end

  def approve!
    CatRentalRequest.transaction do
      self.update_attributes!(status: "APPROVED")
      self.overlapping_pending_requests.each do |request|
        request.deny!
      end
    end
  end
  
  def overlapping_pending_requests
    overlapping_requests.where("status = ?", 'PENDING')
  end

  def deny!
    self.update_attributes!(status: "DENIED")
  end

  private

  def does_not_overlap_approved_request
    return if self.status == 'DENIED'
    if overlapping_approved_requests.any?
      errors[:status] << 'already rented out'
    end
  end
end
