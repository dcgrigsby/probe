### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 1c7a0e39-17e6-4d58-a819-7cd766f696af
begin
	using PlutoUI
	using Unitful
	using Unitful.DefaultSymbols
	using Latexify
	using UnitfulLatexify
end

# ╔═╡ c984858e-7804-4d76-a031-5c0f8d23296a
md"""
Solar wind pressure equation [ref](https://en.wikipedia.org/wiki/Solar_wind#Pressure)

``Pa = m_p \cdot n \cdot V^2``
"""

# ╔═╡ f531b056-664e-4f26-8a63-1b8788a717dd
function _Pa(mp, n, V)	
	mp = mp |> u"kg"
	n  = n  |> u"cm^-3"
	V  = V  |> u"km/s"
	
	return (ustrip(mp) * ustrip(n) * ustrip(V^2))u"nPa"  
end;

# ╔═╡ 3aafcd09-3b4c-4344-8345-d29b379dffd6
md"""
Proton mass, $1.6×10^{−27} kg$ ([ref](https://en.wikipedia.org/wiki/Proton)), is a built Unitful.jl unit 
"""

# ╔═╡ d02bbb5e-2128-4ad6-82a0-c4c2fbf067e8
mp = 1u"mp"

# ╔═╡ 37b6074b-8eb4-4a64-a8ab-cb0910055e39
md"""
Average solar wind density at 1AU ([ref](https://www.sciencedirect.com/topics/earth-and-planetary-sciences/solar-wind))
"""

# ╔═╡ ed143819-d9cc-4254-8785-1d19c912c00a
n = 7.0u"cm^-3"  

# ╔═╡ 05b7cf22-68a9-4f0a-8666-c9dd835da0db
md"""
Average solar wind velocity at 1AU ([ref](https://www.sciencedirect.com/topics/earth-and-planetary-sciences/solar-wind))
"""

# ╔═╡ 6d6db7b3-1707-4a82-aba6-011b7c454126
V = 450.0u"km/s"

# ╔═╡ 581fc5b5-6430-4fd8-96ce-84c7e4d48913
md"""
Solar wind pressure at 1AU
"""

# ╔═╡ 08f6d585-c25f-43f6-ac66-7351a9af550c
Pa = _Pa(mp, n, V)

# ╔═╡ 4afa79c1-2c0d-4847-99e0-84a013079ece
md"""
Sail area in square meters

$(@bind _sailarea Slider(1:100, show_value=true))
"""

# ╔═╡ 6d2cb0ab-bf2f-47cb-bbe3-7b3a1e0624b7
md"""
Force equation [ref](https://en.wikipedia.org/wiki/Pascal_(unit))


``N = Pa \cdot m^2``
"""

# ╔═╡ 42f797d1-6f33-499d-8b51-153be3c82c5b
function _NPamm(Pa, m) 
	Pa = Pa |> u"Pa"
	m  = m  |> u"m^2"
	
	return Pa * m |> u"N";
end;

# ╔═╡ da60a3c8-0aef-490d-b336-7e69e8268238
md"""
Energy equation for a photon [ref](http://umdberg.pbworks.com/w/page/50455623/Momentum%20of%20a%20laser%20beam)


``E = \frac{hc}{\lambda}``
"""

# ╔═╡ 102c04ea-41cb-43fc-b0b9-1f8fdf86c9d7
function _E(λ)
	λ = λ |> u"m"
	
	return (ustrip(Unitful.h) * ustrip(Unitful.c0) / ustrip(λ))u"J"
end;

# ╔═╡ a7380f94-85ca-41ae-9ba6-b86aab47c4a2
md"""
Fiber laser wavelength [ref](https://www.laserfocusworld.com/test-measurement/spectroscopy/article/16549567/fiber-lasers-fiber-lasers-the-state-of-the-art)
"""

# ╔═╡ f8453eac-405b-49c5-b9bf-303995b451fd
laserwavelength = 780u"nm"

# ╔═╡ f2308cfa-b136-4fe5-9132-da150580d70e
md"""
Energy per photon at $(laserwavelength)
"""

# ╔═╡ a08df075-a26c-4084-b92a-42b0b0b430f7
E = _E(laserwavelength)

# ╔═╡ 491777f7-1e48-4420-862b-04b63fb7cde9
md"""
Momentum equation for a photon [ref](http://umdberg.pbworks.com/w/page/50455623/Momentum%20of%20a%20laser%20beam)


``p =  \frac{h}{\lambda}``
"""

# ╔═╡ 01d5b674-4b50-48a9-8d74-ba5112b15320
function _p(λ)
	λ = λ |> u"m"
	
	return (ustrip(Unitful.h) / ustrip(λ))u"kg*m/s"
end;

# ╔═╡ 00d3f8da-32de-49cc-96a2-58ca7e4cb3a7
md"""
Momentum per photon at $(laserwavelength)
"""

# ╔═╡ cd21af09-8f1e-482e-a363-024d479e585d
p = _p(laserwavelength)

# ╔═╡ 0af947e7-94ff-4d19-8b68-73405bf58c40
md"""
Laser power in Watts

$(@bind _watts Slider(100:1000, show_value=true))
"""

# ╔═╡ 067cf6b0-090f-4b2c-b0c9-419da9f1ccbb
md"""
Photons per second per watt equation [ref](http://umdberg.pbworks.com/w/page/50455623/Momentum%20of%20a%20laser%20beam)


``\gamma =  \frac{W}{E}``

"""

