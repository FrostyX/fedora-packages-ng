from flask_wtf import FlaskForm
from wtforms import StringField
from wtforms.validators import DataRequired, Regexp
from flask_wtf_decorators import FormValidator


validator = FormValidator()


class Search(FlaskForm):
    package_name = StringField("Package name", validators=[
        DataRequired(message="Package name is required"),
        Regexp("^[a-zA-Z0-9-_]+$", message="Package names contain only alphanumeric characters and separators"),
    ])
