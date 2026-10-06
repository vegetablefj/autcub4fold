# Restriction from a cyclic full lattice action with trivial symplectic part.
# This file only defines functions.  It neither loads catalogue data nor
# launches a search.  Call `using Oscar` before including it.

"""
    restrict_cyclic_power(g::ZZLatWithIsom, m::Integer)

Let `g` be the saved full action of a cyclic maximal family on the cubic-
fourfold primitive lattice `Lambda0`, and assume its symplectic part is
trivial.  For a positive divisor `m` of the order `n` of `g`, construct the
action of `g^(n/m)` and return the same ambient lattice fields as one result
of the ambient-lattice catalogue's OSCAR calculation.

The caller must already know that `g` is the *geometric* full action and that
its period character has order `n`.  These hypotheses cannot be recovered
from a bare lattice isometry.  Under them the power has trivial symplectic
part, so `S = 0` and `T = Lambda0`.  This function checks the lattice rank,
signature, discriminant, exact order, and period signature, but does not
prove geometric realizability or identify a row of the 156-family table.

`number_of_data` and `group_gap_id` are deliberately absent: taking a power
is not a new enumeration, and the extra generator alone does not certify a
projective group identifier.
"""
function restrict_cyclic_power(g::ZZLatWithIsom, m::Integer)
    m > 0 || throw(ArgumentError("The subgroup order must be positive"))

    n = Int(order_of_isometry(g))
    target_order = Int(m)
    n % target_order == 0 || throw(ArgumentError("The subgroup order must divide the source order"))

    Lambda0 = lattice(g)
    rank(Lambda0) == 22 || throw(ArgumentError("Expected the rank-22 cubic-fourfold primitive lattice"))
    signature_tuple(Lambda0) == (20, 0, 2) ||
        throw(ArgumentError("The ambient lattice must have signature (20,2)"))
    abs(QQ(discriminant(Lambda0))) == 3 ||
        throw(ArgumentError("The ambient lattice must have absolute discriminant 3"))

    exponent = div(n, target_order)
    power_action = isometry(g)^exponent
    Lf = integer_lattice_with_isometry(
        Lambda0, power_action; ambient_representation=false, check=true,
    )
    Int(order_of_isometry(Lf)) == target_order ||
        throw(ArgumentError("The power does not have the requested exact order"))

    # The symplectic part is trivial by hypothesis.  Form the zero lattice
    # inside the same ambient space rather than an unrelated rank-zero model.
    S = orthogonal_submodule(Lambda0, basis_matrix(Lambda0))
    rank(S) == 0 || throw(ArgumentError("Failed to construct the zero coinvariant lattice"))
    Sf = integer_lattice_with_isometry(
        S, identity_matrix(QQ, 0); ambient_representation=false, check=true,
    )
    Tf = Lf

    Pf = kernel_lattice(Tf, target_order)
    P = lattice(Pf)
    psig = signature_tuple(P)
    (psig[2] == 0 && psig[3] == 2) ||
        throw(ArgumentError("The Phi_m-kernel has no period plane of negative rank two"))
    K = orthogonal_submodule(Lambda0, basis_matrix(P))
    rank(K) + rank(P) == rank(Lambda0) ||
        throw(ArgumentError("The period kernel and its complement have inconsistent ranks"))

    phi = Int(euler_phi(target_order))
    rank(P) % phi == 0 ||
        throw(ArgumentError("The Phi_m-kernel rank is not divisible by phi(m)"))
    dimension = div(rank(P), phi) - (target_order <= 2 ? 2 : 1)
    dimension >= 0 || throw(ArgumentError("The computed period dimension is negative"))

    return (
        order=target_order,
        dimension=dimension,
        S_in_Lambda0=Sf,
        T_in_Lambda0=Tf,
        T_action=Tf,
        K_in_Lambda0=K,
        P_in_Lambda0=P,
        P_action=Pf,
        Lambda0=Lf,
        source_order=n,
        power_exponent=exponent,
    )
end
