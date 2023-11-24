import requests
import json

# Load country data from the JSON file
with open('data/country.json', 'r') as file:
    countries = json.load(file)

# Initialize an empty list to store city data
all_cities = []

# Iterate through each country
for country in countries:
    country_code = country['iso2']

    # Make the request for cities using the country code
    url = f"https://api.countrystatecity.in/v1/countries/{country_code}/cities"
    headers = {
        "accept": "application/json",
        "X-CSCAPI-KEY": "NHhvOEcyWk50N2Vna3VFTE00bFp3MjFKR0ZEOUhkZlg4RTk1MlJlaA=="
    }

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        # Process the response data and append the ISO2 country code
        cities_data = response.json()
        for city in cities_data:
            city['iso2'] = country_code
        all_cities.extend(cities_data)
    else:
        print(f"Request for {country_code} failed with status code {response.status_code}")

# Save the combined city data to a new JSON file
with open('data/cities.json', 'w') as file:
    json.dump(all_cities, file, indent=2)

print("Cities data has been saved to cities.json")
