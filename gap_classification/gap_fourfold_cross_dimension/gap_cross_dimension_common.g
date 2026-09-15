#############################################################################
## Shared helpers for cross-dimensional containment of fourfold families.
#############################################################################

if not IsBound(SearchEmbeddingStrict) then
    Read("../gap_functions.g");
fi;

SizeScreen([100000, 100000]);

CFCD_WriteAssignment := function(path, name, value)
    local stream;

    stream := OutputTextFile(path, false);
    if stream = fail then
        Error("Could not open output file ", path, ".");
    fi;
    SetPrintFormattingStatus(stream, false);
    AppendTo(stream, name, " := ", value, ";\n");
    CloseStream(stream);
end;


CFCD_PreprocessFamily := function(family)
    local info;

    info := PreprocessMatrixGroupStrict(
        family.generators,
        family.reportedOrder,
        family.linearGroupId
    );
    if not (IsBound(info.strict_ok) and info.strict_ok) then
        Error("Preprocessing failed for family ", family.number, ".");
    fi;
    if info.order <> family.reportedOrder then
        Error(
            "Computed order mismatch for family ", family.number,
            ": ", info.order, " versus ", family.reportedOrder, "."
        );
    fi;
    return info;
end;


CFCD_EnsureExplicitWitness := function(sourceInfo, targetInfo, result)
    local matrix;

    if result.ok <> true then
        return result;
    fi;
    if not IsBound(result.images) or result.images = fail then
        Error("A positive embedding has no image generators.");
    fi;
    if not IsBound(result.P) or result.P = fail then
        matrix := FindInvertibleIntertwiner(
            sourceInfo.gens,
            result.images
        );
        if matrix = fail or not VerifyConjugation(
            sourceInfo.gens,
            result.images,
            matrix,
            targetInfo.G
        ) then
            Error("A positive embedding has no recoverable conjugating matrix.");
        fi;
        result.P := matrix;
    fi;
    if IsZero(DeterminantMat(result.P)) or not ForAll(
        sourceInfo.gens,
        element -> result.P^-1 * element * result.P in targetInfo.G
    ) then
        Error("An explicit conjugating matrix failed verification.");
    fi;
    return result;
end;


CFCD_FindKnownEdge := function(edges, sourceNumber, targetNumber)
    return First(
        edges,
        edge -> edge.sourceNumber = sourceNumber
                and edge.targetNumber = targetNumber
    );
end;


CFCD_VerifyWitness := function(generators, targetGroup, matrix)
    local inverse;
    if matrix = fail or IsZero(DeterminantMat(matrix)) then
        return false;
    fi;
    inverse := matrix^-1;
    return ForAll(generators, element -> inverse * element * matrix in targetGroup);
end;
