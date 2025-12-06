import boto3
import json
import os

output_bucket = os.environ['OUTPUT_BUCKET']

def handler(event, context):
    s3 = boto3.client('s3')
    bedrock = boto3.client('bedrock-runtime')
    
    record = event['Records'][0]
    bucket_name = record['s3']['bucket']['name']
    file_key = record['s3']['object']['key']
    file_name = file_key.split('/')[-1].split('.')[0] 
    
    print(f"Processing transcript: {file_key}")
    
    file_obj = s3.get_object(Bucket=bucket_name, Key=file_key)
    file_content = file_obj['Body'].read().decode('utf-8')
    transcript_json = json.loads(file_content)
    
    try:
        if 'results' in transcript_json:
            full_text = transcript_json['results']['transcripts'][0]['transcript']
        else:
            print("No transcription results found.")
            return
            
    except KeyError:
        print("Invalid JSON structure")
        return

    prompt = f"""
    You are to summarize the following transcript.
    
    <transcript>
    {full_text}
    </transcript>
    """
    
    body = json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 500,
        "messages": [
            {
                "role": "user",
                "content": [{"type": "text", "text": prompt}]
            }
        ]
    })

    response = bedrock.invoke_model(
        modelId="us.anthropic.claude-haiku-4-5-20251001-v1:0",
        body=body
    )
    
    response_body = json.loads(response['body'].read())
    summary = response_body['content'][0]['text']
    
    print("=== AI GENERATED SUMMARY ===")
    print(summary)
    print("============================")

    body = json.dumps({
        "job_name": file_name,
        "summary": summary
    })

    s3.put_object(
        Bucket=output_bucket,
        Key=f"summary/{file_name}.json",
        Body=body
    )
    
    return {"statusCode": 200, "body": "Summary Generated"}