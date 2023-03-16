from utils import create_mock_csv
import sys
import os
import pickle
from datetime import datetime, timedelta
import csv

sys.path.insert(0, os.path.abspath('..'))

from wakeup import get_should_wake_user

# Dummy accelerometer dict - values don't matter as this won't be read anyways
acc_dict = {
    "filename": "Accelerometer.csv",
    "sampling_freq": 20
}

# REM flags
user_in_REM_none = None
user_in_REM_true = True

REM_flag_none = pickle.dumps(user_in_REM_none)
REM_flag_true = pickle.dumps(user_in_REM_true)

# Sample data to write to the mock CSV file
acc_no_movement_data = [
    ["seconds_elapsed", "x", "y", "z"],
    ["1677476699445029400","0","0","0","0"]
]

acc_movement_data = [
    ["seconds_elapsed", "x", "y", "z"],
    ["1677476699445029400","2","2","2","2"]
]

""" 
    CASE 1: User is in REM sleep.

    1a: There is still time in alarm window - user should not be woken up, REM flag should be raised
    1b: There is one minute left in alarm window - user should be woken up, REM flag should be same as what was passed in
    1c: There is no time left in alarm window - user should be woken up, REM flag should be same as what was passed in
    1d: User transitions from NREM --> REM (also tests that flag value persists over multiple runs) - REM flag should go from None --> True

"""
def test_1a():
    curr_time = datetime.now()
    alarm_end = curr_time + timedelta(0, 600)

    should_wake_user, REM_flag = get_should_wake_user(True, acc_dict, alarm_end, REM_flag_none) 
    assert should_wake_user == False
    assert pickle.loads(REM_flag) == True

def test_1b():
    curr_time = datetime.now()
    alarm_end = curr_time + timedelta(0, 60)

    should_wake_user, REM_flag = get_should_wake_user(True, acc_dict, alarm_end, REM_flag_none) 
    assert should_wake_user == True
    assert pickle.loads(REM_flag) == None

def test_1c():
    curr_time = datetime.now()

    should_wake_user, REM_flag = get_should_wake_user(True, acc_dict, curr_time, REM_flag_true) 
    assert should_wake_user == True
    assert pickle.loads(REM_flag) == True

def test_1d():
    curr_time = datetime.now()
    alarm_end = curr_time + timedelta(0, 600)
    i = 0
    REM_flag = REM_flag_none

    # user not in REM
    while i < 3:
        should_wake_user, REM_flag = get_should_wake_user(False, acc_dict, alarm_end, REM_flag) 
        assert pickle.loads(REM_flag) == None
        i += 1
    i = 0
    # user finally in REM
    while i < 3:
        should_wake_user, REM_flag = get_should_wake_user(True, acc_dict, alarm_end, REM_flag) 
        assert pickle.loads(REM_flag) == True
        i += 1

    assert should_wake_user == False
    assert pickle.loads(REM_flag) == True

""" 
    CASE 2: User is in NREM sleep. They were previously never in REM.

    1a: There is still time in alarm window - user should not be woken up
    1b: There is one minute left in alarm window - user should be woken up
    1c: There is no time left in alarm window - user should be woken up

"""
# def test_2a():
#     curr_time = datetime.now()
#     alarm_end = curr_time + timedelta(0, 600)

#     assert get_should_wake_user(False, acc_dict, alarm_end) == False

# def test_2b():
#     curr_time = datetime.now()
#     alarm_end = curr_time + timedelta(0, 60)

#     assert get_should_wake_user(False, acc_dict, alarm_end) == True

# def test_2c():
#     curr_time = datetime.now()

#     assert get_should_wake_user(False, acc_dict, curr_time) == True

