# Rozvrhář
Rozvrhář is a program for automatically creating a class schedule for a student written in Prolog.
You provide a list of the courses as Prolog terms and a list of the courses that you want to fit into the schedule and it generates all non-overlapping variants.

The input format of Prolog terms is quite simple; it's based on the way courses are organized at MFF UK.
A course is something that you need to pass. It has its own ID code (for example NSWI177). That course can
have multiple classes - lectures, seminars, tutorials.

## Source data format
For every course, there is one `subject` and multiple `subject_instance` terms:
- `subject(Code, Name, MandatoryInstances)`
  - **Code** - the identifier of the subject
  - **Name** - name of the subject
  - **MandatoryInstances** - a list of mandatory instance types that you must have. For example \[lecture tutorial\]

- `subject_instance(Code, InstanceType, Start, End, Teacher, Building, Room)`
  - **Code** - same as with `subject`
  - **InstanceType** - lecture or tutorial or whatever you define in `subject`
  - **Start** and **End** - times in the format `date(Day, Hour, Minute)`
  - **Teacher** - string with the name of the teacher
  - **Building** - where the teaching takes place
  - **Room** - where in the building the teaching takes place

You can find test input files in the git repository and they should eliminate any confusion.
Note that all of the data must begin with lower-case, because if not, Prolog will treat them as variables.

## Creating the schedule
For creating the actual schedule, you must first create the source file as written above.
Then, you open up an instance of Prolog, preferably SWI-Prolog (I have not tested any other implementation).

```swipl main.pl [SOURCE_FILE]```

Then, you just need to write:

```get_possible_schedules([code1, code2...])```

and you will be greeted with the possible schedules.