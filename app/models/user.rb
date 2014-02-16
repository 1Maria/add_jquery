class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :course_instructors, foreign_key: "instructor_id", dependent: :restrict
  has_many :courses_taught, through: :course_instructors, source: :course
  has_many :assignments_given, through: :courses_taught, source: :assignments

  has_many :course_students, foreign_key: "student_id", dependent: :restrict
  has_many :courses_taken, through: :course_students, source: :course
  has_many :assignments_taken, through: :courses_taken, source: :assignments

  has_many :assignment_grades, through: :course_students, dependent: :restrict
  has_many :assignment_question_grades, through: :assignment_grades

  belongs_to :school

  validates :first_name, presence: true
  validates :last_name, presence: true

  scope :want_to_be_instructors, -> { where(wants_to_be_instructor: true) }
  scope :instructors_for_school_id, ->(school_id) { where(school_id: school_id, instructor: true) }

  default_scope order('last_name, first_name')

  def full_name
    "#{title + " " if title}#{first_name} #{padded_middle_initial}#{last_name}"
  end

  def school_name
    school ? school.name : "None"
  end

  def middle_initial
    middle_name ? middle_name.first : nil
  end

  def student?
    number_of_courses_taken > 0
  end

  def enrolled?(course)
    courses_taken.include?(course)
  end

  def teaching?(course)
    courses_taught.include?(course)
  end

  def grade(course)
    course_students.where(course_id: course.id).first.grade
  end

  def grade_on_assignment(assignment)
    ag = assignment_grades.graded.where(assignment: assignment).first
    ag.grade if ag
  end

  #I went the WRONG WAY on this method to have a good case study to analyze soon.
  def current_grade_on_question(assignment_question)
    course_student = CourseStudent.where(student_id: id, course_id: assignment_question.assignment.course_id).first
    assignment_grade = AssignmentGrade.where(assignment_id: assignment_question.assignment_id,
      course_student_id: course_student.id).first
    return nil if assignment_grade.blank?
    assignment_question_grade = AssignmentQuestionGrade.where(assignment_grade_id: assignment_grade.id,
      assignment_question_id: assignment_question.id).first
    assignment_question_grade.grade if assignment_question_grade
  end

  def letter_grade(course)
    course_students.where(course_id: course.id).first.letter_grade
  end

  def min_grade(course)
    course_students.where(course_id: course.id).first.min_grade
  end

  def max_grade(course)
    course_students.where(course_id: course.id).first.max_grade
  end

  def fraction_graded(course)
    course_students.where(course_id: course.id).first.fraction_graded
  end

  def completed_assignment?(assignment)
    assignment_grades.where(["assignment_id = ? AND submitted_at IS NOT NULL", assignment.id]).exists?
  end

  def overdue_assignment?(assignment)
    overdue_assignments.include?(assignment)
  end

  def overdue_assignments
    assignments_taken.select {|a| a.due_at < Time.now &&
      assignment_grades.where(["assignment_id = ? AND submitted_at IS NOT NULL", a.id]).blank? }
  end

  def ungraded_assignment?(assignment)
    ungraded_assignments.include?(assignment)
  end

  def ungraded_assignments
    assignments_given.select {|a| a.due_at < Time.now && !a.grades_released }
  end

  def overdue_or_active_assignments
    overdue_assignments + assignments_taken.active
  end

  def number_of_courses_taken
    course_students.count
  end

  private

  def padded_middle_initial
    middle_initial.blank? ? "" : "#{middle_initial}. "
  end
end
