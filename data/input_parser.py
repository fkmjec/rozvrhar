import csv
import argparse

def get_type_string(instance_types):
    result = ["["]
    for i in range(0, len(instance_types)):
        if i != len(instance_types) - 1:
            result.append(instance_types[i] + ",")
        else:
            result.append(instance_types[i])
    result.append("]")
    return "".join(result)

class Subject:
    def __init__(self, code, name):
        self.code = code
        self.name = name
        self.types = {}
        self.instances = []
    
    def add_instance(self, instance):
        if self.types.get(instance.type) == None:
            self.types[instance.type] = True
        self.instances.append(instance)

    def print(self):
        print("subject({}, \'{}\', {}).".format(self.code, self.name, get_type_string(list(self.types.keys()))))
        for instance in self.instances:
            print(instance.to_s())
            

class SubjectInstance:
    def __init__(self, code, instance_type, start, end, teacher, building, room):
        self.code = code
        self.type = instance_type
        self.start = start
        self.end = end
        self.teacher = teacher
        self.building = building
        self.room = room
    
    def to_s(self):
        return "subject_instance({}, {}, {}, {}, \'{}\', \'{}\', \'{}\').".format(
            self.code,
            self.type,
            self.start,
            self.end,
            self.teacher,
            self.building,
            self.room
        )


days = ['filler', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']

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
                instance_type = row[0][10]
                code = row[2].lower()
                name = row[3]
                day = int(row[4])
                minutes = int(row[5])
                place = row[6].lower()
                length = int(row[7])
                date_start = get_date(day, minutes)
                date_end = get_date(day, minutes + length)
                room = row[6]
                building = "Malá Strana"
                teacher = row[12]
                if subjects.get(code) == None:
                    subjects[code] = Subject(code, name)
                subjects[code].add_instance(SubjectInstance(code, instance_type, date_start, date_end, teacher, building, room))
    return subjects

parser = argparse.ArgumentParser(description='Parses the input data from a schedule taken from SIS into Prolog terms')
parser.add_argument('filename', metavar='filename', help='The file to read from')

args = parser.parse_args()

subjects = load_csv(args.filename)
for subject in subjects.values():
    subject.print()

