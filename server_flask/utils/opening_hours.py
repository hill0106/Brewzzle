def opens_before_7(opening_hours: dict) -> bool:
    """
    Returns True if on any weekday the place opens strictly before 07:00.
    Expects opening_hours to have a "periods" list with entries:
      { "open": {"day":0..6, "time":"HHMM"}, "close": {...} }
    """
    for period in opening_hours.get("periods", []):
        t = period["open"]["time"]   # e.g. "0600", "0715"
        hour = int(t[:2])
        minute = int(t[2:])
        # time in minutes since midnight
        total_mins = hour * 60 + minute
        if total_mins < 7 * 60:
            return True
    return False

def closes_after_8(opening_hours: dict) -> bool:
    """
    Returns True if on any weekday the place closes strictly after 20:00.
    """
    for period in opening_hours.get("periods", []):
        close = period.get("close")
        if not close:
            # some places are open 24h
            return True
        t = close["time"]  # e.g. "1930", "2130"
        hour = int(t[:2])
        minute = int(t[2:])
        total_mins = hour * 60 + minute
        if total_mins > 20 * 60:
            return True
    return False