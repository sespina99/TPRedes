import json
import boto3
import os
#from boto3.dynamodb.conditions import Key
#import logging
from decimal import Decimal
#logging.getLogger().setLevel(logging.DEBUG)
#logging.getLogger("boto3").setLevel(logging.DEBUG)
#logging.getLogger("botocore").setLevel(logging.DEBUG)
class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            if o % 1 == 0:
                return int(o)
            else:
                return float(o)
        return super(DecimalEncoder, self).default(o)


def lambda_handler(event, context):
    topic_arn = os.environ.get('SNS_TOPIC_ARN')
    print(json.dumps(event))
    aws_region = os.environ['REGION']
    dynamodb_table_name = os.environ['DYNAMODB_TABLE_NAME']
    subscriptors_table_name = os.environ['SUBSCRIPTORS_TABLE_NAME']
    dynamodb = boto3.resource('dynamodb', region_name=aws_region)
    request_body = json.loads(event['body'])
    if not request_body.get('emails'):
            return {
                'statusCode': 400,
                'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
                'body': json.dumps('Bad Request: No Emails to add')
            }
    
    if not request_body.get('id'):
            return {
                'statusCode': 400,
                'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
                'body': json.dumps('Bad Request: No bucket id to add subscribers')
            }

    try:
        subscriptors_table = dynamodb.Table(subscriptors_table_name)
        budget_id = request_body.get('id')
        sns_client = boto3.client('sns',region_name=aws_region)
        email = request_body.get('emails')
        user_id = event['requestContext']['authorizer']['claims']['sub']
        response = subscribe_emails_to_sns(email, topic_arn, sns_client, budget_id, subscriptors_table,user_id)
        #TODO: REQUEST BD
        table = dynamodb.Table(dynamodb_table_name)
        budget_key = {
            'user_id': user_id,
            'id': request_body.get('id')
        }

        budget_response = table.get_item(Key=budget_key)
        budget = budget_response.get("Item", {})
        subscribers = budget.get("subscribers", [])
        if email[0] not in subscribers:
            update_expression = "SET subscribers = list_append(if_not_exists(subscribers, :empty_list), :subscriber)"
            expression_attribute_values = {
                ':empty_list': [],
                ':subscriber': email
            }
            # Actualiza el elemento en DynamoDB
            table.update_item(
                Key=budget_key,
                UpdateExpression=update_expression,
                ExpressionAttributeValues=expression_attribute_values
            )


        return response
    except Exception as e:
        #print(f"Error getting budgets from DynamoDB: {str(e)}")
        
        return {
            'statusCode': 500,
            'body': json.dumps(f'{str(e)}')
        }

    
def subscribe_emails_to_sns(emails, topic_arn, sns_client, budget_id, subscriptors_table, user_id):
    try:
        for email in emails:
            response = sns_client.subscribe(
                TopicArn=topic_arn,
                Protocol='email',
                Endpoint=email,
                ReturnSubscriptionArn=True
            )

        subscriptor_key = {
            'email': email,
            'budget_id': budget_id
        }

        subscriptors_table.update_item(
            Key=subscriptor_key,
            UpdateExpression="SET user_id = :user_id",
            ExpressionAttributeValues={":user_id": user_id}
        )

        print(f"Subscribed {email} to SNS topic {topic_arn} with subscription ARN {response.get('SubscriptionArn')}")

        return {
            'statusCode': 201,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body' : json.dumps('Subscribed emails to SNS topic')
        }
    except Exception as e:
        print(f"Error subscribing emails to SNS topic: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps(f"Error subscribing emails to SNS topic: {str(e)}")
        }
