import boto3
import uuid
import os

def handler(event, context):
    transcribe = boto3.client('transcribe')
    output_bucket = os.environ['OUTPUT_BUCKET']
    
    record = event['Records'][0]
    s3_bucket = record['s3']['bucket']['name']
    s3_key = record['s3']['object']['key']
    
    file_name = s3_key.split('/')[-1].split('.')[0]
    job_name = f"transcribe-{uuid.uuid4()}"
    
    try:
        transcribe.start_transcription_job(
            TranscriptionJobName=job_name,
            Media={'MediaFileUri': f"s3://{s3_bucket}/{s3_key}"},
            MediaFormat='mp3',
            LanguageCode='en-US',
            OutputBucketName=output_bucket,
            OutputKey=f"transcription/{file_name}.json" 
        )
        print(f"Started job: {job_name}")
        return {"statusCode": 200, "body": "Job Started"}
        
    except Exception as e:
        print(f"Error: {e}")
        raise e