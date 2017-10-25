class CatRentalRequest < ApplicationRecord
  STATUS = ["PENDING", "APPROVED", "DENIED"]

  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: STATUS }
  validate :does_not_overlap_approved_request

  belongs_to :cat,
    class_name: :Cat,
    primary_key: :id,
    foreign_key: :cat_id


  def overlapping_requests
    CatRentalRequest.where("start_date BETWEEN ? AND ? OR end_date BETWEEN ? AND ?",
                            start_date, end_date, start_date, end_date)
                    .where(cat_id: cat_id)
                    .where.not(id: id)

  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

  def approve!
    CatRentalRequest.transaction do
      self.overlapping_pending_requests.each(&:deny!)
      self.update(status: "APPROVED")
    end
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = ?", 'PENDING')
  end

  def deny!
    self.update!(status: "DENIED")
  end

  def pending?
    status == 'PENDING'
  end

  private

  def does_not_overlap_approved_request

    return if self.status == 'DENIED'
    if overlapping_approved_requests.any?
      errors[:status] << 'already rented out'
    end
  end
end
