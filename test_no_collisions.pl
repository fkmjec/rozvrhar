subject(nswi179, "Úvod do Unixu", [tutorial]).
subject_instance(nswi179, tutorial, date(tue, 15, 40), date(tue, 17, 10), 'Petr Tůma', s4, ms).
subject(nswi178, "Úvod do FreeBSD", [tutorial]).
subject_instance(nswi178, tutorial, date(mon, 15, 40), date(mon, 17, 10), 'Vojtěch Horký', s4, ms).
subject(nswi180, "Úvod do Linuxu", [tutorial]).
subject_instance(nswi180, tutorial, date(wed, 15, 40), date(wed, 17, 10), 'Lubomír Bulej', s4, ms).
subject(nswi181, "Úvod do Windows", [tutorial]).
subject_instance(nswi181, tutorial, date(thu, 15, 40), date(thu, 17, 10), 'Pavel Ježek', s4, ms).
subject(nswi182, "Úvod do C#", [tutorial]).
subject_instance(nswi182, tutorial, date(fri, 15, 40), date(fri, 17, 10), 'Pavel Turinský', s4, ms).

% INPUT: get_possible_schedules([nswi178, nswi179, nswi180, nswi181, nswi182]).
% OUTPUT:
% ====== ROZVRH ======
% [mon,nswi178,tutorial,15,40,Vojtěch Horký,s4,ms]
% [tue,nswi179,tutorial,15,40,Petr Tůma,s4,ms]
% [wed,nswi180,tutorial,15,40,Lubomír Bulej,s4,ms]
% [thu,nswi181,tutorial,15,40,Pavel Ježek,s4,ms]
% [fri,nswi182,tutorial,15,40,Pavel Turinský,s4,ms]