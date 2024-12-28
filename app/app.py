from flask import Flask, request, jsonify
import json
from datetime import datetime

app = Flask(__name__)


# Load the restaurant data from the JSON file
def load_restaurants():
    with open('data/restaurants.json', 'r') as f:
        return json.load(f)


# Function to check if the restaurant is open
def is_open(open_hour, close_hour, current_time):
    open_time = datetime.strptime(open_hour, '%H:%M').time()
    close_time = datetime.strptime(close_hour, '%H:%M').time()
    return open_time <= current_time <= close_time


@app.route('/')
def hello():
    return "Hello, welcome to the Restaurants API! Created by NivB 🍕"


@app.route('/recommendations', methods=['GET'])
def get_recommendations():
    # Retrieve query parameters
    style = request.args.get('style')
    vegetarian = request.args.get('vegetarian')
    delivery = request.args.get('delivery')

    # Get the current time
    current_time = datetime.now().time()

    # Load the restaurant data
    restaurants = load_restaurants()

    print(current_time)
    # Filter restaurants based on the query parameters and opening hours
    filtered_restaurants = [
        restaurant for restaurant in restaurants
        if (not style or restaurant["style"].lower() == style.lower()) and
           (not vegetarian or restaurant["vegetarian"].lower() == vegetarian.lower()) and
           (not delivery or restaurant["delivers"].lower() == delivery.lower()) and
           is_open(restaurant["open_hour"], restaurant["close_hour"], current_time)
    ]

    # If no restaurants match the criteria
    if not filtered_restaurants:
        return jsonify({"message": "No matching restaurants found."}), 404

    # Prepare the response
    recommendations = [{
        "name": restaurant["name"],
        "style": restaurant["style"],
        "address": restaurant["address"],
        "openHour": restaurant["open_hour"],
        "closeHour": restaurant["close_hour"],
        "vegetarian": restaurant["vegetarian"]
    } for restaurant in filtered_restaurants]

    return jsonify({"restaurantRecommendation": recommendations})


if __name__ == '__main__':
    app.run(debug=True)
