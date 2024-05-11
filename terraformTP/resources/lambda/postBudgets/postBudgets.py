import json
import boto3
import os
import uuid
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
    dynamodb = boto3.resource('dynamodb', region_name=aws_region)
    s3_bucket = os.environ['BUCKET_NAME']
    s3_bucket_domain = os.environ['BUCKET_DOMAIN']

    try:
        table = dynamodb.Table(dynamodb_table_name)
        request_body = json.loads(event['body'])
        user_id = event['requestContext']['authorizer']['claims']['sub']
        budget_id = f"budget_{str(uuid.uuid4())}"

        if not request_body.get('budget_file'):
            return {
                'statusCode': 400,
                'body': json.dumps('Bad Request: No Budget to Upload')
            }

        pdf_base_64_string = request_body.get('budget_file')
        pdf_content = base64.b64decode(pdf_base_64_string)

        s3_client = boto3.client('s3')
        s3_key = f"{user_id}/{budget_id}.pdf"
        s3_client.put_object(Body=pdf_content, Bucket=s3_bucket, Key=s3_key)

        budget_name = request_body.get('name')

        budget = {
            'user_id': user_id,
            'id': budget_id,
            'name': budget_name
        }

        table.put_item(Item=budget)
        print(f"Budget added to DynamoDB table '{dynamodb_table_name}': {json.dumps(budget)}")

        budget_key = {
            'user_id': user_id,
            'id': budget_id
        }

        inserted_budget_response = table.get_item(Key=budget_key)
        inserted_budget = inserted_budget_response.get("Item", {})
        inserted_budget.pop('user_id', None)

        return {
            'statusCode': 201,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps(inserted_budget, cls=DecimalEncoder)
        }
    except Exception as e:
        print(f"Error adding budget to DynamoDB: {str(e)}")
        
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps('Error adding budget to DynamoDB')
        }