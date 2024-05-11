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
    dynamodb = boto3.resource('dynamodb', region_name=aws_region)
    
    try:
        table = dynamodb.Table(dynamodb_table_name)
        request_body = json.loads(event['body'])
        user_id = event['requestContext']['authorizer']['claims']['sub']

        expense_key = {
            'user_id': user_id,
            'id': request_body.get('id')
        }

        update_expression = "SET "
        expression_attribute_values = {}
        expression_attribute_names = {}

        for key, value in request_body.items():
            if key in ['date', 'category', 'amount', 'description', 'name']:
                attribute_name = f"#attr_{key}"
                update_expression += f"{attribute_name} = :{key}, "
                expression_attribute_values[f":{key}"] = Decimal(value) if isinstance(value, (float, int)) else value
                expression_attribute_names[attribute_name] = key
            elif key == 'bill_file':
                pdf_base_64_string = request_body.get('bill_file')
                pdf_content = base64.b64decode(pdf_base_64_string)
                s3_bucket = os.environ['BUCKET_NAME']
                s3_client = boto3.client('s3')
                s3_key = f"tickets/{expense_key['user_id']}/{expense_key['id']}.pdf"
                s3_client.put_object(Body=pdf_content, Bucket=s3_bucket, Key=s3_key)

                s3_bucket_domain = os.environ['BUCKET_DOMAIN']

                update_expression += "#attr_has_pdf = :has_pdf, "
                expression_attribute_values[":has_pdf"] = True
                expression_attribute_names["#attr_has_pdf"] = "has_pdf"


        update_expression = update_expression.rstrip(', ')

        table.update_item(
            Key=expense_key,
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values,
            ExpressionAttributeNames=expression_attribute_names
        )

        print(f"Expense {expense_key['user_id']} - {expense_key['id']} updated successfully to table '{dynamodb_table_name}'.")

        updated_expense_response = table.get_item(Key=expense_key)
        updated_expense = updated_expense_response.get("Item", {})
        updated_expense.pop('user_id', None)
        return {
            'statusCode': 201,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'PUT, OPTIONS'
            },
            'body': json.dumps(updated_expense, cls=DecimalEncoder)
        }
    except Exception as e:
        print(f"Error updating expense in DynamoDB: {str(e)}")
        
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'PUT, OPTIONS'
            },
            'body': json.dumps(f"Error updating expense in DynamoDB: {str(e)}")
        }
