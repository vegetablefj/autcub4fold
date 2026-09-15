FreshSaturationChecks:=[];;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job01_nonliftable_f1",
status := "no_embedding",
target := "known_8" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job01_nonliftable_f1",
status := "no_embedding",
target := "known_24" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job01_nonliftable_f1",
status := "no_embedding",
target := "known_4" ));;
Add(FreshSaturationChecks,rec(
method := "A_strict",
ok := false,
reason := "exhausted_no_verified_candidate",
source := "job01_nonliftable_f1",
status := "no_embedding",
target := "known_1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job02_nonliftable_f1",
status := "no_embedding",
target := "job03_liftable_f10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job02_nonliftable_f1",
status := "no_embedding",
target := "known_11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job04_liftable_f1",
status := "no_embedding",
target := "known_10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job04_liftable_f1",
status := "no_embedding",
target := "job05_liftable_f5" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job04_liftable_f1",
status := "no_embedding",
target := "known_11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job05_liftable_f1",
status := "no_embedding",
target := "known_5" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job05_liftable_f1",
status := "no_embedding",
target := "known_6" ));;
Add(FreshSaturationChecks,rec(
P := [ [ 2, -2, 0, 3, 0, 0 ], [ 2, -2, 0, 0, 0, 3 ], [ 2, -2, -3, -3, -3, -3 ], [ 2, -2, 0, 0, 3, 0 ], [ 2, -2, 3, 0, 0, 0 ], [ -1, -2, 0, 0, 0, 0 ] ],
images := [ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ], [ 0, 0, -E(3)^2, -E(3)^2, -E(3)^2, -E(3)^2 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ] ], [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ] ],
method := "A_strict",
ok := true,
reason := "found",
source := "job05_liftable_f1",
status := "embedded",
target := "known_8" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job05_liftable_f5",
status := "no_embedding",
target := "known_11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job06_liftable_f11",
status := "no_embedding",
target := "job03_liftable_f10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job06_liftable_f11",
status := "no_embedding",
target := "known_9" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job06_liftable_f11",
status := "no_embedding",
target := "known_22" ));;
Add(FreshSaturationChecks,rec(
blockCertificate := rec(
Q := [ [ 1, 0, 0, 0, E(3)^2, E(3) ], [ 1, 0, 0, 0, E(3), E(3)^2 ], [ 1, 0, 0, 0, 1, 1 ], [ 0, 1, E(3), E(3)^2, 0, 0 ], [ 0, 1, E(3)^2, E(3), 0, 0 ], [ 0, 1, 1, 1, 0, 0 ] ],
blockDimensions := [ 2, 1, 1, 1, 1 ],
key := "job06_liftable_f14",
target := 1,
transformedBasis := [ 6*x2^3-3*x3^3-3*x4^3, 9*x2^3+9*x3^3+9*x4^3, 27*x1^2*x2, 27/2*x5^3+27/2*x6^3 ] ),
ok := true,
reason := "all smooth members are Fermat by exact additive splitting into blocks of dimension at most two",
source := "job06_liftable_f14",
status := "embedded",
target := "known_1" ));;
Add(FreshSaturationChecks,rec(
blockCertificate := rec(
Q := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, E(3) ], [ 0, 0, 0, 1, 0, 1 ], [ 0, 0, E(3)^2, 0, E(3), 0 ], [ 0, 0, 1, 0, 1, 0 ] ],
blockDimensions := [ 2, 1, 1, 1, 1 ],
key := "job07_liftable_f4",
target := 1,
transformedBasis := [ -x3^3-x4^3-x5^3-x6^3, x2^3, x1*x2^2, x1^2*x2, x1^3 ] ),
ok := true,
reason := "all smooth members are Fermat by exact additive splitting into blocks of dimension at most two",
source := "job07_liftable_f4",
status := "embedded",
target := "known_1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job07_liftable_f8",
status := "no_embedding",
target := "job03_liftable_f10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job07_liftable_f8",
status := "no_embedding",
target := "known_9" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job07_liftable_f8",
status := "no_embedding",
target := "known_22" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job09_liftable_f4",
status := "no_embedding",
target := "known_27" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job10_liftable_f3",
status := "no_embedding",
target := "job09_liftable_f4" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job10_liftable_f3",
status := "no_embedding",
target := "known_27" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_20" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_93" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_17" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_94" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_95" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "job19_liftable_f21" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job11_liftable_f1",
status := "no_embedding",
target := "job20_liftable_f54" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job11_liftable_f1",
status := "no_embedding",
target := "job23_liftable_f17" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_15" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_19" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job11_liftable_f1",
status := "no_embedding",
target := "job02_nonliftable_f1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_12" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job11_liftable_f1",
status := "no_embedding",
target := "job06_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job11_liftable_f1",
status := "no_embedding",
target := "job07_liftable_f8" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_16" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "job05_liftable_f5" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job11_liftable_f1",
status := "no_embedding",
target := "job03_liftable_f10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_9" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job11_liftable_f1",
status := "no_embedding",
target := "known_22" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "known_25" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "known_34" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "known_35" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "known_37" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "job20_liftable_f6" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "job23_liftable_f16" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "job15_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "job15_liftable_f26" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "known_27" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job13_nonliftable_f1",
status := "no_embedding",
target := "known_21" ));;
Add(FreshSaturationChecks,rec(
blockCertificate := rec(
Q := [ [ 1, 0, E(3), 0, E(3)^2, 0 ], [ 1, 0, E(3)^2, 0, E(3), 0 ], [ 1, 0, 1, 0, 1, 0 ], [ 0, 1, 0, E(3), 0, E(3)^2 ], [ 0, 1, 0, E(3)^2, 0, E(3) ], [ 0, 1, 0, 1, 0, 1 ] ],
blockDimensions := [ 2, 2, 2 ],
key := "job14_nonliftable_f1",
target := 1,
transformedBasis := [ 9*x2^3+9*x4^3+9*x6^3, 9*x1*x2^2+9*x3*x4^2+9*x5*x6^2, 9*x1^2*x2+9*x3^2*x4+9*x5^2*x6, 9*x1^3+9*x3^3+9*x5^3 ] ),
ok := true,
reason := "all smooth members are Fermat by exact additive splitting into blocks of dimension at most two",
source := "job14_nonliftable_f1",
status := "embedded",
target := "known_1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job14_nonliftable_f2",
status := "no_embedding",
target := "job15_liftable_f28" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job14_nonliftable_f2",
status := "no_embedding",
target := "job06_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job14_nonliftable_f2",
status := "no_embedding",
target := "job07_liftable_f8" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job14_nonliftable_f2",
status := "no_embedding",
target := "job03_liftable_f10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job14_nonliftable_f2",
status := "no_embedding",
target := "known_9" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job14_nonliftable_f2",
status := "no_embedding",
target := "known_22" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "strong_fingerprint",
source := "job14_nonliftable_f2",
status := "no_embedding",
target := "known_23" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job15_liftable_f11",
status := "no_embedding",
target := "known_21" ));;
Add(FreshSaturationChecks,rec(
blockCertificate := rec(
Q := [ [ 1, 0, 0, 0, E(3)^2, E(3) ], [ 1, 0, 0, 0, E(3), E(3)^2 ], [ 1, 0, 0, 0, 1, 1 ], [ 0, 1, E(3), E(3)^2, 0, 0 ], [ 0, 1, E(3)^2, E(3), 0, 0 ], [ 0, 1, 1, 1, 0, 0 ] ],
blockDimensions := [ 2, 1, 1, 1, 1 ],
key := "job15_liftable_f14",
target := 1,
transformedBasis := [ 6*x2^3-3*x3^3-3*x4^3, 9*x2^3+9*x3^3+9*x4^3, 27*x1*x2^2, 27*x1^2*x2, 6*x1^3-3*x5^3-3*x6^3, 9*x1^3+9*x5^3+9*x6^3 ] ),
ok := true,
reason := "all smooth members are Fermat by exact additive splitting into blocks of dimension at most two",
source := "job15_liftable_f14",
status := "embedded",
target := "known_1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job15_liftable_f26",
status := "no_embedding",
target := "known_21" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job15_liftable_f28",
status := "no_embedding",
target := "job06_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job15_liftable_f28",
status := "no_embedding",
target := "job07_liftable_f8" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job15_liftable_f28",
status := "no_embedding",
target := "job03_liftable_f10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job15_liftable_f28",
status := "no_embedding",
target := "known_9" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job15_liftable_f28",
status := "no_embedding",
target := "known_22" ));;
Add(FreshSaturationChecks,rec(
P := [ [ 11/3*E(3), 11/3*E(3)^2, 11/3, 0, -E(3), -E(3) ], [ 11/3*E(3), 11/3*E(3)^2, 11/3, 0, -1, -E(3)^2 ], [ 11/3*E(3), 11/3*E(3)^2, 11/3, 0, -E(3)^2, -1 ], [ -4*E(3), -3*E(3)^2, -4, -1, 0, 0 ], [ -3*E(3), -4*E(3)^2, -4, -1, 0, 0 ], [ -4*E(3), -4*E(3)^2, -3, -1, 0, 0 ] ],
ok := true,
reason := "fresh exact matrix verification after transport through a previous witness",
source := "job15_liftable_f28",
status := "embedded",
target := "known_23" ));;
Add(FreshSaturationChecks,rec(
blockCertificate := rec(
Q := [ [ 1, 0, 0, 0, E(3)^2, E(3) ], [ 1, 0, 0, 0, E(3), E(3)^2 ], [ 1, 0, 0, 0, 1, 1 ], [ 0, 1, E(3), E(3)^2, 0, 0 ], [ 0, 1, E(3)^2, E(3), 0, 0 ], [ 0, 1, 1, 1, 0, 0 ] ],
blockDimensions := [ 2, 1, 1, 1, 1 ],
key := "job15_liftable_f29",
target := 1,
transformedBasis := [ 27*x2^3, 27*x1^2*x2-54*x1*x2^2, -27*x2^3+27/2*x3^3+27/2*x4^3+27/2*x5^3+27/2*x6^3 ] ),
ok := true,
reason := "all smooth members are Fermat by exact additive splitting into blocks of dimension at most two",
source := "job15_liftable_f29",
status := "embedded",
target := "known_1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job16_liftable_f4",
status := "no_embedding",
target := "job09_liftable_f4" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job16_liftable_f4",
status := "no_embedding",
target := "known_25" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job16_liftable_f4",
status := "no_embedding",
target := "known_34" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job16_liftable_f4",
status := "no_embedding",
target := "known_35" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job16_liftable_f4",
status := "no_embedding",
target := "known_37" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job16_liftable_f4",
status := "no_embedding",
target := "job20_liftable_f6" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job16_liftable_f4",
status := "no_embedding",
target := "job23_liftable_f16" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job16_liftable_f4",
status := "no_embedding",
target := "known_31" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job16_liftable_f4",
status := "no_embedding",
target := "known_27" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job17_liftable_f2",
status := "no_embedding",
target := "job09_liftable_f4" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job17_liftable_f2",
status := "no_embedding",
target := "known_25" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job17_liftable_f2",
status := "no_embedding",
target := "known_34" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job17_liftable_f2",
status := "no_embedding",
target := "known_35" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job17_liftable_f2",
status := "no_embedding",
target := "known_37" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job17_liftable_f2",
status := "no_embedding",
target := "job20_liftable_f6" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job17_liftable_f2",
status := "no_embedding",
target := "job23_liftable_f16" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job17_liftable_f2",
status := "no_embedding",
target := "known_31" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job17_liftable_f2",
status := "no_embedding",
target := "known_27" ));;
Add(FreshSaturationChecks,rec(
blockCertificate := rec(
Q := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ],
blockDimensions := [ 2, 2, 2 ],
key := "job18_liftable_f3",
target := 1,
transformedBasis := [ x6^3, x5*x6^2, x5^2*x6, x5^3, x1*x2^2+x3*x4^2, x1^3+x3^3 ] ),
ok := true,
reason := "all smooth members are Fermat by exact additive splitting into blocks of dimension at most two",
source := "job18_liftable_f3",
status := "embedded",
target := "known_1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job18_liftable_f4",
status := "no_embedding",
target := "known_25" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job18_liftable_f4",
status := "no_embedding",
target := "known_34" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job18_liftable_f4",
status := "no_embedding",
target := "known_35" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job18_liftable_f4",
status := "no_embedding",
target := "known_37" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job18_liftable_f4",
status := "no_embedding",
target := "job20_liftable_f6" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job18_liftable_f4",
status := "no_embedding",
target := "job23_liftable_f16" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job18_liftable_f4",
status := "no_embedding",
target := "job15_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job18_liftable_f4",
status := "no_embedding",
target := "job15_liftable_f26" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job18_liftable_f4",
status := "no_embedding",
target := "known_27" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job18_liftable_f4",
status := "no_embedding",
target := "known_21" ));;
Add(FreshSaturationChecks,rec(
blockCertificate := rec(
Q := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ],
blockDimensions := [ 2, 2, 2 ],
key := "job19_liftable_f12",
target := 1,
transformedBasis := [ x6^3, x5*x6^2, x5^2*x6, x5^3, x1*x2^2+x3*x4^2, x1^3+x3^3 ] ),
ok := true,
reason := "all smooth members are Fermat by exact additive splitting into blocks of dimension at most two",
source := "job19_liftable_f12",
status := "embedded",
target := "known_1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job19_liftable_f21",
status := "no_embedding",
target := "known_19" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job19_liftable_f21",
status := "no_embedding",
target := "job02_nonliftable_f1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job19_liftable_f21",
status := "no_embedding",
target := "job06_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job19_liftable_f21",
status := "no_embedding",
target := "job07_liftable_f8" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job19_liftable_f21",
status := "no_embedding",
target := "known_10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job19_liftable_f21",
status := "no_embedding",
target := "job05_liftable_f5" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job19_liftable_f21",
status := "no_embedding",
target := "job03_liftable_f10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job19_liftable_f21",
status := "no_embedding",
target := "known_11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job19_liftable_f21",
status := "no_embedding",
target := "known_9" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job19_liftable_f21",
status := "no_embedding",
target := "known_22" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job20_liftable_f6",
status := "no_embedding",
target := "known_27" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job20_liftable_f54",
status := "no_embedding",
target := "known_19" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job20_liftable_f54",
status := "no_embedding",
target := "job02_nonliftable_f1" ));;
Add(FreshSaturationChecks,rec(
P := [ [ 2, 2, 2, 0, -2, 2 ], [ -2, -2, -2, 0, -2, 2 ], [ 0, 0, 0, 3, 3, 3 ], [ 0, 0, 0, -15, 3, 3 ], [ 2*E(3), 2*E(3)^2, 2, 0, 0, 0 ], [ 2*E(3)^2, 2*E(3), 2, 0, 0, 0 ] ],
images := [ [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ], [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ], [ [ 1/3, -2/3, -2/3, 0, 0, 0 ], [ -2/3, 1/3, -2/3, 0, 0, 0 ], [ -2/3, -2/3, 1/3, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ], [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2 ] ], [ [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ] ],
method := "A_strict",
ok := true,
reason := "found",
source := "job20_liftable_f54",
status := "embedded",
target := "job06_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job21_liftable_f4",
status := "no_embedding",
target := "known_47" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job22_liftable_f1",
status := "no_embedding",
target := "known_25" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f1",
status := "no_embedding",
target := "known_34" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f1",
status := "no_embedding",
target := "known_35" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f1",
status := "no_embedding",
target := "known_37" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f1",
status := "no_embedding",
target := "job20_liftable_f6" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job22_liftable_f1",
status := "no_embedding",
target := "job23_liftable_f16" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f1",
status := "no_embedding",
target := "job15_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f1",
status := "no_embedding",
target := "job15_liftable_f26" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job22_liftable_f1",
status := "no_embedding",
target := "known_27" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f1",
status := "no_embedding",
target := "known_21" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f2",
status := "no_embedding",
target := "known_17" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f2",
status := "no_embedding",
target := "known_94" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f2",
status := "no_embedding",
target := "known_95" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f2",
status := "no_embedding",
target := "job19_liftable_f21" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f2",
status := "no_embedding",
target := "job20_liftable_f54" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job22_liftable_f2",
status := "no_embedding",
target := "job23_liftable_f17" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f2",
status := "no_embedding",
target := "job15_liftable_f28" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f2",
status := "no_embedding",
target := "known_19" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job22_liftable_f2",
status := "no_embedding",
target := "job02_nonliftable_f1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job22_liftable_f2",
status := "no_embedding",
target := "job04_liftable_f1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f2",
status := "no_embedding",
target := "job06_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job22_liftable_f2",
status := "no_embedding",
target := "job07_liftable_f8" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job22_liftable_f2",
status := "no_embedding",
target := "known_10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job22_liftable_f2",
status := "no_embedding",
target := "job05_liftable_f5" ));;
Add(FreshSaturationChecks,rec(
P := [ [ -4, 0, -4*E(3)^2, -4*E(3), -2*E(3), -2 ], [ 0, -4, -4*E(3), -4*E(3)^2, -2*E(3), -2 ], [ -4*E(3), -4*E(3)^2, 0, -4, -2*E(3), -2 ], [ -4*E(3)^2, -4*E(3), -4, 0, -2*E(3), -2 ], [ 0, 0, 0, 0, -3*E(3)^2, -3 ], [ -3, -3, -3, -3, 4, 4 ] ],
images := [ [ [ 0, E(3)^2, 0, 0, -E(3)^2, 0 ], [ 0, 0, E(3)^2, 0, -E(3)^2, 0 ], [ E(3)^2, 0, 0, 0, -E(3)^2, 0 ], [ 0, 0, 0, E(3)^2, -E(3)^2, 0 ], [ 0, 0, 0, 0, -E(3)^2, E(3)^2 ], [ 0, 0, 0, 0, -E(3)^2, 0 ] ], [ [ E(3), 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, E(3), 0, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, E(3), 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, E(3), -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ], [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ] ],
method := "A_strict",
ok := true,
reason := "found",
source := "job22_liftable_f2",
status := "embedded",
target := "job03_liftable_f10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job23_liftable_f16",
status := "no_embedding",
target := "known_27" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job23_liftable_f17",
status := "no_embedding",
target := "known_19" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job23_liftable_f17",
status := "no_embedding",
target := "job02_nonliftable_f1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job23_liftable_f17",
status := "no_embedding",
target := "job06_liftable_f11" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "derived_series",
source := "job23_liftable_f17",
status := "no_embedding",
target := "job07_liftable_f8" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job23_liftable_f17",
status := "no_embedding",
target := "known_10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job23_liftable_f17",
status := "no_embedding",
target := "job05_liftable_f5" ));;
Add(FreshSaturationChecks,rec(
P := [ [ -81/70, 0, 0, 0, 9/38, 0 ], [ 0, 0, -81/70, 0, 9/38, 0 ], [ 0, 0, 0, -81/70, 9/38, 0 ], [ 0, -81/70, 0, 0, 9/38, 0 ], [ 27/280, 27/280, 27/280, 27/280, 0, 1 ], [ 27/28, 27/28, 27/28, 27/28, 0, 0 ] ],
images := [ [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3), 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, E(3), 0, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, E(3), 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, E(3), -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ], [ [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ] ],
method := "A_strict",
ok := true,
reason := "found",
source := "job23_liftable_f17",
status := "embedded",
target := "job03_liftable_f10" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job24_liftable_f3",
status := "no_embedding",
target := "known_29" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job24_liftable_f3",
status := "no_embedding",
target := "known_31" ));;
Add(FreshSaturationChecks,rec(
P := [ [ -4, -4, -4, -4, -4, 1 ], [ 3, 3, 3, 3, 3, 4 ], [ -2*E(5), -2*E(5)^3, -2*E(5)^4, -2, -2*E(5)^2, 0 ], [ 3*E(5)^2, 3*E(5), 3*E(5)^3, 3, 3*E(5)^4, 0 ], [ 3*E(5)^2, 3*E(5)^3, 3*E(5), 3*E(5)^4, 3, 0 ], [ -2*E(5), -2*E(5)^4, -2*E(5)^3, -2*E(5)^2, -2, 0 ] ],
images := [ [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ 4/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, 0 ], [ -1/5*E(3)+1/5*E(3)^2, 4/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, 0 ], [ -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, 4/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, 0 ], [ -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, 4/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, 0 ], [ -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, -1/5*E(3)+1/5*E(3)^2, 4/5*E(3)+1/5*E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ], [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ] ],
method := "A_strict",
ok := true,
reason := "found",
source := "job25_liftable_f2",
status := "embedded",
target := "job05_liftable_f1" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "element_order_multiset",
source := "job25_liftable_f3",
status := "no_embedding",
target := "known_29" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job25_liftable_f3",
status := "no_embedding",
target := "known_31" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "weak_fingerprint",
source := "job27_liftable_f4",
status := "no_embedding",
target := "known_47" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job28_liftable_f1",
status := "no_embedding",
target := "job09_liftable_f4" ));;
Add(FreshSaturationChecks,rec(
method := "filter",
ok := false,
reason := "exponent",
source := "job28_liftable_f1",
status := "no_embedding",
target := "known_27" ));;
