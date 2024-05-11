import json
import boto3
import os
from decimal import Decimal
import base64

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            if o % 1 == 0:
                return int(o)
            else:
                return float(o)
        return super(DecimalEncoder, self).default(o)

def lambda_handler(event, context):
    print(json.dumps(event))
    aws_region = os.environ['REGION']
    dynamodb_table_name = os.environ['DYNAMODB_TABLE_NAME']
    subscriptions_table_name = os.environ['SUBSCRIPTIONS_TABLE_NAME']
    dynamodb = boto3.resource('dynamodb', region_name=aws_region)
    s3_client = boto3.client('s3')
    
    try:
        table = dynamodb.Table(dynamodb_table_name)
        request_body = json.loads(event['body'])
        user_id = event['requestContext']['authorizer']['claims']['sub']
        user_email = event['requestContext']['authorizer']['claims']['email']
        budget_id = request_body.get('id')

        response = table.get_item(
            Key={
                'user_id': user_id,
                'id': budget_id
            }
        )

        item = response.get('Item')
        if item is None:
            table = dynamodb.Table(subscriptions_table_name)
            response = table.get_item(
                Key={
                    'email': user_email,
                    'budget_id': budget_id
                }
            )
            item = response.get('Item')
            if item is None:
                print(f"User Id {user_id} does not have permissions to retrieve the budget file with id {budget_id}")
                return {
                    'statusCode': 403,
                    'headers': {
                        'Access-Control-Allow-Headers': 'Content-Type',
                        'Access-Control-Allow-Origin': '*',
                        'Access-Control-Allow-Methods': 'POST, OPTIONS'
                    },
                    'body': json.dumps("You do not have permissions to retrieve this file")
                }
        
        
        s3_key = f"{item['user_id']}/{budget_id}.pdf"
        bucket_name = os.environ['BUCKET_NAME']
        response = s3_client.get_object(Bucket=bucket_name, Key=s3_key)

        pdf_content = response['Body'].read()

        pdf_base64_string = base64.b64encode(pdf_content)

        print(f"PDF File with id {budget_id} Retrieved from S3 bucket for user {user_id}")
        
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
            'statusCode': 403,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps("You do not have permissions to retrieve this file")
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