class AssignmentQuestion < ActiveRecord::Base
  belongs_to :assignment
  has_many :assignment_question_grades, dependent: :restrict

  validates :points, presence: true
  validates :order_number, presence: true
  validates :question, presence: true

end
