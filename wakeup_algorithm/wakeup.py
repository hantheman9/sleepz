from accelerometer_processing import get_user_movement
from datetime import datetime
import pickle
import numpy as np
""" 
    init() initializes the REM flag and serializes it for future runs of the main function.
    This should be called first before the main function.
"""
def init():
    # initialize flag value
    user_in_REM = None
    
    # pickle the flag
    data = pickle.dumps(user_in_REM)

    # return pickled value
    return data

""" 
    get_time_left() checks if there is less than or equal to 1 minute left in the alarm window.

    :param alarm_end: time at which alarm window ends

    :return: boolean value indicating if there is <= 1 minute left in the alarm window
"""
def get_time_left(alarm_end: datetime.time):
    curr_time = datetime.now()

    return True if ((alarm_end - curr_time).total_seconds() <= 60.0) else False


""" 
    get_should_wake_user() determines if user should be woken up

    :param is_REM: boolean value indicating if user's current sleep stage is REM or not
    :param accelerometer_data: dictionary storing the following information:
        dict = {
            "filename": "Accelerometer.csv", # string
            "sampling_freq": 20 # integer
        }
    :param alarm_end: datetime time value indicating when the alarm window ends
    :param REM_flag: pickled value in bytes of the REM flag

    :return should_wake_user: boolean value indicating if user should be woken up
    :return REM_flag: repickled value of new REM flag
"""

def get_should_wake_user(is_REM: bool, accelerometer_data:dict, alarm_end:datetime.time, REM_flag: bytes):

    # load REM flag value
    user_in_REM = pickle.loads(REM_flag)

    # if there is no time left in window, just wake user up, return previously passed in REM flag value
    if (get_time_left(alarm_end)): return True, REM_flag

    # get accelerometer data organized
    (acc_filename, fs) = next(iter(accelerometer_data.items()))

    # user is in REM
    if (is_REM):
        user_in_REM = True
        should_wake_user = False

    # user is in NREM, but was in REM previously
    elif (not is_REM and user_in_REM):
       
        #check if user is moving
        is_moving = get_user_movement(acc_filename, fs)

        should_wake_user = True if is_moving else get_time_left(alarm_end)

    # user is in NREM and hasn't been in REM previously
    elif (not is_REM and not user_in_REM):
        should_wake_user = get_time_left(alarm_end)
    
    # repickle REM flag value
    REM_flag = pickle.dumps(user_in_REM)

    return should_wake_user, REM_flag
