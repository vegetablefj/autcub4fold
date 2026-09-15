# Run one selected projective-group task in a fresh GAP session.

Read("input/gap_large_tasks.g");
Read("input/gap_large_routing.g");
Read("input/gap_large_kplus_inputs.g");

RunLargeGroupCase := function(taskNo, branch)
    local task, route, fixedAction;

    if not IsInt(taskNo) or taskNo < 1 or taskNo > Length(Tasks) then
        Error("taskNo must be an entry of Tasks");
    fi;
    task := Tasks[taskNo];
    route := Routing[taskNo];
    if route.task <> task.task or Position(route.branches, branch) = fail then
        Error("branch is not listed for this task");
    fi;
    fixedAction := First(KInputs, x -> x.base = task.base);
    if fixedAction = fail then
        Error("fixed symplectic action is missing");
    fi;

    if branch = "liftable" then
        Read("source/gap_large_liftable_engine.g");
    elif branch = "nonliftable" then
        Read("source/gap_large_nonliftable_engine.g");
    else
        Error("branch must be liftable or nonliftable");
    fi;

    S(task.gid, fixedAction.generators);
    return CF_LAST_S_RESULT;
end;
