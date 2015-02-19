from datetime import datetime

period = ["Before School", "Period 1", "Period 2", "Period 3", "Period 4", "Period 5", "Period 6", "Period 7", "Period 8", "Period 9", "Period 10", "After School", "Break"]

hour = str(datetime.now().time())[0:2]
hour = int(hour)

minute = str(datetime.now().time())[3:5]
minute = int(minute)

day =  datetime.today().weekday()

def getPeriod():
    if day < 5:
        if hour == 24 or hour <= 8:
            now = period[0]
        elif hour == 8 and minute <= 41:
            now = period[1]
        elif (hour == 8 and minute >= 45) or (hour == 9 and minute <= 26):
            now = period[2]
        elif (hour == 9 and minute >= 31) or (hour == 10 and minute <= 15):
            now = period[3]
        elif (hour == 10 and minute >= 20) or (hour == 11 and minute <= 1):
            now = period[4] 
        elif hour == 11 and (minute >= 06 and minute <= 47):
            now = period[5]
        elif (hour == 11 and minute >= 52) or (hour == 12 and minute <= 33):
            now = period[6]
        elif (hour == 12 and minute >= 38) or (hour == 13 and minute <= 19):
            now = period[7]
        elif (hour == 13 and minute >= 24) or (hour == 14 and minute <= 5):
            now = period[8]
        elif (hour == 14 and (minute >= 9 and minute <= 50)):
            now = period[9]
        elif (hour == 14 and minute >= 54) or (hour == 15 and minute < 35):
            now = period[10]
        elif (hour >= 15 and hour <= 23):
            if (hour == 15 and minute >= 35):
                now = period[11]
            elif (hour <= 23 and minute <= 59):
                now = period[11]
        else:
            now = period[12]
    else:
        now = 'No School'
    return now

if __name__ == '__main__':
    print getPeriod()

