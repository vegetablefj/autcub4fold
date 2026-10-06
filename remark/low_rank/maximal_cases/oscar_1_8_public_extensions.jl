# Thin OSCAR 1.8 adapter for the fixed-action cubic-fourfold checks.
#
# OSCAR 1.8 contains the public primitive-extension fix corresponding to the
# 1.7-only issue-6071 workaround in ../../../oscar/oscar_script.jl.  Keep this
# adapter local so the recorded 1.7 workflow and its saved objects are not
# changed.

const required_oscar_line = (v"1.8.0", v"1.9.0")
required_oscar_line[1] <= pkgversion(Oscar) < required_oscar_line[2] ||
    error("This adapter requires OSCAR 1.8.x")

function public_equivariant_extensions_stable_discriminant_18(
    S::ZZLat,
    Tf::ZZLatWithIsom,
)
    T = lattice(Tf)
    glue_order = glue_order_to_disc3(S, T)

    ok, extensions = equivariant_primitive_extensions(
        S,
        Tf;
        glue_order = [glue_order],
        even = true,
        classification = :subsub,
        compute_bar_Gf = false,
        first_fitting_isometry = true,
    )
    ok || return []

    good = []
    for (Lf, Simg, Timg) in extensions
        @req rank(lattice(Simg)) == rank(S) "First image is not the S-side"
        @req rank(lattice(Timg)) == rank(T) "Second image is not the T-side"
        @req absdisc_int(lattice(Simg)) == absdisc_int(S) "First image has the wrong discriminant"
        @req absdisc_int(lattice(Timg)) == absdisc_int(T) "Second image has the wrong discriminant"

        keep_first_fitting_extension(S, T, Lf) || continue
        push!(good, (Lf, Simg, Timg))
    end
    return good
end

function lattice_data_for_T_action_public_18(
    S::ZZLat,
    Tf::ZZLatWithIsom,
    m::Int;
    ordS = nothing,
    k_order_cache = nothing,
)
    data = []
    extensions = public_equivariant_extensions_stable_discriminant_18(S, Tf)

    for (Lf, Simg, Timg) in extensions
        test = lattice_data_after_root_and_symplectic_tests(
            S,
            Lf,
            Simg,
            Timg,
            m;
            ordS = ordS,
            k_order_cache = k_order_cache,
        )
        test.ok || continue

        Lf_st, Simg_st, Timg_st = refine_surviving_fitting_extension(
            Lf,
            Simg,
            Timg,
        )

        if Lf_st === Lf
            P_f = test.P_with_isometry
            P = test.P_lattice
            K = test.K_lattice
        else
            pk_st = embedded_PK_data(Lf_st, Timg_st, m)
            P_f = pk_st.P_with_isometry
            P = pk_st.P_lattice
            K = pk_st.K_lattice

            @req rank(P) == rank(test.P_lattice) "The rank of P changed during refinement"
            @req rank(K) == rank(test.K_lattice) "The rank of K changed during refinement"
            @req period_dimension(P, m) == period_dimension(test.P_lattice, m) "The period dimension changed during refinement"
        end

        push!(
            data,
            (
                order = m,
                dimension = period_dimension(P, m),
                S_in_Lambda0 = Simg_st,
                T_in_Lambda0 = Timg_st,
                T_action = Tf,
                K_in_Lambda0 = K,
                P_in_Lambda0 = P,
                P_action = P_f,
                Lambda0 = Lf_st,
            ),
        )
    end
    return data
end
