import json
import boto3
import os
import base64

def lambda_handler(event, context):
    print(json.dumps(event))
    aws_region = os.environ['REGION']
    s3_client = boto3.client('s3')
    
    try:
        request_body = json.loads(event['body'])
        user_id = event['requestContext']['authorizer']['claims']['sub']
        expense_id = request_body.get('id')
        
        s3_key = f"tickets/{user_id}/{expense_id}.pdf"
        bucket_name = os.environ['BUCKET_NAME']

        response = s3_client.get_object(Bucket=bucket_name, Key=s3_key)

        pdf_content = response['Body'].read()

        pdf_base64_string = base64.b64encode(pdf_content)

        print(f"PDF File with id {expense_id} Retrieved from S3 bucket for user {user_id}")
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps({
                'file': pdf_base64_string.decode('utf-8')
            })
        }
    except s3_client.exceptions.NoSuchKey:
        print(f"The file does not exist")
        return {
            'statusCode': 404,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps(f"The file does not exist")
        }
    except Exception as e:
        print(f"Error retrieving file from S3 Bucket: {str(e)}")
        
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps(f"Error retrieving file from S3 Bucket: {str(e)}")
        }