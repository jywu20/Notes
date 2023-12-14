using StaticTools
using StaticCompiler

struct StudentInfo 
    name::StaticString
    id::Cint
end

id(student::StudentInfo) = student.id

compile_shlib(id, (StudentInfo,))

# The following line is wrong: Julia functions only accept pointers to structs 
# It likely gives you some nonsense like 1461676824
@ccall "./id.so".id(StudentInfo(c"Lucas", 14)::StudentInfo)::Cint

# The following line is right
@ccall "./id.so".id(Ref(StudentInfo(c"Lucas", 14))::Ref{StudentInfo})::Cint