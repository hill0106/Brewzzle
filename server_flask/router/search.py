# router/search.py
from flask import Blueprint, request, jsonify, abort
from api.google_maps import get_place_details, nearby_cafes, text_search, type_search , get_open_hours
from utils.opening_hours import opens_before_7, closes_after_8

bp = Blueprint("search", __name__, url_prefix="/search")

def parse_latlng(s: str):
    try:
        lat_str, lng_str = s.split(",", 1)
        return float(lat_str), float(lng_str)
    except Exception:
        abort(400, "Invalid location format. Use 'lat,lng'")

@bp.route("", methods=["GET"])
def search_places():
    query = request.args.get("query", "").strip()
    if not query:
        abort(400, "Missing required parameter: query")

    # If the client explicitly wants the next page, allow that:
    token = request.args.get("next_page_token")
    if token:
        res = nearby_search(token)
    else:
        res = text_search(query)

    return jsonify(res)


@bp.route("/type", methods=["GET"])
def search_by_type():
    """
    GET /search/type?type=cafe[&next_page_token=XYZ]
    - type            (required): one of Google Place Types, e.g. "cafe"
    - next_page_token (optional): for pagination

    Returns a filtered list of places matching that type.
    """
    place_type = request.args.get("type", "").strip().lower()
    token      = request.args.get("next_page_token", None)

    if not place_type:
        abort(400, "Missing required parameter: type")

    # Call our new API function
    res = type_search(place_type, page_token=token)
    raw = res.get("results", [])

    # Simplify the output
    results = []
    for place in raw:
        results.append({
            "place_id": place.get("place_id"),
            "name":     place.get("name"),
            "address":  place.get("formatted_address"),
            "open_now": place.get("opening_hours", {}).get("open_now")
        })

    return jsonify({
        "type":            place_type,
        "next_page_token": res.get("next_page_token"),
        "results":         results
    })

@bp.route("/open", methods=["GET"])
def open_status():
    """
    GET /open?type=cafe[&next_page_token=XYZ][&filter=openNow|before7|after8]
      - type            (optional, default="cafe")
      - next_page_token (optional, for pagination)
      - filter          (optional):
           openNow  → only include places currently open
           before7  → only include places that open before 7 AM any day
           after8   → only include places that close after 8 PM any day
    """
    place_type = request.args.get("type", "cafe").strip().lower()
    token      = request.args.get("next_page_token")
    filter_opt = request.args.get("filter", "").strip().lower()

    # 1) Fetch a page of places of that type
    resp = type_search(place_type=place_type, page_token=token)
    results = resp.get("results", [])

    filtered = []
    for place in results:
        pid        = place.get("place_id")
        oh_summary = place.get("opening_hours", {})

        # apply the requested filter
        if filter_opt == "opennow":
            if not oh_summary.get("open_now"):
                continue

        elif filter_opt in ("before7", "after8"):
            # need full hours from Place Details
            details = get_open_hours(pid)
            oh = details.get("result", {}).get("opening_hours", {})

            if filter_opt == "before7" and not opens_before_7(oh):
                continue
            if filter_opt == "after8"  and not closes_after_8(oh):
                continue

        # passed filter (or no filter at all)
        filtered.append({
            "place_id":    pid,
            "name":        place.get("name"),
            "address":     place.get("formatted_address", place.get("vicinity")),
            "open_now":    oh_summary.get("open_now")
        })

    return jsonify({
        "type":            place_type,
        "filter":          filter_opt or None,
        "next_page_token": resp.get("next_page_token"),
        "results":         filtered
    })

@bp.route("/place", methods=["GET"])
def place_lookup():
    """
    GET /place?place_id=XYZ[&fields=name,address,rating]
      - place_id (required)
      - fields   (optional, comma-separated list of Places API fields)
    
    Returns the Place Details `result` for that ID.
    """
    place_id = request.args.get("place_id", "").strip()
    if not place_id:
        abort(400, "Missing required parameter: place_id")

    # parse optional fields list
    fields_param = request.args.get("fields", "").strip()
    if fields_param:
        fields = [f.strip() for f in fields_param.split(",") if f.strip()]
    else:
        fields = None

    details = get_place_details(place_id, fields)
    result  = details.get("result", {})
    if not result:
        abort(404, "No place found for that place_id")

    return jsonify(result)

@bp.route("/nearby", methods=["GET"])
def search_nearby_cafes():
    """
    GET /nearby?location=lat,lng[&radius=5000][&open_now=true][&next_page_token=XYZ]
      - location        (required): "lat,lng"
      - radius          (optional): meters, default 5000
      - open_now        (optional): "true" or "false"
      - next_page_token (optional): for pagination
    """
    loc = request.args.get("location", "").strip()
    if not loc:
        abort(400, "Missing required parameter: location")
    try:
        lat_str, lng_str = loc.split(",", 1)
        location = (float(lat_str), float(lng_str))
    except ValueError:
        abort(400, "Invalid location format. Use 'lat,lng'")

    radius = request.args.get("radius", type=int, default=5000)
    open_now_param = request.args.get("open_now", "").strip().lower()
    open_now = True if open_now_param == "true" else None

    token = request.args.get("next_page_token", None)

    res = nearby_cafes(location=location,
                       radius=radius,
                       open_now=open_now,
                       page_token=token)

    raw = res.get("results", [])
    simplified = []
    for place in raw:
        simplified.append({
            "place_id": place.get("place_id"),
            "name":     place.get("name"),
            "vicinity": place.get("vicinity"),          # address snippet
            "open_now": place.get("opening_hours", {}) \
                              .get("open_now", None)
        })

    return jsonify({
        "location":       f"{location[0]},{location[1]}",
        "radius":         radius,
        "open_now":       open_now,
        "next_page_token": res.get("next_page_token"),
        "results":        simplified
    })