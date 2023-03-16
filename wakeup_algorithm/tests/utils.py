import csv

def create_mock_csv(filename, data):
    # Open a new file in write mode
    with open(filename, mode='w', newline='') as csv_file:
        # Create a CSV writer object
        writer = csv.writer(csv_file)
        # Write the data to the CSV file
        for row in data:
            writer.writerow(row)