# PixelBoost

A deep learning web application to boost the resolution of images. 

Please use [this link](https://drive.google.com/file/d/1F_FirK_UB-kkZPqriWq3zrME-zEWUJ4Q/view?usp=sharing) to view a short set of pdf slides that walks through the functionality and  development process of **PixelBoost**.

The project is hosted using Heroku and GitHub Pages at https://pixelboost.github.io

# Repo Structure

This repository showcases the three main parts I had to develop for the application: the Jupyter notebook where I developed the model, a folder containing the Flask backend, a folder containing the Flutter frontend, and a folder containing the Docker image and model files responsible for model computations. 

## SRCNN.ipynb

The interactive python notebook where I utilized TensorFlow and numpy to architect, train, test, and compile the convolutional neural network that performs image super resolution.

## srcnnimg

The project for the Flask app responsible for image pre/post-processing. See **srcnnimg/app.py** and **srcnnimg/model.py** for the Python code I wrote.

## pixelboost

The Flutter project used for the website. See **pixelboost/lib/main.dart** and **pixelboost/lib/widgets.dart** for the main Dart code I wrote.

## srcnntf

The files used for a TF Serving Docker image for model predictions.
