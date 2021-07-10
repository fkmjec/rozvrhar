% is_feasible(?Subjects)
% - takes a list of subjects sorted by start time, returns true if the schedule doesnt overlapp
is_schedule_feasible([]).
is_schedule_feasible([X]).
is_schedule_feasible([subject(_, _, EndTime, _), subject(Code, StartTime, EndTime2, Place) | Other_subjects]) :- (
    AdjustedEndTime is EndTime + 10,
    AdjustedEndTime =< StartTime,
    is_schedule_feasible([subject(Code, StartTime, EndTime2, Place) | OtherSubjects)
).

% order_subjects(-Delta, +S1, +S2)
order_subjects(<, subject(_, StartTime1, _, _), subject(_, StartTime2, _, _)) :- (
    StartTime1 =< StartTime2
).
order_subjects(>, subject(_, StartTime1, _, _), subject(_, StartTime2, _, _)) :- (
    StartTime1 >= StartTime2
).

% sort_schedule(+Unsorted, -Sorted)
sort_schedule(Unsorted, Sorted) :- (
    
).

% create_schedule(+Subjects, -Schedule)
