import os
import json
import boto3
import pandas as pd
from io import StringIO

from dotenv import load_dotenv
load_dotenv()

# Inicializar cliente S3
s3 = boto3.client('s3')

# Leer variables de entorno
SOURCE_BUCKET = os.environ.get("SOURCE_BUCKET")
SOURCE_KEY = os.environ.get("SOURCE_KEY")
DESTINATION_BUCKET = os.environ.get("DESTINATION_BUCKET")
DESTINATION_KEY = os.environ.get("DESTINATION_KEY")

def main():
    print(f"Extrayendo archivo de S3: s3://{SOURCE_BUCKET}/{SOURCE_KEY}")

    # Paso 1: Leer JSON desde S3
    json_obj = s3.get_object(Bucket=SOURCE_BUCKET, Key=SOURCE_KEY)
    json_data = json_obj["Body"].read().decode("utf-8")

    # Paso 2: Parsear JSON
    json_content = json.loads(json_data)

    # Si el JSON es un objeto con una lista de resultados
    if isinstance(json_content, dict) and "results" in json_content:
        df = pd.DataFrame(json_content["results"])
    # Si ya es lista de objetos
    elif isinstance(json_content, list):
        df = pd.DataFrame(json_content)
    # Si es un solo objeto
    else:
        df = pd.DataFrame([json_content])

    print(f"Transformando datos... Filas: {len(df)}")

    # Paso 3: Convertir a CSV
    csv_buffer = StringIO()
    df.to_csv(csv_buffer, index=False)

    # Paso 4: Subir CSV al bucket destino
    s3.put_object(
        Bucket=DESTINATION_BUCKET,
        Key=DESTINATION_KEY,
        Body=csv_buffer.getvalue()
    )

    print(f"Archivo convertido y guardado en s3://{DESTINATION_BUCKET}/{DESTINATION_KEY}")

if __name__ == "__main__":
    main()
