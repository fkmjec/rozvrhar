%%%%%%%% SCHEDULE DATA %%%%%%%%
% subject_instance(Code, InstanceType, Start, End, Teacher, Building, Room)
% format for inputting subjects and subject instances in prolog terms.
% - @Code - the identifier of the subject
% - @InstanceType - lecture or tutorial
% - @Start and @End - times in the format date(Day, Hour, Minute)
% - @Teacher - string with the name of the Teacher
% - @Building - the teaching takes place, it is used to calculate transfers if you wish so.
% - @Room - where in the building the teaching takes place
%
% subject(Code, Name, MandatoryInstances)
% - @Code - as above
% - @Name - name of the subject
% - @MandatoryInstances - a list of mandatory instance types that you must have. Usually [lecture, tutorial]

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
create_events_acc([subject_instance(_, _, date(StartDay, StartHours, StartMins), date(EndDay, EndHours, EndMins), _, _, _) | ScheduleSuffix], Acc, Events) :- (
    daytime2minutes(date(StartDay, StartHours, StartMins), StartMinutes),
    daytime2minutes(date(EndDay, EndHours, EndMins), EndMinutes),
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

compare_subject_starts(>, subject_instance(_, _, Time1, _, _, _, _), subject_instance(_, _, Time2, _, _, _, _)) :- (
    daytime2minutes(Time1, Minutes1),
    daytime2minutes(Time2, Minutes2),
    Minutes1 > Minutes2
).
compare_subject_starts(<, subject_instance(_, _, Time1, _, _, _, _), subject_instance(_, _, Time2, _, _, _, _)) :- (
    daytime2minutes(Time1, Minutes1),
    daytime2minutes(Time2, Minutes2),
    Minutes1 =< Minutes2
).

sort_schedule_by_start(Subjects, SortedSubjects) :- (
    predsort(compare_subject_starts, Subjects, SortedSubjects)
).

%%%%%% SCHEDULE CREATION %%%%%%

% get_subject_instances(Code, InstanceTypes, Instances)
% - gets a subject code and returns a set of subject instances (lectures, tutorials) that are
% required to pass the course
get_subject_instances(Code, InstanceTypes, Instances) :- (
    get_subject_instances_internal(Code, InstanceTypes, [], Instances)
).

get_subject_instances_internal(_, [], Acc, Acc).
get_subject_instances_internal(Code, [Type | Types], Acc, Instances) :- (
    subject_instance(Code, Type, date(D1, H1, M1), date(D2, H2, M2), Lecturer, Building, Room),
    get_subject_instances_internal(Code, Types, [subject_instance(Code, Type, date(D1, H1, M1), date(D2, H2, M2), Lecturer, Building, Room) | Acc], Instances)
).

% create_schedule_internal(+Codes, +Acc, -Schedule)
create_schedule_internal([], Acc, Acc).
create_schedule_internal([Code | CodesSuffix], Acc, Schedule) :- (
    subject(Code, _, SubjectInstanceTypes),
    get_subject_instances(Code, SubjectInstanceTypes, SubjectInstances),
    append(SubjectInstances, Acc, NewAcc),
    create_schedule_internal(CodesSuffix, NewAcc, Schedule)
).

% create_schedule(+SubjectCodes, -Schedule)
create_schedule(SubjectCodes, SortedSchedule) :- (
    create_schedule_internal(SubjectCodes, [], Schedule),
    is_schedule_feasible(Schedule),
    sort_schedule_by_start(Schedule, SortedSchedule)
).

print_single_schedule_internal([]).
print_single_schedule_internal([subject_instance(Code, Type, date(D1, H1, M1), _, Lecturer, Building, Room) | Subjects]) :- (
    writeln([D1, Code, Type, H1, M1, Lecturer, Building, Room]),
    print_single_schedule_internal(Subjects)
).

% print_single_schedule(+Schedule)
% - a helper procedure which prints a single schedule
% @Schedule - list of subject instances
print_single_schedule(Schedule) :- (
    writeln("====== ROZVRH ======"),
    print_single_schedule_internal(Schedule),
    writeln("")
).

% print_schedules(+Schedules)
% - a helper procedure which prints all schedules in a list
% @Schedules - list of lists of subject instances
print_schedules([]).
print_schedules([Schedule | Schedules]) :- (
    print_single_schedule(Schedule),
    print_schedules(Schedules)
).

% get_possible_schedules(+Codes)
% the procedure prints all the possible schedule combinations you can get
% @Codes - the codes of the subjects you want to take
get_possible_schedules(Codes) :- (
    findall(Schedule, create_schedule(Codes, Schedule), Schedules),
    print_schedules(Schedules)
).