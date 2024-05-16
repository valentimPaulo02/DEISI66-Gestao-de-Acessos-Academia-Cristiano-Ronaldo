# Use an official Python runtime as a parent image
FROM python:3.8

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the requirements file into the container
COPY requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY app/ .

# Expose the port that your app will run on (replace 8000 with your actual port)
EXPOSE 5000

# Define the command to run your application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "main:app"]
