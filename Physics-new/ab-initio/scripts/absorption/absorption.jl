# Auxiliaries for `absorption` of BerkeleyGW 

function read_absorption(path::AbstractString)
    absorption_data   = readdlm(path,   skipstart = 4)
    absorption_energies   = absorption_data[:, 1]
    absorption_values     = absorption_data[:, 2]
    (absorption_energies, absorption_values)
end
