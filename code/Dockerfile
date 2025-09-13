FROM python:3.12-slim

# Instalar dependencias
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copiar el script ETL
COPY app.py .

# Copiar .env (opcional, solo en dev; en AWS Batch mejor pasar como variables de entorno)
COPY .env .env

# Cargar variables de entorno
RUN pip install python-dotenv

# Comando de ejecución
CMD ["python3", "app.py"]
