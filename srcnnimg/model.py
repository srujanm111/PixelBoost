import numpy as np
import cv2 as cv
import json
import requests
from PIL import Image
import io
import base64

scale = 2
predict_url = 'https://srcnntf.herokuapp.com/v1/models/srcnn:predict'


def mod_crop(image):
    size = image.shape
    size -= np.mod(size, scale)
    image = image[0:size[0], 0:size[1]]
    return image


def shave(image, border):
    return image[border:-border, border:-border]


def srcnn(image):
    image = Image.fromarray(image.astype("uint8"))
    b = io.BytesIO()
    image.save(b, "JPEG")
    b.seek(0)
    img_base64 = base64.b64encode(b.read()).decode('utf-8')
    data = json.dumps({'instances': [
        {
            'b64': str(img_base64)
        },
    ]})

    headers = {"content-type": "application/json"}

    response = requests.post(predict_url, data=data, headers=headers)
    output = json.loads(response.text)['predictions']

    return np.array(output)


def predict(data, enlarge):
    image = np.array(data, dtype=np.uint8)

    if enlarge:
        image = cv.resize(image, (0, 0), fx=scale, fy=scale, interpolation=cv.INTER_CUBIC)

    output = srcnn(image)
    output = output[0, :, :, 0] * 255

    image = cv.cvtColor(image, cv.COLOR_RGB2YCrCb)

    output_image = np.zeros((output.shape[0], output.shape[1], 3))
    output_image[:, :, 0] = output
    output_image[:, :, 1:3] = shave(image[:, :, 1:3], 6)
    output_image = cv.cvtColor(np.uint8(output_image), cv.COLOR_YCrCb2RGB)

    return output_image
