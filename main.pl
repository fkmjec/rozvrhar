%%%%%%%% SCHEDULE DATA %%%%%%%%
subject(nswi177, 1, 2, s3).
subject(nswi178, 2, 3, s3).

%%%%%%%% SCHEDULE VALIDATION %%%%%%%% 

% order_subjects(-Delta, +S1, +S2)
compare_events(<, event(_, Time1), event(_, Time2)) :- (
    Time1 =< Time2
).
compare_events(>, event(_, Time1), event(_, Time2)) :- (
    Time1 > Time2
).

% create_events_acc(+Schedule, +Acc, -Events)
create_events_acc([], Acc, Acc).
create_events_acc([subject(_, StartTime, EndTime, _) | ScheduleSuffix], Acc, Events) :- (
    create_events_acc(ScheduleSuffix, [event(start, StartTime), event(end, EndTime) | Acc], Events)
).

% create_events(+Schedule, -SortedEvents)
% creates the starts and ends of a schedule as events
create_events(Schedule, SortedEvents) :- (
    create_events_acc(Schedule, [], Events),
    sort_events(Events, SortedEvents)
).

% sort_events(+Unsorted, -Sorted)
sort_events(Unsorted, Sorted) :- (
    predsort(compare_events, Unsorted, Sorted)
).

% is_schedule_feasible_internal(+SortedEvents, +LastEventTime, +IsLessonUnderway)
is_schedule_feasible_internal([], _, _).
is_schedule_feasible_internal([event(start, Time) | NextEvents], LastEventTime, 0) :- (
    (Time - LastEventTime) >= 10,
    is_schedule_feasible_internal(NextEvents, Time, 1)
).
is_schedule_feasible_internal([event(end, Time) | NextEvents], _, 1) :- (
    is_schedule_feasible_internal(NextEvents, Time, 0)
).

% is_schedule_feasible(+Schedule)
% - takes a list of subjects sorted by start time, returns true if the schedule doesnt overlapp
is_schedule_feasible([]).
is_schedule_feasible(Schedule) :- (
    create_events(Schedule, SortedEvents),
    is_schedule_feasible_internal(SortedEvents, -10, 0)
).

%%%%%% SCHEDULE CREATION %%%%%%

% create_schedule_internal(+Codes, +Acc, -Schedule)
create_schedule_internal([], Acc, Acc).
create_schedule_internal([Code | CodesSuffix], Acc, Schedule) :- (
    subject(Code, X, Y, Z),
    create_schedule_internal(CodesSuffix, [subject(Code, X, Y, Z) | Acc], Schedule)
).

% create_schedule(+SubjectCodes, -Schedule)
create_schedule(SubjectCodes, Schedule) :- (
    create_schedule_internal(SubjectCodes, [], Schedule),
    is_schedule_feasible(Schedule)
).