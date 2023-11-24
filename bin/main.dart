import 'dart:convert';
import 'dart:io';
import 'package:alfred/alfred.dart';

/// Handles the request to get all countries.

void getAllCountriesHandler(HttpRequest req, HttpResponse res) {
  try {
    // Read the content of the JSON file
    String jsonContent = File('../data/country.json').readAsStringSync();

    // Set the response content type to JSON
    res.headers.contentType = ContentType.json;

    // Write the JSON string to the response
    res.write(jsonContent);
  } catch (e) {
    // Handle errors
    res.statusCode = HttpStatus.internalServerError;
    res.write(jsonEncode({'error': '$e'}));
  } finally {
    // Close the response
    res.close();
  }
}

//
void getStatesByCountryCodeHandler(HttpRequest req, HttpResponse res) {
  final countryCode = req.uri.queryParameters['country_code'];
  if (countryCode == null) {
    res.statusCode = HttpStatus.badRequest;
    res.write('Missing country_code parameter');
    res.close();
    return;
  }
  final states = getStatesByCountryCode(countryCode);
  final jsonResponse = jsonEncode(states);
  // Set the response content type to JSON
  res.headers.contentType = ContentType.json;

  // Write the JSON string to the response
  res.write(jsonResponse);

  // Close the response
  res.close();
}

List<Map<String, dynamic>> getStatesByCountryCode(String countryCode) {
  final jsonString = File('../data/states.json').readAsStringSync();
  final List<dynamic> jsonData = jsonDecode(jsonString);
  // Filter states by country_code
  final List<Map<String, dynamic>> states = jsonData
      .where((state) => state['country_code'] == countryCode)
      .toList()
      .cast<Map<String, dynamic>>();

  return states;
}

/// Gets a list of cities for the given country code.

List<Map<String, dynamic>> getCitiesByCountryCode(String countryCode) {
  final jsonString = File('../data/cities.json').readAsStringSync();
  final List<dynamic> jsonData = jsonDecode(jsonString);
  // Filter states by country_code
  final List<Map<String, dynamic>> cities = jsonData
      .where((cities) => cities['iso2'] == countryCode)
      .toList()
      .cast<Map<String, dynamic>>();

  return cities;
}

//cities handler
void getCitiesByCountryCodeHandler(HttpRequest req, HttpResponse res) {
  final countryCode = req.uri.queryParameters['country_code'];
  if (countryCode == null) {
    res.statusCode = HttpStatus.badRequest;
    res.write('Missing country_code parameter');
    res.close();
    return;
  }
  final cities = getCitiesByCountryCode(countryCode);
  final jsonResponse = jsonEncode(cities);
  // Set the response content type to JSON
  res.headers.contentType = ContentType.json;

  // Write the JSON string to the response
  res.write(jsonResponse);

  // Close the response
  res.close();
}

void main() async {
  final app = Alfred();
  app.get('/get-all-countries', getAllCountriesHandler);
  app.get('/get-states-by-country', getStatesByCountryCodeHandler);
  app.get('/get-cities-by-country', getCitiesByCountryCodeHandler);

  await app.listen();
}
