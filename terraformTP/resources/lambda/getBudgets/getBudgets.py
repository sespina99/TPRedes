import json
import boto3
import os
from boto3.dynamodb.conditions import Key
from decimal import Decimal

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
        user_id = event['requestContext']['authorizer']['claims']['sub']

        response = table.query(
            KeyConditionExpression=Key('user_id').eq(user_id)
        )

        budgets = response.get('Items', [])
        for budget in budgets:
            budget.pop('user_id', None)


        print(f"Budgets retrieved from DynamoDB table '{dynamodb_table_name}' for user_id {user_id}: {budgets}")

        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, OPTIONS'
            },
            'body': json.dumps(budgets, cls=DecimalEncoder)
        }
    except Exception as e:
        print(f"Error getting budgets from DynamoDB: {str(e)}")
        
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, OPTIONS'
            },
            'body': json.dumps(f'Error getting budgets from DynamoDB: {str(e)}')
        }