# ╔═╡ 8b82d5d3-e82d-46e9-b049-8f4984c11dba
function _γ(W, E) 
	W = W |> u"W"
	E = E |> u"J"
	return ustrip(W)/ustrip(E);
end;

# ╔═╡ 69530c5e-0f90-4213-bb4c-01d605c955a4
md"""
Force equation [ref](http://umdberg.pbworks.com/w/page/50455623/Momentum%20of%20a%20laser%20beam)

``N = γ \cdot p``
"""

# ╔═╡ 512047fe-e489-4be8-be40-8b23bc1709cd
function _Nγp(γ, p)
	p = p |> u"kg*m/s"
	
	return (γ * ustrip(p))u"N";
end;

# ╔═╡ 7008c071-fe83-43aa-adff-60a1909d9a7e
# create a variable with units from the _watts slider
watts = _watts * 1u"W";

# ╔═╡ 1ca59cec-50ac-4692-b855-b9449538304a
md"""
Photons per second at $(watts) 
"""

# ╔═╡ 0d4993ae-64a6-4758-ba28-df08f314d5e9
γ = _γ(watts, E)

# ╔═╡ e6a069ad-92a0-4892-a2c7-1b961ea58160
laserN = _Nγp(γ, p)

# ╔═╡ 62c8b3b2-2d80-48e0-835d-e58b966879f4
md"""
Thrust from a $(watts) laser
"""

# ╔═╡ 534d84a6-f441-426e-972a-2e38019dddd4
# create a variable with units from the _sailarea slider
sailarea = _sailarea * 1u"m^2";

# ╔═╡ b9996f49-9c18-46a0-8bcb-ca7cd9e46605
md"""
Thrust from the solar wind at 1AU on a $(sailarea) sail
"""

# ╔═╡ e77312cf-8972-4c04-b52c-8f75e7808d67
sailN = _NPamm(Pa, sailarea)

# ╔═╡ 0c4a6c2b-73ea-41f8-ac0a-88a460294539
laserN/sailN

# ╔═╡ 723923e2-6bb6-43fc-8575-70be1b54711f
md"""
Laser thrust multiplier vs. $(sailarea) sail
"""

# ╔═╡ Cell order:
# ╟─c984858e-7804-4d76-a031-5c0f8d23296a
# ╠═f531b056-664e-4f26-8a63-1b8788a717dd
# ╟─3aafcd09-3b4c-4344-8345-d29b379dffd6
# ╟─d02bbb5e-2128-4ad6-82a0-c4c2fbf067e8
# ╟─37b6074b-8eb4-4a64-a8ab-cb0910055e39
# ╟─ed143819-d9cc-4254-8785-1d19c912c00a
# ╟─05b7cf22-68a9-4f0a-8666-c9dd835da0db
# ╟─6d6db7b3-1707-4a82-aba6-011b7c454126
# ╟─581fc5b5-6430-4fd8-96ce-84c7e4d48913
# ╠═08f6d585-c25f-43f6-ac66-7351a9af550c
# ╟─4afa79c1-2c0d-4847-99e0-84a013079ece
# ╟─6d2cb0ab-bf2f-47cb-bbe3-7b3a1e0624b7
# ╠═42f797d1-6f33-499d-8b51-153be3c82c5b
# ╟─b9996f49-9c18-46a0-8bcb-ca7cd9e46605
# ╠═e77312cf-8972-4c04-b52c-8f75e7808d67
# ╟─da60a3c8-0aef-490d-b336-7e69e8268238
# ╠═102c04ea-41cb-43fc-b0b9-1f8fdf86c9d7
# ╟─a7380f94-85ca-41ae-9ba6-b86aab47c4a2
# ╠═f8453eac-405b-49c5-b9bf-303995b451fd
# ╟─f2308cfa-b136-4fe5-9132-da150580d70e
# ╠═a08df075-a26c-4084-b92a-42b0b0b430f7
# ╟─491777f7-1e48-4420-862b-04b63fb7cde9
# ╠═01d5b674-4b50-48a9-8d74-ba5112b15320
# ╟─00d3f8da-32de-49cc-96a2-58ca7e4cb3a7
# ╠═cd21af09-8f1e-482e-a363-024d479e585d
# ╟─0af947e7-94ff-4d19-8b68-73405bf58c40
# ╟─067cf6b0-090f-4b2c-b0c9-419da9f1ccbb
# ╠═8b82d5d3-e82d-46e9-b049-8f4984c11dba
# ╟─1ca59cec-50ac-4692-b855-b9449538304a
# ╠═0d4993ae-64a6-4758-ba28-df08f314d5e9
# ╟─69530c5e-0f90-4213-bb4c-01d605c955a4
# ╠═512047fe-e489-4be8-be40-8b23bc1709cd
# ╟─62c8b3b2-2d80-48e0-835d-e58b966879f4
# ╠═e6a069ad-92a0-4892-a2c7-1b961ea58160
# ╟─723923e2-6bb6-43fc-8575-70be1b54711f
# ╠═0c4a6c2b-73ea-41f8-ac0a-88a460294539
# ╟─7008c071-fe83-43aa-adff-60a1909d9a7e
# ╟─534d84a6-f441-426e-972a-2e38019dddd4
# ╟─1c7a0e39-17e6-4d58-a819-7cd766f696af
