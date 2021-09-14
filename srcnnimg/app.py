import base64
from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
from PIL import Image
import io
import model

app = Flask(__name__)
CORS(app)


@app.route('/')
def index():
    return "Used by PixelBoost"


@app.route('/predict', methods=['POST'])
@cross_origin(allow_headers=['Content-Type'])
def refine():
    image_b64 = request.json['image']
    enlarge = request.json['enlarge']

    image_data = base64.b64decode(image_b64)
    image = Image.open(io.BytesIO(image_data))
    image = model.predict(image, enlarge)

    image = Image.fromarray(image.astype("uint8"))
    b = io.BytesIO()
    image.save(b, "JPEG")
    b.seek(0)
    img_base64 = base64.b64encode(b.read()).decode('utf-8')
    return jsonify({'image': str(img_base64)})


if __name__ == '__main__':
    app.run()  # host='0.0.0.0'
