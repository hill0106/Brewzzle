# api/google_maps.py
from config import gmaps_client

def text_search(query: str) -> dict:
    """
    Perform a text-based search (free-form).
    """
    return gmaps_client.places(query=query)

def nearby_cafes(location: tuple, radius: int = 5000,
                 open_now: bool = None, page_token: str = None) -> dict:
    """
    Search for places of type 'cafe' near a lat/lng.
    - location: (lat, lng)
    - radius: in meters
    - open_now: if True, only return those currently open
    - page_token: for pagination
    """
    params = {
        "location": location,
        "radius": radius,
        "type": "cafe"
    }
    if open_now is True:
        params["open_now"] = True
    if page_token:
        # ignore other params when paging
        return gmaps_client.places_nearby(page_token=page_token)
    return gmaps_client.places_nearby(**params)

def get_open_hours(place_id: str) -> dict:
    """
    Fetches opening_hours for the given place_id.
    Returns the full Place Details response (you’ll extract what you need in the router).
    """
    return gmaps_client.place(
        place_id=place_id,
        fields=["opening_hours"]
    )

def type_search(place_type: str, page_token: str = None) -> dict:
    """
    Search for places by a single type (e.g. "cafe", "restaurant", "bar").
    Optionally accepts a next_page_token for pagination.
    """
    if page_token:
        return gmaps_client.places_nearby(page_token=page_token)
    return gmaps_client.places(
        query=place_type,
        type=place_type
    )

def get_place_details(place_id: str, fields: list[str] = None) -> dict:
    """
    Fetch Place Details for the given place_id.
    `fields` should be a list of Google Places fields you want back,
    e.g. ["name", "formatted_address", "opening_hours", "rating"].
    If None, defaults to a sensible subset.
    """
    if fields is None:
        fields = ["name", "formatted_address", "opening_hours", "rating", "website"]
    return gmaps_client.place(place_id=place_id, fields=fields)