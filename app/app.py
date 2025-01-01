from flask import Flask, request, jsonify
import json
from datetime import datetime
import os
from azure.cosmos import CosmosClient, PartitionKey

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

    # Prepare request data for logging
    request_data = {
        "style": style,
        "vegetarian": vegetarian,
        "delivery": delivery
    }

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
        log_to_cosmos(request_data, jsonify({"message": "No matching restaurants found."}))
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

    log_to_cosmos(request_data, recommendations)
    return jsonify({"restaurantRecommendation": recommendations})


# Initialize Cosmos DB client
def initialize_cosmos_client():
    try:
        with open('/mnt/secrets-store/CosmosEndpoint', 'r') as f:
            cosmos_endpoint = f.read().strip()

        cosmos_key = os.getenv('COSMOS_KEY')
        if not cosmos_key:
            raise RuntimeError("COSMOS_KEY environment variable is missing")

        return CosmosClient(cosmos_endpoint, credential=cosmos_key)
    except Exception as e:
        raise RuntimeError(f"Failed to initialize Cosmos DB client: {e}")


# Get reference to the database and container
def get_cosmos_container(client):
    cosmos_db_name = os.getenv('COSMOS_DB_NAME', 'restaurantssapp')
    cosmos_container_name = os.getenv('COSMOS_CONTAINER_NAME', 'requestslogs')

    database = client.create_database_if_not_exists(id=cosmos_db_name)
    container = database.create_container_if_not_exists(
        id=cosmos_container_name,
        partition_key=PartitionKey(path='/id')
    )
    return container


# Function to log data to Cosmos DB
def log_to_cosmos(request_data, response_data):
    try:
        cosmos_client = initialize_cosmos_client()
        container = get_cosmos_container(cosmos_client)

        log_entry = {
            "id": datetime.utcnow().isoformat(),
            "timestamp": datetime.utcnow().isoformat(),
            "request": request_data,
            "response": response_data
        }

        container.upsert_item(log_entry)
    except Exception as e:
        app.logger.error(f"Failed to log to Cosmos DB: {e}")


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
