#############################################################################
## Exact cubic-basis and family-dimension checks for the numbered catalogues.
## Run from the repository root or this module directory.
## No group enumeration, embedding, saturation, or coordinate search is run.
#############################################################################

if IsExistingFile("gap_classification/gap_functions.g") then
    CF_CB_Root := "";
elif IsExistingFile("../gap_functions.g") then
    CF_CB_Root := "../../";
else
    Error("Run from the repository root or gap_manuscript_validation.");
fi;
CF_CB_Module := Concatenation(CF_CB_Root,
    "gap_classification/gap_manuscript_validation/");
CF_CB_Threefold := Concatenation(CF_CB_Root,
    "gap_classification/gap_threefold/");
CF_CB_Output := Concatenation(CF_CB_Module, "gap_display_basis_audit.out");
CF_CB_Log := Concatenation(CF_CB_Module, "gap_display_basis_audit.log");
Read(Concatenation(CF_CB_Root, "gap_classification/gap_functions.g"));
Read(Concatenation(CF_CB_Module, "gap_validation_functions.g"));
Read(Concatenation(CF_CB_Module, "gap_family_catalogue.g"));
Read(Concatenation(CF_CB_Module, "gap_manuscript_input.g"));
Read(Concatenation(CF_CB_Threefold, "result/gap_threefold_families.g"));
Read(Concatenation(CF_CB_Threefold, "input/gap_threefold_display_input.g"));

CF_CB_Independent := function(basis)
    return Length(basis) = 0 or RankMat(basis) = Length(basis);
end;

## The stored and fresh exponent orders need not agree.
CF_CB_Reindex := function(basis, oldExponents, exponents)
    local positions;
    if Length(Set(oldExponents)) <> Length(oldExponents)
       or Set(oldExponents) <> Set(exponents)
       or not ForAll(basis, row -> Length(row) = Length(oldExponents)) then
        Error("A saved coefficient basis has invalid exponent coordinates.");
    fi;
    positions := List(exponents, e -> Position(oldExponents, e));
    return List(basis, row -> row{positions});
end;

CF_CB_RecordCheck := function(row, label, passed)
    row.(label) := passed;
    if not passed then Add(row.failedChecks, label); fi;
end;

CF_CB_CheckBasis := function(generators, basis, n)
    local invariants, centralizer, exponents;
    exponents := CF_DegreeThreeExponentVectors(n);
    invariants := CF_CubicInvariantBasis(generators,
        rec(ambientDimension := n, buildPolynomialObjects := false,
            buildStrings := false));
    centralizer := CF_CentralizerAlgebraBasis(generators, false, n);
    return rec(independent := CF_CB_Independent(basis),
        strictlyInvariant := ForAll(generators,
            g -> CF_MV_TransformVectors(basis, g, exponents) = basis),
        complete := CF_MV_SameSpan(basis, invariants.coefficientBasis),
        dimensionW := invariants.invariantDimension,
        dimensionC := centralizer.dimension,
        familyDimension := invariants.invariantDimension - centralizer.dimension,
        freshBasis := invariants.coefficientBasis);
end;

CF_CB_Write := function(audit)
    local stream;
    stream := OutputTextFile(CF_CB_Output, false);
    SetPrintFormattingStatus(stream, false);
    PrintTo(stream, "DisplayBasisAudit := ", audit, ";\n");
    CloseStream(stream);
end;

