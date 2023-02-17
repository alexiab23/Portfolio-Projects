# Import all packages needed
import requests
from bs4 import BeautifulSoup
from csv import writer
import os

# Create variables
HEADER = {'Accept-Language': 'en-US',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'}
url = "https://www.zillow.com/homes/Atlanta/"
page = requests.get(url, headers=HEADER)
soup = BeautifulSoup(page.content, 'html.parser')
lists = soup.find_all('article', class_="list-card")

# Write to CSV file
directory = r'C:\Users\alexi\Desktop'
filename = 'atlga_housing.csv'

try:
    with open(os.path.join(directory, filename), 'w', encoding='utf8', newline='') as f:
        thewriter = writer(f)
        headings = ['price', 'address', 'home_type', 'realty_property']
        thewriter.writerow(headings)

        for li in lists[:2360]:
            price = li.find('div', class_="list-card-price").text
            address = li.find('address', class_="list-card-addr").text
            home_type = li.find('div', class_="list-card-type").text
            realty_property = li.find('ul', class_="list-card-details").find_all('li')[1].text.strip()

            info = [price, address, home_type, realty_property]
            thewriter.writerow(info)

        print('CSV file has been exported to', os.path.join(directory, filename))

except FileNotFoundError:
    print('The specified directory does not exist.')
except PermissionError:
    print('You do not have permission to write to this directory.')
except Exception as e:
    print('An error occurred:', e)

