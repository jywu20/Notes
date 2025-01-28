Base.@ccallable function mat_mul_naive!(A::Matrix{Float64}, B::Matrix{Float64}, C::Matrix{Float64})::Nothing
    if size(C)[1] != size(A)[1] || size(C)[2] != size(B)[2] || size(A)[2] != size(B)[1]
        throw("Matrix sizes inconsistent.")
    end
    for i in 1 : size(C)[1]
        for k in 1 : size(C)[2]
            C[i, k] = 0
            for j in 1 : size(A)[2]
                C[i, k] += A[i, j] * B[j, k]
            end
        end
    end
end
