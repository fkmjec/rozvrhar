%%%%%%%% SCHEDULE DATA %%%%%%%%
subject(nswi177, date(mon, 14, 0), date(mon, 15, 30), s3).
subject(nswi177, date(mon, 15, 40), date(mon, 17, 10), s4).
subject(nswi178, date(mon, 14, 0), date(mon, 15, 30), s3).


%%%%%%%% DATE AND TIME CONVERSION %%%%%%%%%
daynum(mon, 0).
daynum(tue, 1).
daynum(wed, 2).
daynum(thu, 3).
daynum(fri, 4).
daynum(sat, 5).
daynum(sun, 6).

% daytime2minutes(+date(Day, Hours, Mins), -Minutes)
% convert time in the week into minutes since start of the week
daytime2minutes(date(Day, Hours, Mins), Minutes) :- (
    daynum(Day, DayNum),
    Minutes is (DayNum * 1440 + Hours * 60 + Mins)
).

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
create_events_acc([subject(_, Start, End, _) | ScheduleSuffix], Acc, Events) :- (
    daytime2minutes(Start, StartMinutes),
    daytime2minutes(End, EndMinutes),
    create_events_acc(ScheduleSuffix, [event(start, StartMinutes), event(end, EndMinutes) | Acc], Events)
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
    subject(Code, date(Day1, Hour1, Min1), date(Day2, Hour2, Min2), Place),
    create_schedule_internal(CodesSuffix, [subject(Code, date(Day1, Hour1, Min1), date(Day2, Hour2, Min2), Place) | Acc], Schedule)
).

% create_schedule(+SubjectCodes, -Schedule)
create_schedule(SubjectCodes, Schedule) :- (
    create_schedule_internal(SubjectCodes, [], Schedule),
    is_schedule_feasible(Schedule)
).