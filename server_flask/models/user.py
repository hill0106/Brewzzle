class User:
    def __init__(self, email, password=None, name=None, location=None, default_title=None, favorite_cafe=None, check_in=None, reviews=None, profile_image=None):
        self.email = email
        self.password = password  # hashed password or None for Google users
        self.name = name
        self.location = location
        self.default_title = default_title
        self.favorite_cafe = favorite_cafe or []
        self.check_in = check_in or []
        self.reviews = reviews or []
        self.profile_image = profile_image

    def to_dict(self):
        return {
            'email': self.email,
            'password': self.password,
            'name': self.name,
            'location': self.location,
            'default_title': self.default_title,
            'favorite_cafe': self.favorite_cafe,
            'check_in': self.check_in,
            'reviews': self.reviews,
            'profile_image': self.profile_image
        }

    @staticmethod
    def from_dict(data):
        return User(
            email=data.get('email'),
            password=data.get('password'),
            name=data.get('name'),
            location=data.get('location'),
            default_title=data.get('default_title'),
            favorite_cafe=data.get('favorite_cafe', []),
            check_in=data.get('check_in', []),
            reviews=data.get('reviews', []),
            profile_image=data.get('profile_image')
        )
