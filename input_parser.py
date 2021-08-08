import csv
import argparse

days = ['kek', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']

def get_date(day, minutes):
    return "date({}, {}, {})".format(days[day], minutes // 60, minutes % 60)


with open("tyden.csv") as input_file:
    reader = csv.reader(input_file, delimiter=';')
    next(reader)
    for row in reader:
        if row[2] != '' and row[4] != '' and row[5] != '' and row[6] != '' and row[7] != '':
            code = row[2].lower()
            day = int(row[4])
            minutes = int(row[5])
            place = row[6].lower()
            length = int(row[7])
            date_start = get_date(day, minutes)
            date_end = get_date(day, minutes + length)
            print("subject({}, {}, {}, {}).".format(code, date_start, date_end, place))
