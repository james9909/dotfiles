from datetime import datetime
from schedule import getPeriod

now = getPeriod()
def endTimes():
    if getPeriod() == 'Period 1':
        return 'Ends at 8:41'
    elif getPeriod() == 'Period 2':
        return 'Ends at 9:26'
    elif getPeriod() == 'Period 3':
        return 'Ends at 10:15'
    elif getPeriod() == 'Period 4':
        return 'Ends at 11:01'
    elif getPeriod() == 'Period 5':
        return 'Ends at 11:47'
    elif getPeriod() == 'Period 6':
        return 'Ends at 12:33'
    elif getPeriod() == 'Period 7':
        return 'Ends at 1:19'
    elif getPeriod() == 'Period 8':
        return 'Ends at 2:05'
    elif getPeriod() == 'Period 9':
        return 'Ends at 2:50'
    elif getPeriod() == 'Period 10':
        return 'Ends at 3:35'
    elif getPeriod() == 'Break':
        return 'Break ends in a few mins'
    else:
        return 'Starts at 8:00'

print endTimes()
