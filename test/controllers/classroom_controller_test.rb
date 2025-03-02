require "test_helper"

class ClassroomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @classroom = Classroom.create!(class_id: "1B", grade_level: 1)
    @student = Student.first
    @student2 = Student.second
    sign_in
  end

  test "should get show" do
    get classroom_url(@classroom)
    assert_response :success
  end
end
