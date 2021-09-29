from flask import Flask, request
import boto3
import os
import sys
from datetime import datetime

app = Flask(__name__)
currenttime= datetime.now().strftime("%Y_%m_%d-%I_%M_%S_%p")
currentfile= currenttime + '-file'

@app.route('/') 
def index():
    with open(currentfile, 'w') as f:
        f.write('File created on' + currenttime)
    s3 = boto3.resource('s3')
    s3.meta.client.upload_file(currentfile, os.environ.get('S3Bucket'), currentfile)

    return '''<h1>File saved to S3</h1>
	<h1>Do you need to upload any other file</h1>
	<form method=POST enctype=multipart/form-data action="upload">
    <input type="text" name="myfile">
    <input type="submit">
    </form>'''

@app.route('/upload', methods=['POST'])
def upload():
    filepath = request.form['filepath']
    s3 = boto3.resource('s3')
    s3.meta.client.upload_file(filepath, os.environ.get('S3Bucket'), currentfile)
    return '<h1>File saved to S3</h1>'

if __name__ == '__main__':
    app.run(port=5000,debug=True,use_reloader=True,reloader_interval=360)