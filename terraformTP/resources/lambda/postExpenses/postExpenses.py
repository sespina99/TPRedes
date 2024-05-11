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

    
    try:
        table = dynamodb.Table(dynamodb_table_name)
        request_body = json.loads(event['body'])
        user_id = event['requestContext']['authorizer']['claims']['sub']
        expense_id = f"expense_{str(uuid.uuid4())}"

        expense = {
            'user_id': user_id,
            'id': expense_id,
            'date': int(request_body.get('date')),
            'category': request_body.get('category'),
            'amount': int(request_body.get('amount')),
            'description': request_body.get('description'),
            'name': request_body.get('name'),
            'has_pdf': False
        }

        if request_body.get('bill_file'):
            pdf_base_64_string = request_body.get('bill_file')
            pdf_content = base64.b64decode(pdf_base_64_string)
            s3_bucket = os.environ['BUCKET_NAME']
            s3_client = boto3.client('s3')
            s3_key = f"tickets/{user_id}/{expense_id}.pdf"
            s3_client.put_object(Body=pdf_content, Bucket=s3_bucket, Key=s3_key)

            s3_bucket_domain = os.environ['BUCKET_DOMAIN']

            expense['has_pdf'] = True

        table.put_item(Item=expense)
        print(f"Expense added to DynamoDB table '{dynamodb_table_name}': {json.dumps(expense)}")

        expense_key = {
            'user_id': user_id,
            'id': expense_id
        }

        inserted_expense_response = table.get_item(Key=expense_key)
        inserted_expense = inserted_expense_response.get("Item", {})
        inserted_expense.pop('user_id', None)
        return {
            'statusCode': 201,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST'
            },
            'body': json.dumps(inserted_expense, cls=DecimalEncoder)
        }
    except Exception as e:
        print(f"Error adding expense to DynamoDB: {str(e)}")
        
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST'
            },
            'body': json.dumps('Error adding expense to DynamoDB')
        }
