import csv
import argparse

def print_types(types):
    print("[", end="")
    for i in range(0, len(types)):
        if i != len(types) - 1:
            print(t, end=",")
        else:
            print(t, end="")
    print("]")

class Subject:
    def __init__(self, code, name):
        self.code = code
        self.name = name
        self.instances = {}
    
    def add_instance(self, instance):
        self.instances[instance.type] = instance

    def print(self):
        print("subject({}, \'{}\', {})".format(code, name, print_types(types)))
        for instance_type, instance in self.instances.items():
            

class SubjectInstance:
    def __init__(self, code, subject_type, start, end, teacher, building, room):
        self.code = code
        self.instance_type = instance_type
        self.day = day
        self.minutes = minutes
        self.length = length
        self.teacher = teacher
        self.building = building
        self.room = room
    
    def to_s(self):
        return "subject_instance({}, {}, {}, {}, \'{}\', \'{}\', \'{}\', \'{}\').".format(
            self.code,
            self.instance_type,
            self.start,
            self.end,
            self.teacher,
            self.building,
            self.room
        )


days = ['kek', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']

def get_date(day, minutes):
    return "date({}, {}, {})".format(days[day], minutes // 60, minutes % 60)

def load_csv(filename):
    subjects = {}        
    with open(filename) as input_file:
        reader = csv.reader(input_file, delimiter=';')
        next(reader)
        for row in reader:
            if row[0] == '':
                continue
            elif row[2] != '' and row[3] != '' and  row[4] != '' and row[5] != '' and row[6] != '' and row[7] != '':
                unique_code = row[0].lower()
                code = row[2].lower()
                name = row[3]
                day = int(row[4])
                minutes = int(row[5])
                place = row[6].lower()
                length = int(row[7])
                date_start = get_date(day, minutes)
                date_end = get_date(day, minutes + length)
                teacher = 