CF_CB_Run := function()
    local started, log, audit, n, catalogue, inputs, family, input, row,
          basis, fresh, exponents, displayed, component, componentAudit,
          componentCache, cached, generators, index;
    started := Runtime();
    if Length(CubicFourfoldFamilyCatalogue) <> 156
       or List(CubicFourfoldFamilyCatalogue, r -> r.number) <> [1 .. 156]
       or Length(ManuscriptValidationInput) <> 156
       or List(ManuscriptValidationInput, r -> r.number) <> [1 .. 156]
       or Length(CubicThreefoldFamilyCatalogue) <> 40
       or List(CubicThreefoldFamilyCatalogue, r -> r.number) <> [1 .. 40]
       or Length(ThreefoldManuscriptInput) <> 40
       or List(ThreefoldManuscriptInput, r -> r.number) <> [1 .. 40] then
        Error("Expected consecutively numbered current 156/40 catalogues/inputs.");
    fi;
    audit := rec(status := "running", gapVersion := GAPInfo.Version,
        fourfoldSource := ManuscriptValidationSource,
        threefoldSource := ThreefoldManuscriptSource,
        fourfoldRows := [], threefoldRows := [],
        componentChecksComputed := 0, componentChecksReused := 0);
    componentCache := [];
    log := OutputTextFile(CF_CB_Log, false);
    SetPrintFormattingStatus(log, false);
    AppendTo(log, "Current 156/40 basis replay; GAP ", GAPInfo.Version, "\n");
    CloseStream(log);
    CF_CB_Write(audit);
    for n in [6, 5] do
        if n = 6 then
            catalogue := CubicFourfoldFamilyCatalogue;
            inputs := ManuscriptValidationInput;
        else
            catalogue := CubicThreefoldFamilyCatalogue;
            inputs := ThreefoldManuscriptInput;
        fi;
        exponents := CF_DegreeThreeExponentVectors(n);
        for index in [1 .. Length(catalogue)] do
            family := catalogue[index];
            input := inputs[index];
            Print(n, " variables, row ", index, "/", Length(catalogue),
                ": started; elapsed ", Runtime() - started, " ms\n");
            AppendTo(CF_CB_Log, n, " variables, row ", index, "/",
                Length(catalogue), ": started; elapsed ",
                Runtime() - started, " ms\n");
            generators := family.matrixGenerators;
            basis := CF_CB_Reindex(family.coefficientBasis,
                family.cubicExponents, exponents);
            fresh := CF_CB_CheckBasis(generators, basis, n);
            row := rec(number := index, sourceLine := input.sourceLine,
                failedChecks := [], storedBasisCount := Length(basis),
                freshDimensionW := fresh.dimensionW,
                freshDimensionC := fresh.dimensionC,
                freshFamilyDimension := fresh.familyDimension,
                displayedBasisChecked := input.displayedBasis <> fail,
                componentBasisChecked := false);
            CF_CB_RecordCheck(row, "extractionPassed", input.errors = []);
            if n = 5 then
                CF_CB_RecordCheck(row, "displayedGeneratorsMatched",
                    input.displayedGenerators = generators);
                CF_CB_RecordCheck(row, "explicitScalarMatched",
                    E(3)*IdentityMat(5) in input.displayedGenerators);
            elif input.extraGenerator <> fail then
                CF_CB_RecordCheck(row, "displayedExtraGeneratorMatched",
                    input.extraGenerator = family.extraGenerator);
            fi;
            CF_CB_RecordCheck(row, "storedBasisIndependent", fresh.independent);
            CF_CB_RecordCheck(row, "storedBasisStrictlyInvariant",
                fresh.strictlyInvariant);
            CF_CB_RecordCheck(row, "storedBasisComplete", fresh.complete);
            CF_CB_RecordCheck(row, "storedBasisNonempty", Length(basis) > 0);
            CF_CB_RecordCheck(row, "storedInvariantDimensionMatched",
                fresh.dimensionW = family.invariantDimension);
            CF_CB_RecordCheck(row, "storedCentralizerDimensionMatched",
                fresh.dimensionC = family.centralizerDimension);
            CF_CB_RecordCheck(row, "storedFamilyDimensionMatched",
                fresh.familyDimension = family.familyDimension);
            if n = 6 then
                CF_CB_RecordCheck(row, "currentTableDimensionMatched",
                    fresh.familyDimension = input.table.familyDimension);
            else
                CF_CB_RecordCheck(row, "currentTableInvariantDimensionMatched",
                    fresh.dimensionW = input.invariantDimension);
                CF_CB_RecordCheck(row, "currentTableCentralizerDimensionMatched",
                    fresh.dimensionC = input.centralizerDimension);
                CF_CB_RecordCheck(row, "currentTableFamilyDimensionMatched",
                    fresh.familyDimension = input.familyDimension);
            fi;
            if row.displayedBasisChecked then
                displayed := List(input.displayedBasis,
                    terms -> CF_MV_SparseVector(terms, exponents));
                row.displayedBasisCount := Length(displayed);
                CF_CB_RecordCheck(row, "displayedBasisIndependent",
                    CF_CB_Independent(displayed));
                CF_CB_RecordCheck(row, "displayedBasisMatchesStoredSpan",
                    CF_MV_SameSpan(displayed, basis));
                CF_CB_RecordCheck(row, "displayedBasisStrictlyInvariant",
                    ForAll(generators, g ->
                        CF_MV_TransformVectors(displayed, g, exponents) = displayed));
            fi;
            if n = 6 and input.componentBasis <> fail then
                if IsBound(family.symplecticGenerators) then
                    component := List(input.componentBasis,
                        terms -> CF_MV_SparseVector(terms, exponents));
                    cached := First(componentCache, c ->
                        c.generators = family.symplecticGenerators
                        and c.basis = component);
                    if cached = fail then
                        componentAudit := CF_CB_CheckBasis(
                            family.symplecticGenerators, component, n);
                        Unbind(componentAudit.freshBasis);
                        Add(componentCache, rec(
                            generators := family.symplecticGenerators,
                            basis := component, audit := componentAudit));
                        audit.componentChecksComputed :=
                            audit.componentChecksComputed + 1;
                    else
                        componentAudit := cached.audit;
                        audit.componentChecksReused :=
                            audit.componentChecksReused + 1;
                    fi;
                    row.componentBasisChecked := true;
                    row.componentNumber := input.componentNumber;
                    row.componentBasisCount := Length(component);
                    row.componentFreshDimensionW := componentAudit.dimensionW;
                    CF_CB_RecordCheck(row, "componentBasisIndependent",
                        componentAudit.independent);
                    CF_CB_RecordCheck(row, "componentBasisStrictlyInvariant",
                        componentAudit.strictlyInvariant);
                    CF_CB_RecordCheck(row, "componentBasisComplete",
                        componentAudit.complete);
                else
                    row.componentSkipReason :=
                        "No symplectic matrix group in the final coordinates.";
                fi;
            fi;
            row.passed := row.failedChecks = [];
            if n = 6 then Add(audit.fourfoldRows, row);
            else Add(audit.threefoldRows, row); fi;
            audit.runtimeMilliseconds := Runtime() - started;
            CF_CB_Write(audit);
            Print(n, " variables, row ", index, ": passed = ", row.passed,
                "; dim W = ", row.freshDimensionW, "; dim C = ",
                row.freshDimensionC, "; m = ", row.freshFamilyDimension,
                "; failed checks = ", row.failedChecks, "\n");
            AppendTo(CF_CB_Log, n, " variables, row ", index,
                ": passed = ", row.passed, "; dim W = ",
                row.freshDimensionW, "; dim C = ", row.freshDimensionC,
                "; m = ", row.freshFamilyDimension,
                "; failed checks = ", row.failedChecks, "\n");
        od;
    od;
    audit.status := "completed";
    audit.fourfoldFailures := List(Filtered(audit.fourfoldRows,
        r -> not r.passed), r -> r.number);
    audit.threefoldFailures := List(Filtered(audit.threefoldRows,
        r -> not r.passed), r -> r.number);
    audit.runtimeMilliseconds := Runtime() - started;
    CF_CB_Write(audit);
    Print("Completed: fourfold failures = ", audit.fourfoldFailures,
        "; threefold failures = ", audit.threefoldFailures,
        "; runtime = ", audit.runtimeMilliseconds, " ms\n");
    AppendTo(CF_CB_Log, "Completed: fourfold failures = ",
        audit.fourfoldFailures, "; threefold failures = ",
        audit.threefoldFailures, "; runtime = ",
        audit.runtimeMilliseconds, " ms\n");
    return audit;
end;

DisplayBasisAudit := CF_CB_Run();
if DisplayBasisAudit.fourfoldFailures = []
   and DisplayBasisAudit.threefoldFailures = [] then
    Print("DISPLAY_BASIS_AUDIT_SUCCESS\n");
    AppendTo(CF_CB_Log, "DISPLAY_BASIS_AUDIT_SUCCESS\n");
    QUIT_GAP(0);
else
    Print("DISPLAY_BASIS_AUDIT_FAILED\n");
    AppendTo(CF_CB_Log, "DISPLAY_BASIS_AUDIT_FAILED\n");
    QUIT_GAP(1);
fi;
