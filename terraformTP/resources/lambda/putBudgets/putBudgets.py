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
    url = os.environ['URL']
    dynamodb = boto3.resource('dynamodb', region_name=aws_region)
    try:
        table = dynamodb.Table(dynamodb_table_name)
        request_body = json.loads(event['body'])
        user_id = event['requestContext']['authorizer']['claims']['sub']

        budget_key = {
            'user_id': user_id,
            'id': request_body.get('id')
        }

        if not request_body.get('budget_file'):
            return {
                'statusCode': 400,
                'headers': {
                    'Access-Control-Allow-Headers': 'Content-Type',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'PUT, OPTIONS'
                },
                'body': json.dumps('Bad Request: No Budget to Update')
            }
        
        pdf_base_64_string = request_body.get('budget_file')
        pdf_content = base64.b64decode(pdf_base_64_string)
        s3_bucket = os.environ['BUCKET_NAME']
        s3_client = boto3.client('s3')
        s3_key = f"{budget_key['user_id']}/{budget_key['id']}.pdf"
        s3_client.put_object(Body=pdf_content, Bucket=s3_bucket, Key=s3_key)

        if request_body.get('name'):
            update_expression = f"SET #attr_name = :new_value"
            expression_attribute_names = {'#attr_name': 'name'}
            expression_attribute_values = {
                ':new_value': f"{request_body.get('name')}",
            }
            table.update_item(
                Key=budget_key,
                UpdateExpression=update_expression,
                ExpressionAttributeValues=expression_attribute_values,
                ExpressionAttributeNames=expression_attribute_names
            )

        print(f"Budget {budget_key['user_id']} - {budget_key['id']} updated successfully.")

        updated_budget_response = table.get_item(Key=budget_key)
        updated_budget = updated_budget_response.get("Item", {})
        updated_budget.pop('user_id', None)

        # Obtener los subscriptores de la base de datos
        response = table.get_item(Key=budget_key)
        budget_item = response.get("Item", {})
        subscribers = budget_item.get("subscribers", [])
        if subscribers:
            sns_client = boto3.client('sns',region_name=aws_region)
            topic_arn = os.environ.get('SNS_TOPIC_ARN')
            budget_id = budget_key['id']
            message = f"The budget to which you subscribed (link: {url}/budgets/{budget_id}) has been updated."

            # Enviar notificación a cada subscriptor
            for subscriber in subscribers:
                print(sns_client)
                response = sns_client.publish(
                    TopicArn=topic_arn,
                    Message=message,
                    Subject='The budget has been updated',
                    MessageAttributes={
                        'email': {
                            'DataType': 'String',
                            'StringValue': subscriber
                        }
                    }
                )
            print(f"Notification sent to {subscriber} successfully.")

        return {
            'statusCode': 201,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'PUT, OPTIONS'
            },
            'body': json.dumps(updated_budget, cls=DecimalEncoder)
        }
    except Exception as e:
        print(f"Error updating budget: {str(e)}")
        
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'PUT, OPTIONS'
            },
            'body': json.dumps(f"Error updating budget: {str(e)}")
        }
