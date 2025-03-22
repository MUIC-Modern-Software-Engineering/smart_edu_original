require "test_helper"

class ClassroomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eiei_school = School.create!(name: "Eiei School", address: "123 Main St")
    @classroom = Classroom.create!(
      grade_level: 5,
      class_id: "MATH101",
      school_id: @eiei_school.id
    )
    @student = Student.first
    @student2 = Student.second
    sign_in
  end

  test "should get show" do
    get classroom_url(@classroom)
    assert_response :success
  end
end
