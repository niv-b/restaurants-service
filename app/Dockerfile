# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Create a non-root user
RUN useradd --create-home appuser

# Set the working directory inside the container
WORKDIR /app

# Change ownership of the work directory to the non-root user
RUN chown appuser:appuser /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Switch to the non-root user
USER appuser

# Expose the port the app will run on
EXPOSE 6379

# Define the command to run the application
CMD ["python3", "app.py"]
