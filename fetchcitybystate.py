import requests
import json
from tqdm import tqdm

# Load state data from the JSON file
with open('data/states.json', 'r', encoding='utf-8') as file:
    states = json.load(file)

# Initialize a dictionary to store city data organized by state_code
all_cities = {}

# Define the tqdm progress bar
progress_bar = tqdm(states, desc="Processing States", unit="state")

# Iterate through each state with tqdm for progress bar
for state in progress_bar:
    state_code = state['iso2']  # Replace 'iso2' with the correct key for the state code
    country_code = state['country_code']

    # Make the request for cities using the country code and state code
    url = f"https://api.countrystatecity.in/v1/countries/{country_code}/states/{state_code}/cities"
    headers = {
        "accept": "application/json",
        "X-CSCAPI-KEY": "NHhvOEcyWk50N2Vna3VFTE00bFp3MjFKR0ZEOUhkZlg4RTk1MlJlaA=="
    }

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        # Process the response data and organize it by state_code
        cities_data = response.json()
        city_names = [city['name'] for city in cities_data]

        # Store the city names in the dictionary using the state_code as the key
        all_cities[state_code] = city_names
    else:
        print(f"Request for {country_code}/{state_code} failed with status code {response.status_code}")

# Save the organized city data to a new JSON file
with open('citiesbystate.json', 'w') as file:
    json.dump(all_cities, file, indent=2)

print("Cities data has been saved to citiesbystate.json")
