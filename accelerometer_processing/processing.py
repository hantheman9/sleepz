import numpy as np
from scipy import signal
import pandas as pd

"""
    Processing script to convert triaxial accelerometer data to activity count.

    Input file requirements: .csv; has "seconds_elapsed", "x", "y", "z" columns; is for a single reading
    Use process_data() to run script.
"""

# CONSTANT - represents zero-activity offset value
ACTIVITY_THRESHOLD = 0.012582513966618908

"""
    magnitude() calculates magnitude of acceleration

    :param data: Dataframe with seconds_elapsed, x, y, z axis
    :return: Dataframe with column "signal_magnitude" added
"""


def magnitude(data):
    print("Calculating magnitude")

    acc = data[["x", "y", "z"]]

    return data.assign(magnitude=np.sqrt(np.sum(np.square(acc), axis=1)))


"""
    filter() passes the data through a filter to remove noise/high frequency components

    :param data: Dataframe with seconds_elapsed, magnitude
    :param freq: integer sampling frequency of data
    :return: Dataframe with column "filtered_signal" added
"""


def filter(data, sampling_frequency: int):
    print("Filtering signal")

    raw = data[["magnitude"]]

    # Define the filter parameters
    highcut = 3.5  # Hz
    filter_order = 6

    # Create the filter coefficients
    nyquist_frequency = 0.5 * sampling_frequency
    normalized_highcut = highcut / nyquist_frequency

    b, a = signal.butter(
        filter_order, [normalized_highcut], btype='lowpass')

    # Apply the filter to the data
    filtered = abs(signal.filtfilt(b, a, raw, padlen=0))

    return data.assign(filtered_signal=filtered)


"""
    get_movement() calculates if the given data indicates user movement

    :param data: Dataframe with seconds_elapsed, filtered_signal
    :return: integer count value

    NOTE: this code assumes that the passed in data was for a 30sec sample.
"""


def get_movement(data):

    data = np.ndarray.flatten(data.to_numpy())
    if data > ACTIVITY_THRESHOLD:
        return True

    return False


"""
    process_data() takes in the csv file and completes all necessary processing to output activity count

    :param filename: string of the file name, e.g. "Accelerometer.csv", with columns "seconds_elapsed", "x", "y", "z"
    :param fs: integer representing sampling frequency
    :return: integer activity count value
"""


def process_data(filename=str, fs=int):

    # read full file
    acc = pd.read_csv(filename)

    # take accelerometer data only
    raw = acc[["seconds_elapsed", "x", "y", "z"]]

    # calculate acceleration magnitude
    data = magnitude(raw)

    # pass magnitude through filter
    data = filter(data, fs)

    final = data[["filtered_signal"]]

    # get binary movement value
    is_moving = get_movement(final)

    return is_moving


print(process_data("Accelerometer.csv", 50))
