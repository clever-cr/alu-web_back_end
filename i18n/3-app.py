#!/usr/bin/env python3
""" Basic Flask app """

from flask import Flask, render_template, request
from flask_babel import Babel

app = Flask(__name__)


class Config:
    """Config class for your application"""
    LANGUAGES = ["en", "fr"]
    BABEL_DEFAULT_LOCALE = "en"
    BABEL_DEFAULT_TIMEZONE = "UTC"


app.config.from_object(Config)
babel = Babel(app)


@babel.localeselector
def get_locale():
    """Get locale for your application"""
    return request.accept_languages.best_match(app.config['LANGUAGES'])


@app.route('/', methods=['GET'], strict_slashes=False)
def home():
    """the return page for the application"""
    return render_template('3-index.html')


if __name__ == "__main__":
    app.run()
