###############################################################################
#               Test if a SQL Server instance is accessible                   #
###############################################################################
import pyodbc

# Define the login credentials
username = 'username'
password = 'password'

# Open the text file containing server names
input_file = 'sqlsrvinstancesList.txt'
with open(input_file, 'r') as file:
    # Read lines from the file
    servers = file.readlines()

# Open a text file in append mode to write successful logins
output_file = 'successful_logins.txt'
with open(output_file, 'a') as outfile:
    # Iterate over each server
    for server in servers:
        # Strip any leading or trailing whitespace from the server name
        server = server.strip()

        try:
            # Connect to the server
            conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';UID='+username+';PWD='+password+';Encrypt=no')
            
            # If connection is successful, append the server name to the text file
            outfile.write(f"Successful login to SQL Server instance '{server}'\n")
            
            # Close the connection
            conn.close()
        except pyodbc.Error as e:
            # If login fails, print the error
            print(f"Error logging in to SQL Server instance '{server}': {e}")
            

print("Logins tested. Check the file", output_file, "for successful logins.")