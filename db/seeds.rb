puts "Seeding data..."

# TODO: Add models

# Create Schools
school1 = School.create!(name: "Piti Academy", address: "123 Main St, Bangkok")
school2 = School.create!(name: "Kanat Kitty School", address: "456 Algorithm Rd, Nakhon Pathom")

# Create Classrooms
classroom1 = Classroom.create!(class_id: "5A", grade_level: 5)
classroom2 = Classroom.create!(class_id: "6B", grade_level: 6)

# Create Users (Principals, Teachers, Students, Parents)
principal1 = User.create!(email_address: "principal1@example.com", password: "password123", role: "principal", school_id: school1.id)
principal2 = User.create!(email_address: "principal2@example.com", password: "password123", role: "principal", school_id: school2.id)

teacher1 = User.create!(email_address: "teacher1@example.com", password: "password123", role: "teacher", school_id: school1.id)
teacher2 = User.create!(email_address: "teacher2@example.com", password: "password123", role: "teacher", school_id: school2.id)

student1 = User.create!(email_address: "student1@example.com", password: "password123", role: "student", school_id: school1.id)
student2 = User.create!(email_address: "student2@example.com", password: "password123", role: "student", school_id: school2.id)
student3 = User.create!(email_address: "student3@example.com", password: "password123", role: "student", school_id: school1.id)

# Assign Students to Classrooms
student1 = Student.create!(name: "Tyla Nojokes", grade: 5, student_email_address: "student1@example.com", parent_email_address: "parent1@example.com", classroom_id: classroom1.id)
student2 = Student.create!(name: "Mark Zuck", grade: 6, student_email_address: "student2@example.com", parent_email_address: "parent2@example.com", classroom_id: classroom2.id)

# Create Homerooms
Homeroom.create!(teacher_id: teacher1.id, classroom_id: classroom1.id)
Homeroom.create!(teacher_id: teacher2.id, classroom_id: classroom2.id)

# Create School Tiers
SchoolTier.create!(school_id: school1.id, tier: "Basic")
SchoolTier.create!(school_id: school2.id, tier: "Premium")

# Create Teacher-Student Relationships
TeacherStudentRelationship.create!(teacher_id: teacher1.id, student_id: student1.id)
TeacherStudentRelationship.create!(teacher_id: teacher2.id, student_id: student2.id)

# Create Principal-Teacher Relationships
PrincipalTeacherRelationship.create!(principal_id: principal1.id, teacher_id: teacher1.id)
PrincipalTeacherRelationship.create!(principal_id: principal2.id, teacher_id: teacher2.id)

# Create Attendance Records
Attendance.create!(student_id: student1.id, user_id: teacher1.id, timestamp: Time.current)
Attendance.create!(student_id: student2.id, user_id: teacher2.id, timestamp: Time.current)

puts "Seeding complete!"
