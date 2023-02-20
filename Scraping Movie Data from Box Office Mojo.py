import csv
import requests
from bs4 import BeautifulSoup

# Set the URL for the year you want to scrape data for
url = "https://www.boxofficemojo.com/year/"

# Make a request to the URL and get the HTML response
response = requests.get(url)

html = response.content

# Parse the HTML response with BeautifulSoup
soup = BeautifulSoup(html, "html.parser")

# Get data
box_office_table = soup.find("div", class_="a-section mojo-body aok-relative").find_all("tr")


with open('7.csv', 'a', newline='') as csvfile:
    writer = csv.writer(csvfile)

    # Write headers to CSV file
    writer.writerow(['numone_release', 'year', 'total_gross', 'releases', 'average', 'gross_change'])
    

    for row in box_office_table:
        try:
            year_cell = row.find("td", class_="a-text-left mojo-header-column mojo-field-type-year mojo-sort-column")
            money_cells = row.find_all("td", class_="a-text-right mojo-field-type-money")
            releases_cell = row.find("td", class_="a-text-right mojo-field-type-positive_integer")
            gross_change_cell = row.find("td", class_="a-text-right mojo-number-delta mojo-field-type-percent_delta")
            numone_release_cell = row.find("td", class_="a-text-left mojo-field-type-release mojo-cell-wide")

            if len(money_cells) >= 2 and year_cell is not None and releases_cell is not None and gross_change_cell is not None and numone_release_cell is not None:
                total_gross_cell = money_cells[0]
                average_cell = money_cells[1]
                year = year_cell.text.strip()
                total_gross = total_gross_cell.text.strip()
                releases = releases_cell.text.strip()
                average = average_cell.text.strip()
                gross_change = gross_change_cell.text.strip()
                numone_release = numone_release_cell.text.strip()
                print(year, total_gross, releases, average, gross_change, numone_release)

                # Write the row to the CSV file
                writer.writerow([numone_release, year, total_gross, releases, average, gross_change])


        except AttributeError:
            # Either a cell is not found
            pass
