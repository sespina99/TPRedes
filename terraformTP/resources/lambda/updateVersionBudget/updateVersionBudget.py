import json
import boto3
import os

def lambda_handler(event, context):
    print(json.dumps(event))
    topic_arn = os.environ.get('SNS_TOPIC_ARN')
    aws_region = os.environ['REGION']
    dynamodb_table_name = os.environ['DYNAMODB_TABLE_NAME']
    dynamodb = boto3.resource('dynamodb', region_name=aws_region)

    try:
        table = dynamodb.Table(dynamodb_table_name)
        subscribers_table_name = os.environ['SUBSCRIPTORS_TABLE_NAME']
        table_subscribers = dynamodb.Table(subscribers_table_name)
        request_body = json.loads(event['body'])
        url = os.environ['URL']
        user_id = event['requestContext']['authorizer']['claims']['sub']

        budget_key = {
            'user_id': user_id,
            'id': request_body.get('id')
        }

        s3_bucket = os.environ['BUCKET_NAME']
        s3_client = boto3.client('s3')
        s3_key = f"{budget_key['user_id']}/{budget_key['id']}.pdf"

        versions = s3_client.list_object_versions(
            Bucket=s3_bucket,
            Prefix=s3_key
        )
        
        sorted_versions = sorted(versions.get('Versions', []), key=lambda x: x['LastModified'], reverse=True)
        
        if len(sorted_versions) == 1:
            return {
                'statusCode': 400,
                'headers': {
                    'Access-Control-Allow-Headers': 'Content-Type',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'PUT, OPTIONS'
                },
                'body': json.dumps("The Budget File does not have previous versions.")
            }
            
        print(sorted_versions)
        latest_version = sorted_versions[0] if sorted_versions else None
        print(latest_version)
        if latest_version:
            s3_client.delete_object(Bucket=s3_bucket, Key=s3_key, VersionId=latest_version['VersionId'])

        print(f"Budget Version {budget_key['user_id']} - {budget_key['id']} deleted from S3 Bucket.")

         # Obtener los subscriptores de la base de datos
        print("subscriptores")
        budget_key = {
            'user_id': user_id,
            'id': request_body.get('id')
        }
        response = table.get_item(Key=budget_key)
        budget_item = response.get("Item", {})
        subscribers = budget_item.get("subscribers", [])
        if subscribers:
            sns_client = boto3.client('sns',region_name=aws_region)
            topic_arn = os.environ.get('SNS_TOPIC_ARN')
            budget_id = budget_key['id']
            message = f"The version of the budget to which you subscribed (link: {url}/budgets/{budget_id}) has been updated."

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
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'PUT, OPTIONS'
            },
            'body': json.dumps(f"Budget Version reverted sucesfully.")
        }
    except Exception as e:
        print(f"Error deleting budget version from S3 Bucket: {str(e)}")

        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'PUT, OPTIONS'
            },
            'body': json.dumps(f"Error deleting budget version from S3 Bucket: {str(e)}")   
        }
