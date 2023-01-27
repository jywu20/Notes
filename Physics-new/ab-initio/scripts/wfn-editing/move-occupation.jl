using HDF5

n_electron = 120

fid = h5open("WFNo.h5", "r+") # Don't use "w"!!! 
occ = fid["mf_header/kpoints/occ"] |> read
occ_insulator = zeros(size(occ))
occ_insulator[1:n_electron, :, :] .= 1

# The [:, :, :] part is necessary, 
# or otherwise HDF5.jl will try to create another 
# dataset called "mf_header/kpoints/occ",
# and the operation just fails 
# because there is already one.
# The [:, :, :] expression, on the other hand, 
# calls setindex!, 
# which modifies the existing object (i.e. the dataset) 
# without creating a new one.
fid["mf_header/kpoints/occ"][:, :, :] = occ_insulator

ifmax = fid["mf_header/kpoints/ifmax"] |> read
ifmax_insulator = ones(size(ifmax)) * n_electron
fid["mf_header/kpoints/ifmax"][:, :] = ifmax_insulator 

close(fid)