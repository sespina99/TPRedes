import json
import boto3
import os

def lambda_handler(event, context):
    print(json.dumps(event))
    aws_region = os.environ['REGION']
    dynamodb_table_name = os.environ['DYNAMODB_TABLE_NAME']
    dynamodb = boto3.resource('dynamodb', region_name=aws_region)
    
    try:
        table = dynamodb.Table(dynamodb_table_name)
        request_body = json.loads(event['body'])
        user_id = event['requestContext']['authorizer']['claims']['sub']

        expense_key = {
            'user_id': user_id,
            'id': request_body.get('id')
        }

        table.delete_item(
            Key=expense_key
        )

        s3_bucket = os.environ['BUCKET_NAME']
        s3_client = boto3.client('s3')
        s3_key = f"tickets/{expense_key['user_id']}/{expense_key['id']}.pdf"

        s3_client.delete_object(
            Bucket=s3_bucket,
            Key=s3_key
        )

        print(f"Expense {expense_key['user_id']} - {expense_key['id']} deleted from DynamoDB table '{dynamodb_table_name}'.")
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'DELETE, OPTIONS'
            },
            'body': json.dumps(f"Expense {expense_key['id']} deleted successfully from table '{dynamodb_table_name}'.")
        }
    except Exception as e:
        print(f"Error deleting expense from DynamoDB: {str(e)}")
        
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'DELETE, OPTIONS'
            },
            'body': json.dumps(f'Error deleting expense from DynamoDB: {str(e)}')
        }
