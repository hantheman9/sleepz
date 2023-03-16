from accelerometer_processing import get_user_movement
from datetime import datetime
import pickle

"""
    Script to determine if a user should be woken up.

    Instructions:
    1. call init() once before the next step
    2. call get_should_wake_user() every time you want to check if a user should be woken up. See the method on more details on inputs.
        This function should be called the first time with the return value from init(), then subsequent times with its own return value. example below:

        data = init()
        should_wake_user, REM_flag = get_should_wake_user(is_REM, accelerometer_data, alarm_end, data) # first call
        should_wake_user, REM_flag = get_should_wake_user(is_REM, accelerometer_data, alarm_end, REM_flag) # subsequent calls
"""

""" 
    init() initializes the REM flag and serializes it for future runs of the main function.
    This should be called first before the main function.

    :param user_in_REM: is the REM flag; defaults to None - this parameter should only be passed in for testing purposes
"""
def init(user_in_REM=None):
    return pickle.dumps(user_in_REM)


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
            "filename": "Accelerometer.csv", # string, MUST BE .CSV FILE! expected columns are "seconds_elapsed", "x", "y", "z"
            "sampling_freq": 20 # integer, frequency at which the data was sampled.
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
    acc_filename = accelerometer_data["filename"]
    fs = accelerometer_data["sampling_freq"]

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
