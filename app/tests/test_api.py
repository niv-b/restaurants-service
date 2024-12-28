import json
import pytest
from app import app


@pytest.fixture
def client():
    with app.test_client() as client:
        yield client


def test_recommendations_no_style(client):
    """Test the /recommendations endpoint with no style"""
    response = client.get('/recommendations?vegetarian=no')
    data = json.loads(response.data)
    assert response.status_code == 200
    assert "restaurantRecommendation" in data
    assert len(data["restaurantRecommendation"]) > 0


def test_recommendations_with_style(client):
    """Test the /recommendations endpoint with a specific style"""
    client = app.test_client()
    response = client.get('/recommendations?style=Italian&vegetarian=yes')
    data = json.loads(response.data)
    assert response.status_code == 200
    assert "restaurantRecommendation" in data
    assert len(data["restaurantRecommendation"]) > 0
