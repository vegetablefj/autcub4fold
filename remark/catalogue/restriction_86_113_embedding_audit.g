#############################################################################
## Independent abstract-group audit of the strict No. 86/113 -> No. 62
## witnesses. This script writes no files and does not use the OSCAR cache.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict86113AuditOmega := E(3)*IdentityMat(6);
Restrict86113AuditScalars := Group([Restrict86113AuditOmega]);
Restrict86113AuditParent := Group(Families[62].generators);
Restrict86113AuditParentKernel := Group(Filtered(
    Elements(Restrict86113AuditParent),g -> DeterminantMat(g) = 1));
if Size(Restrict86113AuditParent) <> 216
   or IdGroup(Restrict86113AuditParent) <> [216,139]
   or IdGroup(FactorGroup(Restrict86113AuditParent,
                        Restrict86113AuditScalars)) <> [72,30]
   or Size(Restrict86113AuditParentKernel) <> 36
   or IdGroup(FactorGroup(Restrict86113AuditParentKernel,
                        Restrict86113AuditScalars)) <> [12,4] then
    Error("No. 62 full/projective/symplectic abstract data changed");
fi;

Restrict86113AuditOne := function(number,projectiveId,kernelId,index)
    local child,source,edges,edge,image,kernel,imageKernel,
          projectedParent,projectedImage;
    child := Families[number];
    source := Group(child.generators);
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = number and r.targetNumber = 62
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then Error("Strict edge not unique"); fi;
    edge := edges[1];
    image := Group(List(child.generators,h -> edge.P^-1*h*edge.P));
    if not IsSubgroup(Restrict86113AuditParent,image)
       or IdGroup(FactorGroup(source,
                             Restrict86113AuditScalars)) <> projectiveId then
        Error("Child projective group or strict image changed");
    fi;
    kernel := Group(Filtered(Elements(source),g -> DeterminantMat(g) = 1));
    imageKernel := Group(List(GeneratorsOfGroup(kernel),
        h -> edge.P^-1*h*edge.P));
    if Size(kernel) <> 54/index
       or IdGroup(FactorGroup(kernel,
                            Restrict86113AuditScalars)) <> kernelId
       or not IsSubgroup(Restrict86113AuditParentKernel,imageKernel) then
        Error("Symplectic part or its parent embedding changed");
    fi;
    projectedParent := NaturalHomomorphismByNormalSubgroup(
        Restrict86113AuditParent,Restrict86113AuditScalars);
    projectedImage := Image(projectedParent,image);
    if Size(projectedImage) <> 18
       or IdGroup(projectedImage) <> projectiveId then
        Error("Projectivized strict image changed");
    fi;
    Print("No. ",number," -> No. 62: linear=",IdGroup(source),
        ", projective=",IdGroup(projectedImage),
        ", symplectic projective=",
        IdGroup(FactorGroup(kernel,Restrict86113AuditScalars)),
        ", index=",index,"; strict image and symplectic image verified\n");
end;

Restrict86113AuditOne(86,[18,3],[6,1],3);
Restrict86113AuditOne(113,[18,5],[3,1],6);
