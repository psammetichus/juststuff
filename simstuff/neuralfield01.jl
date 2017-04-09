function f(A::Float64, ω::Float64, φ::Float64, t::Float64)
  return A*exp(im*ωt+φ)


function rbasis(char_r::Float64, damp::Float64)
  return (x,y) -> char_r*norm(x,y)^(-damp)


