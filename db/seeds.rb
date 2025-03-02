puts "Seeding data..."

# Only clear data in dev or test. In production, we skip this so we don't nuke real data.
if Rails.env.development? || Rails.env.test?
  puts "Clearing existing data (Development/Test ONLY)"
  Attendance.delete_all
  TeacherStudentRelationship.delete_all
  PrincipalTeacherRelationship.delete_all
  Homeroom.delete_all
  Student.delete_all
  User.delete_all
  Classroom.delete_all
  SchoolTier.delete_all
  School.delete_all
end

# Create Schools
school1 = School.create!(name: "Piti Academy", address: "123 Main St, Bangkok")
school2 = School.create!(name: "Kanat Kitty School", address: "456 Algorithm Rd, Nakhon Pathom")

# Create Classrooms
classroom1 = Classroom.create!(class_id: "5A", grade_level: 5, school_id: school1.id)
classroom2 = Classroom.create!(class_id: "6B", grade_level: 6, school_id: school2.id)
classroom3 = Classroom.create!(class_id: "6A", grade_level: 6, school_id: school1.id)

puts "✅ Classrooms Created"

# Create Admins
admin = User.create!(
  email_address: "admin@example.com",
  personal_email: "admin.personal@example.com",
  first_name: "Admin",
  last_name: "User",
  password: "password123",
  password_confirmation: "password123",
  role: "admin",
  approved: true,
  school_id: school1.id
)

# Create Principals
principal1 = User.create!(
  first_name: "Alice", last_name: "Johnson",
  personal_email: "alice.johnson@example.com",
  email_address: "alice.j@principal.schoolname.edu",
  password: "password123",
  role: "principal", school_id: school1.id, approved: true
)

principal2 = User.create!(
  first_name: "Bob", last_name: "Smith",
  personal_email: "bob.smith@example.com",
  email_address: "bob.s@principal.schoolname.edu",
  password: "password123",
  role: "principal", school_id: school2.id, approved: true
)

# Create Teachers
teacher1 = User.create!(
  first_name: "John", last_name: "Doe",
  personal_email: "john.doe@example.com",
  email_address: "john.d@teacher.schoolname.edu",
  password: "password123",
  role: "teacher", school_id: school1.id, approved: false
)

teacher2 = User.create!(
  first_name: "Jane", last_name: "Doe",
  personal_email: "jane.doe@example.com",
  email_address: "jane.d@teacher.schoolname.edu",
  password: "password123",
  role: "teacher", school_id: school2.id, approved: false
)

teacher3 = User.create!(
  first_name: "Mike", last_name: "Brown",
  personal_email: "mike.brown@example.com",
  email_address: "mike.b@teacher.schoolname.edu",
  password: "password123",
  role: "teacher", school_id: school2.id, approved: false
)

# 🎓 Create Student Users (Each Student **MUST** have a User record)
student1_user = User.create!(
  first_name: "Tyla", last_name: "Nojokes",
  personal_email: "student1@example.com",
  email_address: "student1@example.com",
  password: "randomPassword",
  role: "student", school_id: school1.id
)

student2_user = User.create!(
  first_name: "Mark", last_name: "Zuck",
  personal_email: "student2@example.com",
  email_address: "student2@example.com",
  password: "randomPassword",
  role: "student", school_id: school2.id
)

student3_user = User.create!(
  first_name: "Harry", last_name: "Singh",
  personal_email: "student3@example.com",
  email_address: "student3@example.com",
  password: "randomPassword",
  role: "student", school_id: school1.id
)

# 🎓 Create Student Records (Users must be created **first**)
student1 = Student.create!(
  name: "Tyla Nojokes",
  grade: 5,
  student_email_address: student1_user.email_address,
  parent_email_address: "parent1@example.com",
  classroom_id: classroom1.id
)

student2 = Student.create!(
  name: "Mark Zuck",
  grade: 6,
  student_email_address: student2_user.email_address,
  parent_email_address: "parent2@example.com",
  classroom_id: classroom2.id
)

student3 = Student.create!(
  name: "Harry Singh",
  grade: 6,
  student_email_address: student3_user.email_address,
  parent_email_address: "parent2@example.com",
  classroom_id: classroom3.id
)

puts "✅ Students Created"

# Assign Teachers to Homerooms
Homeroom.create!(teacher_id: teacher1.id, classroom_id: classroom1.id)
Homeroom.create!(teacher_id: teacher2.id, classroom_id: classroom2.id)
Homeroom.create!(teacher_id: teacher3.id, classroom_id: classroom3.id)

puts "✅ Homerooms Assigned"

# Create School Tiers
SchoolTier.create!(school_id: school1.id, tier: "Basic")
SchoolTier.create!(school_id: school2.id, tier: "Premium")

# Create Teacher-Student Relationships
TeacherStudentRelationship.create!(teacher_id: teacher1.id, student_id: student1_user.id)
TeacherStudentRelationship.create!(teacher_id: teacher2.id, student_id: student2_user.id)
TeacherStudentRelationship.create!(teacher_id: teacher3.id, student_id: student3_user.id)

# Create Principal-Teacher Relationships
PrincipalTeacherRelationship.create!(principal_id: principal1.id, teacher_id: teacher1.id)
PrincipalTeacherRelationship.create!(principal_id: principal2.id, teacher_id: teacher2.id)

puts "✅ Relationships Established"

# Create Attendance Records
Attendance.create!(student_id: student1.id, user_id: teacher1.id, timestamp: Time.current)
Attendance.create!(student_id: student2.id, user_id: teacher2.id, timestamp: Time.current)
Attendance.create!(student_id: student3.id, user_id: teacher3.id, timestamp: Time.current)

puts "✅ Attendance Records Created"
puts "✅ Seeding complete!"
