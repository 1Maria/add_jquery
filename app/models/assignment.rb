class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :assignment_questions, -> {order :order_number}
  has_many :assignment_grades, dependent: :restrict

  validates :course_id, presence: true
  validates :name, presence: true
  validates :active_at, presence: true
  validates :due_at, presence: true

  scope :active, -> { where("active_at <= ? AND due_at >= ?", Time.now, Time.now) }

  accepts_nested_attributes_for :assignment_questions,
      :allow_destroy => true,
      :reject_if     => :all_blank

  def status(user = nil)
    AssignmentStatus.new(assignment: self, user: user)
  end

  def course_code_and_name
    course.code_and_name
  end

  def course_color
    course.color
  end

  def turn_in(answers, user, final=true)
    if can_be_turned_in_by(user)
      course_student = CourseStudent.where(student: user, course: course).first
      assignment_grade = AssignmentGrade.where(assignment: self,
        course_student: course_student).first_or_create!

      assignment_grade.submitted_at = Time.now if final

      unless answers.blank?
        answers.each do |k,v|
          aqg = AssignmentQuestionGrade.where(assignment_question_id: k.to_i,
            assignment_grade: assignment_grade).first_or_create!
            aqg.answer = v
            aqg.save!
        end
      end

      assignment_grade.save!
    end
  end

  def can_be_turned_in_by(user)
    students_can_submit && user && user.enrolled?(course) && status(user).overdue_or_in_progress?
  end

  def has_been_answered_by(user)
    if user
      if (course_student = CourseStudent.where(student: user, course: course).first)
        assignment_grades.where(course_student_id: course_student.id).first
      end
    end
  end

  def letter_grade_for(user)
    if (assignment_grade = has_been_answered_by(user))
      assignment_grade.letter_grade
    end
  end

end
