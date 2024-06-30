###############################################################################
# Builds a Excel File with a list of SQL Server instances, and information    #
# about databases, licenses                                                   #
#                                                                             #
###############################################################################

import pyodbc
import openpyxl
from openpyxl.styles import Font

# Open the text file containing server names
input_file = 'sqlsrvinstancesList.txt'
with open(input_file, 'r') as file:
    # Read lines from the file
    servers = file.readlines()

# Connection parameters
username='username'
password='password'

#Create a new Excel Workbook
wb= openpyxl.Workbook()

#Select the active sheet
ws=wb.active

header=['Server', 'Instance','Version','Database']
ws.append(header)

for cell in ws[1]:
    cell.font = Font(bold=True)

# Loop through the servers
for server in servers:
    try:
        server = server.strip()
    # Connect to the server
        conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';UID='+username+';PWD='+password)

    # Create a cursor
        cursor = conn.cursor()
    # Query to retrieve SQL Server instances
        sql_instances_query = "SELECT @@servername AS ServerName, @@servicename AS InstanceName, @@version AS Version"

    # Execute the query
        cursor.execute(sql_instances_query)

        # Fetch the results
        instances = cursor.fetchall()

        # Write the server info to the Excel file
        for instance in instances:
            ws.append([instance.ServerName, instance.InstanceName, instance.Version, ''])

        # Query to retrieve databases
        databases_query = "SELECT name AS DatabaseName FROM sys.databases"

        # Execute the query
        cursor.execute(databases_query)

        # Fetch the results
        databases = cursor.fetchall()

        # Write the database info to the Excel file
        for db in databases:
            ws.append(['', '', '', db.DatabaseName])
           
        # Close the cursor and connection
        cursor.close()
        conn.close()

    except pyodbc.Error as e:
        print("Error connecting to", server+":", e)   

output_file="sql_server_info.xlsx"
wb.save(output_file)
print("Excel File has generated")